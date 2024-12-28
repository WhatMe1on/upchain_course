<template>
  <div class="app-container">
    <header class="header">
      <h1>ERC2612 Wallet Interface</h1>
    </header>

    <main class="content">
      <section class="wallet-section">
        <button class="btn-primary" @click="connect">Connect Wallet</button>
        <p><strong>My Address:</strong> {{ account }}</p>
        <p><strong>ETH Balance:</strong> {{ ethbalance }}</p>
      </section>

      <section class="token-section">
        <h2>Token Details</h2>
        <p><strong>Name:</strong> {{ name }}</p>
        <p><strong>Symbol:</strong> {{ symbol }}</p>
        <p><strong>Decimals:</strong> {{ decimal }}</p>
        <p><strong>Total Supply:</strong> {{ supply }}</p>
        <p><strong>My Balance:</strong> {{ balance }}</p>
        <p><strong>Bank Token Balance:</strong> {{ bank_balance }}</p>
      </section>

      <section class="transfer-section">
        <h2>Transfer Tokens</h2>
        <input type="text" v-model="recipient" placeholder="Recipient Address" class="input-field" />
        <input type="text" v-model="amount" placeholder="Amount" class="input-field" />
        <button class="btn-primary" @click="transfer">Transfer</button>
      </section>

      <section class="stake-section">
        <h2>Permit Deposit</h2>
        <input v-model="stakeAmount" placeholder="Enter Stake Amount" class="input-field" />
        <button class="btn-primary" @click="permitDeposit">Authorize & Deposit</button>
      </section>
    </main>

    <footer class="footer">
      <p>&copy; 2024 Apple-Inspired Wallet</p>
    </footer>
  </div>
</template>

<script>
import { ethers } from 'ethers';
import deployMsg from '/home/ccacr/project/upchain_course/practice/1_solidity_projects/broadcast/ERC2612Deploy.s.sol/31337/run-latest.json';
import erc2612Abi from '/home/ccacr/project/upchain_course/practice/1_solidity_projects/out/ERC2612.sol/ERC2612.json';
import bankAbi from '/home/ccacr/project/upchain_course/practice/1_solidity_projects/out/Bank.sol/Bank.json';

const TokenAddress = deployMsg.transactions
  .filter(transaction => transaction.contractName === "ERC2612")
  .map(transaction => transaction.contractAddress)[0];

const BankAddress = deployMsg.transactions
  .filter(transaction => transaction.contractName === "Bank")
  .map(transaction => transaction.contractAddress)[0];

export default {
  name: 'erc20',

  data() {
    return {
      account: null,
      recipient: null,
      amount: null,
      balance: null,
      ethbalance: null,
      name: null,
      decimal: null,
      symbol: null,
      supply: null,
      stakeAmount: null,
    };
  },

  methods: {
    async connect() {
      await this.initProvider();
      await this.initAccount();
      if (this.account) {
        this.initContract();
        this.readContract();
      }
    },

    async initProvider() {
      if (window.ethereum) {
        this.provider = new ethers.providers.Web3Provider(window.ethereum);
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
        this.signer = this.provider.getSigner();
      } catch (error) {
        console.error("User denied account access", error);
      }
    },

    async initContract() {
      this.erc20Token = new ethers.Contract(TokenAddress, erc2612Abi.abi, this.signer);
      this.bank = new ethers.Contract(BankAddress, bankAbi.abi, this.signer);
    },

    readContract() {
      this.provider.getBalance(this.account).then(r => {
        this.ethbalance = ethers.utils.formatUnits(r, 18);
      });

      this.erc20Token.name().then(r => { this.name = r; });
      this.erc20Token.decimals().then(r => { this.decimal = r; });
      this.erc20Token.symbol().then(r => { this.symbol = r; });
      this.erc20Token.totalSupply().then(r => {
        this.supply = ethers.utils.formatUnits(r, 18);
      });
      this.erc20Token.balanceOf(this.account).then(r => {
        this.balance = ethers.utils.formatUnits(r, 18);
      });
      this.erc20Token.balanceOf(BankAddress).then(r => {
        this.bank_balance = ethers.utils.formatUnits(r, 18);
      });
    },

    transfer() {
      let amount = ethers.utils.parseUnits(this.amount, 18);
      this.erc20Token.transfer(this.recipient, amount).then(() => {
        this.readContract();
      });
    },

    async permitDeposit() {
      let nonce = await this.erc20Token.nonces(this.account);
      this.deadline = Math.ceil(Date.now() / 1000) + 20 * 60;
      let amount = ethers.utils.parseUnits(this.stakeAmount).toString();

      const domain = {
        name: 'ERC2612',
        version: '1',
        chainId: this.chainId,
        verifyingContract: TokenAddress,
      };

      const types = {
        Permit: [
          { name: "owner", type: "address" },
          { name: "spender", type: "address" },
          { name: "value", type: "uint256" },
          { name: "nonce", type: "uint256" },
          { name: "deadline", type: "uint256" },
        ],
      };

      const message = {
        owner: this.account,
        spender: BankAddress,
        value: amount,
        nonce: nonce,
        deadline: this.deadline,
      };

      const signature = await this.signer._signTypedData(domain, types, message);
      const { v, r, s } = ethers.utils.splitSignature(signature);

      try {
        let tx = await this.bank.permitDeposit(this.account, amount, this.deadline, v, r, s);
        await tx.wait();
        this.readContract();
      } catch (error) {
        console.error("Permit Deposit Failed:", error);
      }
    },
  },
};
</script>

<style scoped>
.app-container {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  margin: 0 auto;
  padding: 1rem;
  max-width: 800px;
  background-color: #f9f9f9;
  color: #333;
  border-radius: 10px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.header {
  text-align: center;
  margin-bottom: 2rem;
}

.header h1 {
  font-size: 2rem;
  font-weight: bold;
}

.content section {
  margin-bottom: 2rem;
}

.content h2 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
}

.input-field {
  display: block;
  width: 100%;
  padding: 0.5rem;
  margin: 0.5rem 0;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 1rem;
}

.btn-primary {
  display: inline-block;
  padding: 0.75rem 1.5rem;
  background: linear-gradient(90deg, #007aff, #005eff);
  color: white;
  border: none;
  border-radius: 25px;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.3s ease;
}

.btn-primary:hover {
  background: linear-gradient(90deg, #005eff, #003ebf);
}

.footer {
  text-align: center;
  margin-top: 2rem;
  font-size: 0.9rem;
  color: #888;
}
</style>
