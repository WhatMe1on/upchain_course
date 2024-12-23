// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenV1 is ERC20 {
    uint256 s_counter;

    constructor() ERC20("TORAToken", "ToraT") {
        _mint(msg.sender, 100000);
    }

    function initialize() external {
        s_counter = 1;
    }

    function add() external {
        s_counter++;
    }
}
