// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenV2Bank {
    error callerNotTokenAddress();

    address immutable s_tokenAddress;
    mapping(address => uint256) s_balanceMap;

    constructor(address _tokenAddress) {
        s_tokenAddress = _tokenAddress;
    }

    function depositToken(address user, uint256 amount) external returns (bool) {
        bool returnFlag = false;
        if (msg.sender == s_tokenAddress) {
            s_balanceMap[user] += amount;
            returnFlag = true;
        } else {
            revert callerNotTokenAddress();
        }
        return returnFlag;
    }

    function withdrawToken(address user, uint256 amount) external returns (bool) {
        bool returnFlag = false;
        if (msg.sender == s_tokenAddress) {
            s_balanceMap[user] -= amount;
            returnFlag = true;
        } else {
            revert callerNotTokenAddress();
        }
        return returnFlag;
    }

    function getBalance(address user) public view returns (uint256) {
        return s_balanceMap[user];
    }

    function getBalance() external view returns (uint256) {
        return s_balanceMap[msg.sender];
    }
}