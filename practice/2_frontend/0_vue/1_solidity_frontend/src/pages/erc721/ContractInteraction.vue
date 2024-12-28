<template>
  <div class="container">
    <h2>Interact with ERC721</h2>

    <!-- <div class="form-group">
      <label for="userAddress">User Address</label>
      <input v-model="userAddress" placeholder="Enter User Address" />
    </div> -->

    <div class="form-group">
      <label for="method">Select Method</label>
      <select v-model="selectedMethod">
        <option v-for="method in methods" :key="method" :value="method">{{ method }}</option>
      </select>
    </div>

    <div v-if="selectedMethod === 'approve'" class="form-group">
      <label>Address to Approve</label>
      <input v-model="approveData.to" placeholder="Address" />
      <label>Token ID</label>
      <input v-model="approveData.tokenId" placeholder="Token ID" type="number" />
    </div>

    <div v-if="selectedMethod === 'transferFrom'" class="form-group">
      <label>From Address</label>
      <input v-model="transferData.from" placeholder="From Address" />
      <label>To Address</label>
      <input v-model="transferData.to" placeholder="To Address" />
      <label>Token ID</label>
      <input v-model="transferData.tokenId" placeholder="Token ID" type="number" />
    </div>

    <div v-if="selectedMethod === 'awardItem'" class="form-group">
      <label>tokenUri</label>
      <input v-model="awardItem.tokenUri" placeholder="tokenUri" />
    </div>

    <div v-if="selectedMethod === 'ownerOf'" class="form-group">
      <label>Token ID</label>
      <input v-model="ownerOf.tokenId" placeholder="Token ID" />
    </div>

    <button class="btn" @click="executeMethod">Execute</button>

    <div v-if="result" class="result">
      <h3>Result</h3>
      <pre>{{ result }}</pre>
    </div>
  </div>
</template>

<script>
import { ethers } from 'ethers';
import abiPath from '/home/ccacr/project/upchain_course/practice/1_solidity_projects/out/NFT.sol/NFTERC721.json'; // 拼接路径
import contractAddressPath from '/home/ccacr/project/upchain_course/practice/1_solidity_projects/broadcast/DeployNFTStore.s.sol/31337/run-latest.json'; // 拼接路径

function decodeContractError(contract, errorData) {
  const contractInterface = contract.interface;
  const selecter = errorData.slice(0, 10);
  const errorFragment = contractInterface.getError(selecter);
  const res = contractInterface.decodeErrorResult(errorFragment, errorData);
  const errorInputs = errorFragment.inputs;

  let message;
  if (errorInputs.length > 0) {
    message = errorInputs.map((input, index) => {
      return `${input.name}: ${res[index].toString()}`;
    }).join(', ');
  }

  throw new Error(`${errorFragment.name} | ${message ? message : ""}`);
}


export function handleError(contract, error) {

  if (error.error?.data) {
    console.log(1);
    decodeContractError(contract, error.data.data)
  } else if (error.error?.data?.data) {
    console.log(1);
    decodeContractError(contract, error.error.data.data);
  } else if (error.error?.error?.error?.data) {
    console.log(2);
    decodeContractError(contract, error.error.error.error.data);
  } else {
    console.log(3);
    throw error
  }
}

const erc721Abi = abiPath.abi; // 获取 ABI 数据
const contractAddress = contractAddressPath.transactions
  .filter(transaction => transaction.contractName === "NFTERC721")
  .map(transaction => transaction.contractAddress)[0];// 获取 合约地址 数据


export default {
  data() {
    return {
      selectedMethod: '',
      result: null,
      methods: ['approve', 'transferFrom', 'balanceOf', 'ownerOf', 'awardItem'],
      approveData: {
        to: '',
        tokenId: '',
      },
      transferData: {
        from: '',
        to: '',
        tokenId: '',
      },
      awardItem: {
        player: '',
        tokenUri: '',
      },
      ownerOf: {
        tokenId: '',
      },
    };
  },
  created() {
    this.connect();
  },
  methods: {
    async connect() {
      if (!this.account) {
        await this.initProvider();
        await this.initAccount();
      }
      if (this.account) {
        this.initContract();
      }
    },

    async initProvider() {
      if (window.ethereum) {
        this.provider = new ethers.providers.Web3Provider(window.ethereum);
        this.rpcProvider = new ethers.providers.JsonRpcProvider(window.ethereum);
        let network = await this.provider.getNetwork();
        this.chainId = network.chainId;
      } else {
        console.error("MetaMask is required.");
      }
    },

    async initAccount() {
      try {
        this.accounts = await this.provider.send("eth_requestAccounts", []);
        this.account = this.accounts[0];
        console.log("this.account", this.account);
        this.signer = this.provider.getSigner();
      } catch (error) {
        console.error("User denied account access", error);
      }
    },

    async initContract() {
      console.log("this.contractAddress", contractAddress);
      console.log("this.Abi", erc721Abi);
      this.contract = new ethers.Contract(contractAddress, erc721Abi, this.provider.getSigner());
    },

    async executeMethod() {
      try {
        if (!window.ethereum) throw new Error('MetaMask is not installed!');
        if (this.selectedMethod === 'approve') {
          const tx = await this.contract.approve(this.approveData.to, this.approveData.tokenId);
          this.result = await tx.wait();
        } else if (this.selectedMethod === 'transferFrom') {
          const tx = await this.contract.transferFrom(
            this.transferData.from,
            this.transferData.to,
            this.transferData.tokenId
          );
          this.result = await tx.wait();
        } else if (this.selectedMethod === 'balanceOf') {
          const balance = await this.contract.balanceOf(this.account);
          this.result = balance.toString();
        } else if (this.selectedMethod === 'ownerOf') {
          const owner = await this.contract.ownerOf(ethers.utils.parseUnits(this.ownerOf.tokenId, 18));
          this.result = owner;
        } else if (this.selectedMethod === 'awardItem') {
          console.log(this.account);
          console.log(this.awardItem.tokenUri);
          const owner = await this.contract.awardItem(this.account, this.awardItem.tokenUri);
          this.result = owner;
        }
      } catch (error) {
        // console.error(error);
        // this.result = rpcProvider.decode(error);
        if (error.data.data && this.contract) {
          console.log(1111)
          const decodedError = this.contract.interface.parseError(error.data.data);
          console.log(`Error decoded in contract:`, decodedError);
        } else {
          //If no specific error information is available, 
          //a generic error message is logged to the console.
          console.log(`Error in contract:`, error);
        }
      }
    },
  },
};
</script>

<style>
.container {
  max-width: 600px;
  margin: 2rem auto;
  padding: 2rem;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.form-group {
  margin-bottom: 1rem;
}

input,
select {
  width: 100%;
  padding: 0.5rem;
  margin-top: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.btn {
  display: block;
  width: 100%;
  padding: 0.75rem;
  margin-top: 1rem;
  background: #007aff;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
}

.btn:hover {
  background: #005bb5;
}

.result {
  margin-top: 2rem;
  padding: 1rem;
  background: #f0f0f0;
  border-radius: 4px;
}
</style>