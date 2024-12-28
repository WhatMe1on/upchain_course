
[goto end](#jump0)
<span id="jump-1"></span>

## todo
- [go 后端与链 rpc调用 获取历史交易记录(by evm event) 并缓存至数据库](#jump6)
- [怎样快速的在测试环境发生交易?](#jump7)

## finished
- [anvil 里的区块交易慢](#jump5)

- [如何通过在anvil链上部署test并切换账户部署呢](#jump2)
- [为什么owner没有起作用? 应该是从 TokenDeploy.DeployTokenV1 这里指定了 接下来proxy的owner了啊](#jump1)
- [foundry 如何输出ether.js接受的abi](#jump4)

## unable to do
- [foundry里面连metamask进行测试网部署](#jump3)

## detail

<span id="jump1"></span>
### 为什么owner没有起作用? 应该是从 TokenDeploy.DeployTokenV1 这里指定了 接下来proxy的owner了啊

```solidity
new ProxyAdmin@0x671ceF55a1373E85D4522dacE6eea7Cf52B573c8
    │   │   │   ├─ emit OwnershipTransferred(previousOwner: 0x0000000000000000000000000000000000000000, newOwner: s_tokenManager: [0xb0358c2868552A1685D492c6D063f4b6290a5725])
```
- 发现已经转移权限到tokenManager了

```solidity
    │   ├─ [2921] ProxyAdmin::upgradeAndCall(TransparentUpgradeableProxy: [0x037eDa3aDB1198021A9b2e88C22B464fD38db3f3], TokenV2: [0xDDc10602782af652bB913f7bdE1fD82981Db7dd9], 0x8129fc1c)
    │   │   └─ ← [Revert] OwnableUnauthorizedAccount(0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f)
```
- 查这个revert的地址 如下得知是TokenDeploy的地址

```
    ├─ [4196715] → new TokenDeploy@0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f
```
- 查来查去没啥进展 突然发现官方文档提议 coverage建议使用unsafeUpgrade,换成unsafe之后逻辑能跑了,推测是Upgrades.function()这个的msg sender通过prank伪造不了? 所以之前一直是not owner?,通过fork部署test并切换账户部署呢?

发现是自己没写startBroadcast
https://forum.openzeppelin.com/t/get-ownableunauthorizedaccount-when-upgrade-the-transparent-proxy/42732


<span id="jump2"></span>
### 如何通过在anvil链上部署test并切换账户部署呢
暂时先用环境变量读取本地测试专用钱包私钥并进行部署
使用make cdeploy时正常 将deploy的address写入env并source后
使用make cupdate 出现 Error: script failed: <empty revert data>
->没有加vm.startBroadcast

部署命令已集成至Makefile

<span id="jump3"></span>
### foundry里面连metamask进行测试网部署

foundry 暂时不支持直接调用metamask
https://github.com/foundry-rs/foundry/issues/6556

<span id="jump4"></span>
### foundry 如何输出ether.js接受的abi

实际上这两种abi都能认
```
[
  "constructor(address)",
  "function deposit(address,uint256)",
  "function deposited(address) view returns (uint256)",
  "function permitDeposit(address,uint256,uint256,uint8,bytes32,bytes32)",
  "function token() view returns (address)"
]
```

forge compile出来的是这种
```
{
      "type": "constructor",
      "inputs": [
          {
              "name": "_token",
              "type": "address",
              "internalType": "address"
          }
      ],
      "stateMutability": "nonpayable"
  },
  {
      "type": "function",
      "name": "deposit",
      "inputs": [
          {
              "name": "user",
              "type": "address",
              "internalType": "address"
          },
          {
              "name": "amount",
              "type": "uint256",
              "internalType": "uint256"
          }
      ],
      "outputs": [],
      "stateMutability": "nonpayable"
  }
```


<span id="jump5"></span>
### anvil 里的区块交易慢
https://book.getfoundry.sh/reference/anvil/?highlight=anvil#mining-modes

<span id="jump6"></span>
### go 后端与链 rpc调用 获取历史交易记录(by evm event) 并缓存至数据库
- 1.solidity test里的prank好像发的交易没上链,去看下prank 和 test fork 的说明

- 2.如果要真实交易记录的话,要改下前端

<span id="jump7"></span>
### 怎样快速的在测试环境发生交易?
- forge script 里能调用script 进行交易
- forge 里只能有一个msg.sender
- forge script 里的合约运行调用其他合约的时候msg.sender就变成了script合约,在检查operator是否 有权限的程序里会因为script的地址和不在auth里而revert
- 能不能把script写成一个代理合约->部署上去一次后 后部署上的script2调用script1里的方法并且在script1里检查tx.origin是否为owner从而达到权限的控制设计 -> 实际上不用检查tx.origin,只用把第一次部署的script给授权然后后面的调用都用第一个script的地址代理就行 -> 实际上还是要用户本身发起一次approve,无法通过script发起approve,看能不能用ethers.js或者干脆写前端做了


<span id="jump8"></span>
<span id="jump0"></span>
[goto todo](#jump-1)
