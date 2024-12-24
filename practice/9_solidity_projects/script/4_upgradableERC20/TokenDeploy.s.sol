// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {TokenV1} from "src/4_upgradableERC20/TokenV1.sol";
import {TokenV2} from "src/4_upgradableERC20/TokenV2.sol";
import {TokenV2Bank} from "src/4_upgradableERC20/TokenV2Bank.sol";
import {TokenProxy} from "src/4_upgradableERC20/TokenProxy.sol";
import {Script} from "forge-std/Script.sol";

contract TokenDeploy is Script {
    address public s_proxy;
    address public s_bank;

    function DeployTokenV1(address initOwner) external {
        s_proxy =
            Upgrades.deployTransparentProxy("TokenV1.sol:TokenV1", initOwner, abi.encodeCall(TokenV1.initialize, ()));
    }

    // how to get implements address(tokenV2)? -> use proxy address is enough!
    function UpgradeTokenV1ToV2(address _proxy) external {
        Upgrades.upgradeProxy(_proxy, "TokenV2.sol:TokenV2", abi.encodeCall(TokenV2.initialize, ()));
        s_bank = address(new TokenV2Bank(_proxy));
    }
}
