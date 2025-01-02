// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {TORAToken} from "src/6_uniswap_market/TORAToken.sol";

contract DeployUniMarket is Script {
    function run() external returns (address tokenAddress, address marketAddress) {
        tokenAddress = address(new TORAToken(msg.sender, 1 * 10 ** (18 + 8)));
    }
}
