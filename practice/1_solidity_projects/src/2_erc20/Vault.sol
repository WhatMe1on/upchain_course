// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {TokenRecipient} from "./VaultERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AutomationCompatibleInterface} from "@chainlink/contracts/v0.8/automation/AutomationCompatible.sol";

contract Vault is TokenRecipient, AutomationCompatibleInterface {
    error Vault__callerNotTokenAddress();
    error Vault__notOwner();

    uint256 constant AUTO_WITHDRAW_AMOUNT = 1 * 10 ** 2;

    address immutable s_tokenAddress;
    address s_managerAddress;
    mapping(address => uint256) s_balanceMap;

    constructor(address _tokenAddress, address _managerAddress) {
        s_tokenAddress = _tokenAddress;
        s_managerAddress = _managerAddress;
    }

    modifier m_onlyOwner() {
        if (msg.sender != s_managerAddress) {
            revert Vault__notOwner();
        }
        _;
    }

    function depositToken(address user, uint256 amount) external returns (bool) {
        bool returnFlag = false;
        if (msg.sender == s_tokenAddress) {
            s_balanceMap[user] += amount;
            returnFlag = true;
        } else {
            revert Vault__callerNotTokenAddress();
        }
        return returnFlag;
    }

    function withdrawToken(address user, uint256 amount) external returns (bool) {
        bool returnFlag = false;
        if (msg.sender == s_tokenAddress) {
            s_balanceMap[user] -= amount;
            returnFlag = true;
        } else {
            revert Vault__callerNotTokenAddress();
        }
        return returnFlag;
    }

    function getBalance(address user) public view returns (uint256) {
        return s_balanceMap[user];
    }

    function getBalance() external view returns (uint256) {
        return s_balanceMap[msg.sender];
    }

    function managerWithdraw(uint256 amount) external m_onlyOwner {
        withdrawToManager(amount);
    }

    function changeManager(address _newManager) external m_onlyOwner {
        s_managerAddress = _newManager;
    }

    function checkUpkeep(bytes calldata /* checkData */ )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory /* performData */ )
    {
        upkeepNeeded = checkState();
    }

    function performUpkeep(bytes calldata /* performData */ ) external override {
        if (checkState()) {
            withdrawToManager(ERC20(s_tokenAddress).balanceOf(address(this)) / 2);
        }
    }

    function checkState() internal view returns (bool _state) {
        _state = ERC20(s_tokenAddress).balanceOf(address(this)) > AUTO_WITHDRAW_AMOUNT;
    }

    function withdrawToManager(uint256 amount) internal {
        ERC20(s_tokenAddress).transfer(s_managerAddress, amount);
    }
}
