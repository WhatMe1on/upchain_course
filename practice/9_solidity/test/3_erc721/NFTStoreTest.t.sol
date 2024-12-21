// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import {NFTERC721} from "../../src/3_erc721/NFT.sol";
import {NFTStore} from "../../src/3_erc721/NFTStore.sol";
import {TORATokenInNFT} from "../../src/3_erc721/TORATokenInNFT.sol";
import "../../script/3_erc721/DeployNFTStore.s.sol";

contract NFTStoreTest is Test {
    uint256 constant INIT_TOKEN_AMOUNT = 1 * 10 ** 5;
    string constant NFT_STRING = "bafkreibghc36hemmts7e45exndopide3mcqslje3mdrlzqf4y2hkcebnei";
    uint256 NFT_ID = 0;

    NFTERC721 s_nft;
    NFTStore s_nftStore;
    TORATokenInNFT s_token;
    address s_owner;
    address s_buyer;

    function setUp() public {
        DeployNFTStore deployer = new DeployNFTStore();
        (s_nft, s_nftStore, s_token) = new DeployNFTStore().run(INIT_TOKEN_AMOUNT * 2);
        s_owner = makeAddr("NFTOwner");
        s_buyer = makeAddr("NFTBuyer");
        
        deal(address(s_token), s_owner, INIT_TOKEN_AMOUNT);
        deal(address(s_token), s_buyer, INIT_TOKEN_AMOUNT);

        NFT_ID = s_nft.awardItem(s_owner, NFT_STRING);
        // deal(address(s_nft), s_owner, 0);
    }

    function testputawayNFTOwnerChange() public {
        vm.prank(s_owner);
        s_nft.putaway(address(s_nftStore), NFT_ID, INIT_TOKEN_AMOUNT);

        assertEq(s_nft.ownerOf(NFT_ID), address(s_nftStore));
    }

    function testputawayNFTStoreMetadata() public {
        vm.prank(s_owner);
        s_nft.putaway(address(s_nftStore), NFT_ID, INIT_TOKEN_AMOUNT);

        assertEq(s_owner, s_nftStore.getMetadata(NFT_ID).owner);
        assertEq(INIT_TOKEN_AMOUNT, s_nftStore.getMetadata(NFT_ID).price);
    }

    function testDisPutawayWithoutAuth(uint256 nftId) public {
        vm.prank(s_owner);
        vm.expectRevert();
        s_nft.disPutaway(address(s_nftStore), nftId);
    }

    function testDisPutawayOwner() public {
        vm.prank(s_owner);
        s_nft.putaway(address(s_nftStore), NFT_ID, INIT_TOKEN_AMOUNT);
        vm.prank(s_owner);
        s_nft.disPutaway(address(s_nftStore), NFT_ID);

        assertEq(s_nft.ownerOf(NFT_ID), s_owner);
    }

    function testDisPutawayMetadataClear() public {
        vm.prank(s_owner);
        s_nft.putaway(address(s_nftStore), NFT_ID, INIT_TOKEN_AMOUNT);
        vm.prank(s_owner);
        s_nft.disPutaway(address(s_nftStore), NFT_ID);

        assertEq(s_nftStore.getMetadata(NFT_ID).owner, address(0));
        assertEq(s_nftStore.getMetadata(NFT_ID).price, 0);
    }

    function testbuyNFT() public {
        vm.prank(s_owner);
        s_nft.putaway(address(s_nftStore), NFT_ID, INIT_TOKEN_AMOUNT);
    }
}
