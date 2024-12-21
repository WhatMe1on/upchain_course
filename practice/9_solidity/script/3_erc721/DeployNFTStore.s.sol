// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {NFTERC721} from "../../src/3_erc721/NFT.sol";
import {NFTStore} from "../../src/3_erc721/NFTStore.sol";
import {TORATokenInNFT} from "../../src/3_erc721/TORATokenInNFT.sol";

contract DeployNFTStore is Script {
    function run(uint amount) external returns (NFTERC721, NFTStore, TORATokenInNFT) {
        vm.startBroadcast();
        NFTERC721 NFTERC721Instance = new NFTERC721();
        TORATokenInNFT TORATokenInNFTInstance = new TORATokenInNFT(amount);
        NFTStore NFTStoreInstance =
            new NFTStore({_NFTAddress: address(NFTERC721Instance), _TokenAddress: address(TORATokenInNFTInstance)});
        vm.stopBroadcast();

        return (NFTERC721Instance, NFTStoreInstance, TORATokenInNFTInstance);
    }
}
