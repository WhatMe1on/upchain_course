// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {VaultDeploy} from "script/2_erc20/VaultDeploy.s.sol";

contract VaultERC20 is Test {
    address _vault;
    address _token;

    function setUp() external {
        (_vault, _token) = new VaultDeploy().run();
    }
}
