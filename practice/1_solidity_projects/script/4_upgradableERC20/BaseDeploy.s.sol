// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";

contract BaseDeploy is Script {
    address immutable INIT_OWNER;
    address immutable PROXY_ADDRESS;

    constructor() {
        INIT_OWNER = vm.envAddress("INIT_OWNER");
        PROXY_ADDRESS = vm.envAddress("PROXY_ADDRESS");
    }
}
