// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

interface TokenRecipient {
    function depositToken(address user, uint256 amount) external returns (bool);
    function withdrawToken(address user, uint256 amount) external returns (bool);
}

contract TokenV2 is ERC20 {
    using Address for address;

    error VaultERC20__NoTokensReceived();

    uint256 s_counter;

    constructor() ERC20("VaultCoin", "VaC") {
        _mint(msg.sender, 10 * 10 ** 18);
    }

    function deposit(address s_receipt, uint256 amount) external returns (bool) {
        //Add this function can let allowance reduce by the amount
        // _spendAllowance(msg.sender, s_receipt, amount);
        _transfer(msg.sender, s_receipt, amount);

        bool rv = TokenRecipient(s_receipt).depositToken(msg.sender, amount);
        if (!rv) {
            revert VaultERC20__NoTokensReceived();
        }

        return true;
    }

    function withdraw(address s_receipt, uint256 amount) external returns (bool) {
        //Add this function can let allowance reduce by the amount
        // _spendAllowance(msg.sender, s_receipt, amount);
        _transfer(s_receipt, msg.sender, amount);

        bool rv = TokenRecipient(s_receipt).withdrawToken(msg.sender, amount);
        if (!rv) {
            revert VaultERC20__NoTokensReceived();
        }

        return true;
    }

    function initialize() external {}

    function add3() external{
        s_counter += 3;
    }

    function add() external{
        s_counter += 2;
    }
}
