// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {TokenRecipient} from "./VaultERC20.sol";

contract Vault is TokenRecipient {
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
