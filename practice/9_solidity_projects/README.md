## Dependency
run this command to install OZ lib(for upgradable contracts, consider to split it from NonUpgradable contracts)
```
forge install foundry-rs/forge-std
forge install OpenZeppelin/openzeppelin-foundry-upgrades
forge install OpenZeppelin/openzeppelin-contracts-upgradeable
```

## Before Before Running
1. Install [Node.js](https://nodejs.org/).
2. Configure your `foundry.toml` to enable ffi, ast, build info and storage layout:
```toml
[profile.default]
ffi = true
ast = true
build_info = true
extra_output = ["storageLayout"]
```
3. If you are upgrading your contract from a previous version, add the `@custom:oz-upgrades-from <reference>` annotation to the new version of your contract according to [Define Reference Contracts](https://docs.openzeppelin.com/upgrades-plugins/1.x/api-core#define-reference-contracts) or specify the `referenceContract` option when calling the library's functions.
4. Run `forge clean` before running your Foundry script or tests, or include the `--force` option when running `forge script` or `forge test`.

you can find a more details in OZ docs -> 
https://docs.openzeppelin.com/upgrades-plugins/1.x/foundry-upgrades#before_running
