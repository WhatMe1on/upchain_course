// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {TokenDeploy} from "@ToraPJ/script/4_upgradableERC20/TokenDeploy.s.sol";
import {TokenV1} from "@ToraPJ/src/4_upgradableERC20/TokenV1.sol";
import {TokenV2} from "@ToraPJ/src/4_upgradableERC20/TokenV2.sol";
import {TokenV2Bank} from "@ToraPJ/src/4_upgradableERC20/TokenV2Bank.sol";
import {TokenProxy} from "@ToraPJ/src/4_upgradableERC20/TokenProxy.sol";
import {Test} from "forge-std/Test.sol";

contract TokenProxyTest is Test {
    uint256 constant INIT_TOKEN_AMOUNT = 1 * 10 ** 5;

    address public s_proxy;
    address public s_bank;
    address s_tokenManager;
    address s_player1;
    address s_player2;

    function setUp() external {
        TokenDeploy deploy = new TokenDeploy();
        deploy.DeployTokenV1(s_tokenManager);
        s_proxy = deploy.s_proxy();
        
        s_player1 = makeAddr("s_player1");
        s_player2 = makeAddr("s_player2");
        address TokenAddr = address(TokenV1(s_proxy));
        deal(TokenAddr, s_player1, INIT_TOKEN_AMOUNT);
        deal(TokenAddr, s_player2, INIT_TOKEN_AMOUNT);
    }

    function testBalance() external {}
}
