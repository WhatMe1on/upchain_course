// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import {NFTERC721} from "src/3_erc721/NFT.sol";
import {NFTStore} from "src/3_erc721/NFTStore.sol";
import {TORATokenInNFT} from "src/3_erc721/TORATokenInNFT.sol";
import "script/3_erc721/DeployNFTStore.s.sol";

contract NFTTest is Test {
    uint256 constant INIT_TOKEN_AMOUNT = 1 * 10 ** 5;
    string constant NFT_STRING = "bafkreibghc36hemmts7e45exndopide3mcqslje3mdrlzqf4y2hkcebnei";
    uint256 NFT_ID;

    NFTERC721 s_nft;
    address s_owner;
    address s_buyer;

    function setUp() public {
        DeployNFTStore deployer = new DeployNFTStore();
        (address a,,) = deployer.run(INIT_TOKEN_AMOUNT);
        s_nft = NFTERC721(a);
        s_owner = makeAddr("NFTOwner");
        s_buyer = makeAddr("NFTBuyer");
        vm.startPrank(address(msg.sender));

        NFT_ID = s_nft.awardItem(s_owner, NFT_STRING);
        vm.stopPrank();
    }

    function testAwardNFT() public {
        assertEq(s_nft.ownerOf(NFT_ID), s_owner);
    }

    function testTransferNFT() public {
        vm.startPrank(s_owner);
        s_nft.approve(s_buyer, NFT_ID);

        s_nft.transferFrom(s_owner, s_buyer, NFT_ID);
        vm.stopPrank();

        assertEq(s_nft.ownerOf(NFT_ID), s_buyer);
    }

    function testApproveAuthOwnerNFT() public {
        vm.prank(s_owner);
        s_nft.approve(s_buyer, NFT_ID);
        vm.prank(s_owner);

        s_nft.transferFrom(s_owner, s_buyer, NFT_ID);
    }

    function testApproveAuthBuyerNFT() public {
        vm.prank(s_owner);
        s_nft.approve(s_buyer, NFT_ID);
        vm.prank(s_buyer);

        s_nft.transferFrom(s_owner, s_buyer, NFT_ID);
    }
}
