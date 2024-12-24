// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

interface TokenRecipient {
    function depositToken(address user, uint256 amount) external returns (bool);
    function withdrawToken(address user, uint256 amount) external returns (bool);
}

contract VaultERC20 is ERC20 {
    using Address for address;

    error VaultERC20__NoTokensReceived();

    constructor() ERC20("VaultCoin", "VaC") {
        _mint(msg.sender, 10 * 10 ** 18);
    }

    //Actual environment don's exist this function, token was transfer by ERC20's transfer() or transferFrom()
    function getToken() external {
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
}
