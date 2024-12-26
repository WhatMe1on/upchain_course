// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {TokenV1} from "src/4_upgradableERC20/TokenV1.sol";
import {TokenV2} from "src/4_upgradableERC20/TokenV2.sol";
import {TokenV2Bank} from "src/4_upgradableERC20/TokenV2Bank.sol";
import {TokenProxy} from "src/4_upgradableERC20/TokenProxy.sol";
import {BaseDeploy} from "script/4_upgradableERC20/BaseDeploy.s.sol";
import {Script, console} from "forge-std/Script.sol";

contract TokenDeploy is BaseDeploy {
    function run() external returns (address _proxy) {
        vm.startBroadcast();
        _proxy =
            Upgrades.deployTransparentProxy("TokenV1.sol:TokenV1", INIT_OWNER, abi.encodeCall(TokenV1.initialize, ()));
        vm.stopBroadcast();
    }
}

contract TokenUpdate is BaseDeploy {
    function run() external returns (address _bank) {
        vm.startBroadcast();
        // Upgrades.deployTransparentProxy("TokenV1.sol:TokenV1", INIT_OWNER, abi.encodeCall(TokenV1.initialize, ()));
        console.log("Tora sender", msg.sender);
        Upgrades.upgradeProxy(PROXY_ADDRESS, "TokenV2.sol:TokenV2", abi.encodeCall(TokenV2.initialize, ()));
        _bank = address(new TokenV2Bank(PROXY_ADDRESS));
        vm.stopBroadcast();
    }
}

contract Test is BaseDeploy {
    function run() external returns (address _bank) {
        _bank = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    }
}
