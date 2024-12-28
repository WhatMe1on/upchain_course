// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {NFTERC721} from "../../src/3_erc721/NFT.sol";
import {NFTStore} from "../../src/3_erc721/NFTStore.sol";
import {TORATokenInNFT} from "../../src/3_erc721/TORATokenInNFT.sol";

contract DeployNFTStore is Script {
    function run(uint256 amount) public returns (address, address, address) {
        vm.startBroadcast();
        NFTERC721 NFTERC721Instance = new NFTERC721();
        TORATokenInNFT TORATokenInNFTInstance = new TORATokenInNFT(amount);
        NFTStore NFTStoreInstance =
            new NFTStore({_NFTAddress: address(NFTERC721Instance), _TokenAddress: address(TORATokenInNFTInstance)});
        vm.stopBroadcast();

        return (address(NFTERC721Instance), address(NFTStoreInstance), address(TORATokenInNFTInstance));
    }

    uint256 amount = 1 * 10 ** 9;

    function run() public returns (address, address, address) {
        (address a, address b, address c) = run(amount);
        return (a, b, c);
    }
}
