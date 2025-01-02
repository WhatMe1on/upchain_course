// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TORAToken is ERC20{
    constructor(address initAddress, uint256 initAmount) ERC20("TORAToken", "TT") {
        _mint(initAddress, initAmount);
    }

    
}