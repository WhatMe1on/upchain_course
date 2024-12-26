// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {VaultERC20} from "src/2_erc20/VaultERC20.sol";
import {Vault} from "src/2_erc20/Vault.sol";

contract VaultDeploy is Script{
    function run() external returns (address _proxy) {
        vm.startBroadcast();
        VaultERC20 VaultERC20 = new VaultERC20();
        Vault Vault = new Vault(address(VaultERC20));
        vm.stopBroadcast();
    }
}
