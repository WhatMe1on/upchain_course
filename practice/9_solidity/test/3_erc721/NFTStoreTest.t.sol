// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import {NFTERC721} from "../../src/3_erc721/NFT.sol";
import {NFTStore} from "../../src/3_erc721/NFTStore.sol";
import {TORATokenInNFT} from "../../src/3_erc721/TORATokenInNFT.sol";
import "../../script/3_erc721/DeployNFTStore.s.sol";

contract NFTStoreTest is Test {
    uint256 constant INIT_TOKEN_AMOUNT = 1 * 10 ** 5;
    string constant INIT_NFT_STRING = "bafkreibghc36hemmts7e45exndopide3mcqslje3mdrlzqf4y2hkcebnei";
    uint256 INIT_NFT_ID;

    NFTERC721 s_nft;
    NFTStore s_nftStore;
    TORATokenInNFT s_token;
    address s_owner;
    address s_buyer;

    function setUp() public {
        DeployNFTStore deployer = new DeployNFTStore();
        (s_nft, s_nftStore, s_token) = new DeployNFTStore().run(INIT_TOKEN_AMOUNT);
        s_owner = makeAddr("NFTOwner");
        s_buyer = makeAddr("NFTBuyer");
        vm.startPrank(address(msg.sender));
        s_token.transfer(s_owner, INIT_TOKEN_AMOUNT / 2);
        s_token.transfer(s_buyer, INIT_TOKEN_AMOUNT / 2);

        vm.stopPrank();

        INIT_NFT_ID = s_nft.awardItem(s_owner, INIT_NFT_STRING);
    }

    function testputawayNFT() public {
        vm.prank(s_owner);
        // s_nft.putaway(address(s_nftStore), INIT_NFT_ID, INIT_TOKEN_AMOUNT / 2);


    }
}
