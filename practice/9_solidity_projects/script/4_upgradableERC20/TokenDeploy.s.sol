// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {TokenV1} from "@ToraPJ/src/4_upgradableERC20/TokenV1.sol";
import {TokenV2} from "@ToraPJ/src/4_upgradableERC20/TokenV2.sol";
import {TokenV2Bank} from "@ToraPJ/src/4_upgradableERC20/TokenV2Bank.sol";
import {TokenProxy} from "@ToraPJ/src/4_upgradableERC20/TokenProxy.sol";
import {Script} from "forge-std/Script.sol";

contract TokenDeploy is Script{
    address public s_proxy;
    address public s_bank;

    function DeployTokenV1(address initOwner) external {
        s_proxy = Upgrades.deployTransparentProxy("TokenV1.sol", initOwner, abi.encodeCall(TokenV1.initialize, ()));
    }
    
    // how to get implements address(tokenV2)? -> use proxy address is enough!
    function UpgradeTokenV1ToV2() external {
        Upgrades.upgradeProxy(s_proxy, "TokenV2.sol", abi.encodeCall(TokenV2.initialize, ()));
        s_bank = address(new TokenV2Bank(s_proxy));
    }
}
