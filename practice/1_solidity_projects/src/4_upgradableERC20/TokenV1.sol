// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract TokenV1 is ERC20Upgradeable {
    uint256 public s_counter;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() external payable initializer {
        __ERC20_init("TORAToken", "ToraT");
        s_counter = 1;
    }

    function add() external {
        s_counter++;
    }

    function addI(uint256 input) external {
        s_counter += input;
    }
}
