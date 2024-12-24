

## todo
- [ ] [为什么owner没有起作用? 应该是从 TokenDeploy.DeployTokenV1 这里指定了 接下来proxy的owner了啊](#jump1)


## finished

## detail

<span id="jump1">
为什么owner没有起作用? 应该是从 TokenDeploy.DeployTokenV1 这里指定了 接下来proxy的owner了啊
</span>


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
