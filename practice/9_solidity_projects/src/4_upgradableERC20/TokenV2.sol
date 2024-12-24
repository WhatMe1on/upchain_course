// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

interface TokenRecipient {
    function depositToken(address user, uint256 amount) external returns (bool);
    function withdrawToken(address user, uint256 amount) external returns (bool);
}

/// @custom:oz-upgrades-from src/4_upgradableERC20/TokenV1.sol:TokenV1
contract TokenV2 is ERC20Upgradeable {
    using Address for address;

    error VaultERC20__NoTokensReceived();

    uint256 public s_counter;
    uint256 public s_counter2;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
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

    function initialize() external payable reinitializer(2) {
        s_counter2 = 1;
    }

    function add3() external {
        s_counter += 3;
    }

    function counter2add3() external {
        s_counter2 += 3;
    }
}
