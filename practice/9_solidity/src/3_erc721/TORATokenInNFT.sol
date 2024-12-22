// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TORATokenInNFT is ERC20 {
    error TORATokenInNFT__TXOperatorNotOwner(address _address);
    address public s_sender;

    constructor(uint amount) ERC20("TORAToken", "ToraT") {
        _mint(msg.sender, amount);
        s_sender = msg.sender;
    }

    function approve(address owner, address spender, uint256 value) public virtual returns (bool) {
        _approve(owner, spender, value);
        return true;
    }
}
