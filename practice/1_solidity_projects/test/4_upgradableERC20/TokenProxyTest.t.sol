// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {TokenDeploy} from "script/4_upgradableERC20/TokenDeploy.s.sol";
import {TokenV1} from "src/4_upgradableERC20/TokenV1.sol";
import {TokenV2} from "src/4_upgradableERC20/TokenV2.sol";
import {TokenV2Bank} from "src/4_upgradableERC20/TokenV2Bank.sol";
import {TokenProxy} from "src/4_upgradableERC20/TokenProxy.sol";
import {Test} from "forge-std/Test.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import {UnsafeUpgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract TokenProxyTest is Test {
    uint256 constant INIT_TOKEN_AMOUNT = type(uint16).max;

    address public s_proxy;
    address public s_bank;
    address s_tokenManager;
    address s_player1;
    address s_player2;
    address s_deploy;

    modifier m_upgradeTokenV1toV2() {
        vm.startPrank(s_tokenManager);
        TokenDeploy(s_deploy).UpgradeTokenV1ToV2(s_proxy);
        vm.stopPrank();
        _;
    }

    modifier m_txBeforeUpgrade(uint16 amount) {
        testTokenTransferAuth(amount);
        _;
    }

    modifier m_2deployTokenV1() {
        s_proxy = UnsafeUpgrades.deployTransparentProxy(
            address(new TokenV1()), s_tokenManager, abi.encodeCall(TokenV1.initialize, ())
        );
        deal(s_proxy, s_player1, INIT_TOKEN_AMOUNT);
        deal(s_proxy, s_player2, INIT_TOKEN_AMOUNT);
        _;
    }

    modifier m_2upgradeTokenV1toV2() {
        vm.startPrank(s_tokenManager);
        UnsafeUpgrades.upgradeProxy(s_proxy, address(new TokenV2()), abi.encodeCall(TokenV2.initialize, ()));
        s_bank = address(new TokenV2Bank(s_proxy));
        vm.stopPrank();
        _;
    }

    modifier m_2V1add() {
        TokenV1(s_proxy).add();
        _;
    }

    modifier m_2V1addI(uint256 input) {
        TokenV1(s_proxy).addI(input);
        _;
    }

    modifier m_2V1transfer(address _from, address _to, uint256 amount) {
        vm.prank(_from);
        TokenV1(s_proxy).approve(_to, amount);
        vm.prank(_to);
        TokenV1(s_proxy).transferFrom(_from, _to, amount);
        _;
    }

    modifier m_2V2add3() {
        TokenV2(s_proxy).add3();
        _;
    }

    modifier m_2V2counter2add3() {
        TokenV2(s_proxy).counter2add3();
        _;
    }

    modifier m_2V2transfer(address _from, address _to, uint256 amount) {
        vm.prank(_from);
        TokenV2(s_proxy).approve(_to, amount);
        vm.prank(_to);
        TokenV2(s_proxy).transferFrom(_from, _to, amount);
        _;
    }

    modifier m_2V2BankDeposit(address user, uint256 amount) {
        vm.prank(user);
        TokenV2(s_proxy).deposit(s_bank, amount);
        _;
    }

    modifier m_2V2BankWithdraw(address user, uint256 amount) {
        vm.prank(user);
        TokenV2(s_proxy).withdraw(s_bank, amount);
        _;
    }

    modifier m_2V1counterChecker(uint256 amount) {
        _;
        assertEq(TokenV1(s_proxy).s_counter(), amount);
    }

    modifier m_2V1TokenChecker(address owner, uint256 amount) {
        _;
        assertEq(TokenV1(s_proxy).balanceOf(owner), amount);
    }

    modifier m_2V2counterChecker(uint256 amount) {
        _;
        assertEq(TokenV2(s_proxy).s_counter(), amount);
    }

    modifier m_2V2counter2Checker(uint256 amount) {
        _;
        assertEq(TokenV2(s_proxy).s_counter2(), amount);
    }

    modifier m_2V2TokenChecker(address owner, uint256 amount) {
        _;
        assertEq(TokenV2(s_proxy).balanceOf(owner), amount);
    }

    modifier m_2V2BankBalanceChecker(address owner, uint256 amount) {
        _;
        assertEq(TokenV2Bank(s_bank).getBalance(owner), amount);
    }

    function setUp() external {
        s_tokenManager = makeAddr("s_tokenManager");
        s_player1 = makeAddr("s_player1");
        s_player2 = makeAddr("s_player2");
        TokenDeploy deploy = new TokenDeploy();
        // 为什么这里的owner没有起作用?
        deploy.DeployTokenV1(s_tokenManager);
        s_proxy = deploy.s_proxy();
        s_deploy = address(deploy);
        deal(s_proxy, s_player1, INIT_TOKEN_AMOUNT);
        deal(s_proxy, s_player2, INIT_TOKEN_AMOUNT);
    }

    function testBalance() external view {
        assertEq(TokenV1(s_proxy).balanceOf(s_player1), INIT_TOKEN_AMOUNT);
    }

    function testTransferWithoutApproveAuth() external {
        vm.prank(s_player1);
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Errors.ERC20InsufficientAllowance.selector, s_player1, 0, INIT_TOKEN_AMOUNT)
        );

        TokenV1(s_proxy).transferFrom(s_player2, s_player1, INIT_TOKEN_AMOUNT);
    }

    function testTokenTransferAuth() external {
        vm.prank(s_player1);
        TokenV1(s_proxy).approve(s_player2, INIT_TOKEN_AMOUNT);
        vm.prank(s_player2);

        TokenV1(s_proxy).transferFrom(s_player1, s_player2, INIT_TOKEN_AMOUNT);
        assertEq(TokenV1(s_proxy).balanceOf(s_player2), INIT_TOKEN_AMOUNT * 2);
    }

    function testTokenTransferAuth(uint16 amount) public {
        vm.prank(s_player1);
        TokenV1(s_proxy).approve(s_player2, amount);
        vm.prank(s_player2);

        TokenV1(s_proxy).transferFrom(s_player1, s_player2, amount);
        assertEq(TokenV1(s_proxy).balanceOf(s_player2), INIT_TOKEN_AMOUNT + amount);
    }

    function testTokenTransferExceedApproveAuth() external {
        vm.prank(s_player1);
        TokenV1(s_proxy).approve(s_player2, INIT_TOKEN_AMOUNT);
        vm.prank(s_player2);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientAllowance.selector, s_player2, INIT_TOKEN_AMOUNT, INIT_TOKEN_AMOUNT + 1
            )
        );
        TokenV1(s_proxy).transferFrom(s_player1, s_player2, INIT_TOKEN_AMOUNT + 1);
    }

    //TODO tests need unsafeUpgrades to run locally -> vm.prank() in tests need to behave like real user use their address to send transaction on real blockchain
    // function testCheckUpgradeData() external m_txBeforeUpgrade(1) m_upgradeTokenV1toV2 {
    //     uint16 amount = 1;
    //     assertEq(TokenV2(s_proxy).balanceOf(s_player1), INIT_TOKEN_AMOUNT + amount);
    // }

    function testCheckUpgradeData(uint8 amount) external m_2deployTokenV1 m_2V1transfer(s_player1, s_player2, amount) m_2upgradeTokenV1toV2 {
        assertEq(TokenV2(s_proxy).balanceOf(s_player2), INIT_TOKEN_AMOUNT + amount);
    }

    //
    function testCounter(uint8 times) external m_2deployTokenV1 m_2V1counterChecker(1 + uint256(times)) {
        TokenV1 token = TokenV1(s_proxy);
        for (uint256 index = 0; index < times; index++) {
            token.add();
        }
    }

    function testCounterUpgrade() external m_2deployTokenV1 m_2upgradeTokenV1toV2 m_2V2counterChecker(1) {}
    function testCounter2Upgrade() external m_2deployTokenV1 m_2upgradeTokenV1toV2 m_2V2counter2Checker(1) {}
    function testAddUpgrade() external m_2deployTokenV1 m_2V1add m_2upgradeTokenV1toV2 m_2V2counterChecker(1 + 1) {}
    function testAddIUpgrade(uint16 amount)
        external
        m_2deployTokenV1
        m_2V1addI(amount)
        m_2upgradeTokenV1toV2
        m_2V2counterChecker(1 + uint256(amount))
    {}
    function testAdd3Upgrade() external m_2deployTokenV1 m_2upgradeTokenV1toV2 m_2V2add3 m_2V2counterChecker(1 + 3) {}

    function testTokenUpgrade(uint8 amount)
        external
        m_2deployTokenV1
        m_2V1transfer(s_player1, s_player2, amount)
        m_2upgradeTokenV1toV2
        m_2V1TokenChecker(s_player1, INIT_TOKEN_AMOUNT - amount)
        m_2V1TokenChecker(s_player2, INIT_TOKEN_AMOUNT + amount)
    {}

    function testBankDeposit(uint8 amount)
        external
        m_2deployTokenV1
        m_2upgradeTokenV1toV2
        m_2V2BankDeposit(s_player1, amount)
        m_2V2TokenChecker(s_player1, INIT_TOKEN_AMOUNT - amount)
        m_2V2TokenChecker(s_bank, amount)
        m_2V2BankBalanceChecker(s_player1, amount)
    {}

    function testBankWithDraw(uint8 amount)
        external
        m_2deployTokenV1
        m_2upgradeTokenV1toV2
        m_2V2BankDeposit(s_player1, INIT_TOKEN_AMOUNT)
        m_2V2BankWithdraw(s_player1, amount)
        m_2V2TokenChecker(s_player1, amount)
        m_2V2TokenChecker(s_bank, INIT_TOKEN_AMOUNT - amount)
        m_2V2BankBalanceChecker(s_player1, INIT_TOKEN_AMOUNT - amount)
    {}
}
