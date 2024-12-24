// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import {NFTERC721} from "src/3_erc721/NFT.sol";
import {NFTStore} from "src/3_erc721/NFTStore.sol";
import {TORATokenInNFT} from "src/3_erc721/TORATokenInNFT.sol";
import "script/3_erc721/DeployNFTStore.s.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

contract TORATokenInNFTTest is Test {
    uint256 constant INIT_TOKEN_AMOUNT = 1 * 10 ** 5;
    string constant NFT_STRING = "bafkreibghc36hemmts7e45exndopide3mcqslje3mdrlzqf4y2hkcebnei";
    uint256 NFT_ID;

    NFTERC721 s_nft;
    NFTStore s_nftStore;
    TORATokenInNFT s_token;
    address s_owner;
    address s_buyer;

    function setUp() public {
        DeployNFTStore deployer = new DeployNFTStore();
        (s_nft, s_nftStore, s_token) = deployer.run(INIT_TOKEN_AMOUNT * 2);
        s_owner = makeAddr("NFTOwner");
        s_buyer = makeAddr("NFTBuyer");
        vm.startPrank(address(msg.sender));
        s_token.transfer(s_owner, INIT_TOKEN_AMOUNT);
        s_token.transfer(s_buyer, INIT_TOKEN_AMOUNT);

        vm.stopPrank();

        NFT_ID = s_nft.awardItem(s_owner, NFT_STRING);
    }

    function testTransferWithoutApproveAuth() external {
        vm.prank(s_owner);
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Errors.ERC20InsufficientAllowance.selector, s_owner, 0, INIT_TOKEN_AMOUNT)
        );

        s_token.transferFrom(s_buyer, s_owner, INIT_TOKEN_AMOUNT);
    }

    function testTokenTransferAuth() external {
        vm.prank(s_owner);
        s_token.approve(s_buyer, INIT_TOKEN_AMOUNT);
        vm.prank(s_buyer);

        s_token.transferFrom(s_owner, s_buyer, INIT_TOKEN_AMOUNT);
        assertEq(s_token.balanceOf(s_buyer), INIT_TOKEN_AMOUNT * 2);
    }

    function testTokenTransferExceedApproveAuth() external {
        vm.prank(s_owner);
        s_token.approve(s_buyer, INIT_TOKEN_AMOUNT);
        vm.prank(s_buyer);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientAllowance.selector, s_buyer, INIT_TOKEN_AMOUNT, INIT_TOKEN_AMOUNT + 1
            )
        );
        s_token.transferFrom(s_owner, s_buyer, INIT_TOKEN_AMOUNT + 1);
    }
}
