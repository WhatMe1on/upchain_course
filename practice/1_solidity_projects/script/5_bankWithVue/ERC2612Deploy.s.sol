// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {ERC2612} from "src/5_bankWithVue/ERC2612.sol";
import {Bank} from "src/5_bankWithVue/Bank.sol";

contract ERC2612Deploy is Script {
    function run() external returns (address _proxy) {
        vm.startBroadcast();
        ERC2612 ERC2612 = new ERC2612();
        Bank bank = new Bank(address(ERC2612));
        vm.stopBroadcast();
    }
}
