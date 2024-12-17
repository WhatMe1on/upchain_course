// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TORAToken is ERC20{
    constructor() ERC20("TORAToken", "ToraT") {
        _mint(msg.sender, 100000);
    }
}