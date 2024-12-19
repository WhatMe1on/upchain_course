// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTERC721 is ERC721URIStorage {
    uint256 private _nextTokenId;

    constructor() ERC721(unicode"集训营⼆期学员卡", "CAMP2") {}


    // 0xc9d200c3Ea4f5d56E6867eE3e2a92aA4bF0B6392
    // bafkreibghc36hemmts7e45exndopide3mcqslje3mdrlzqf4y2hkcebnei
    // 0x37982529e4301B1a3612A6beE8563c6A30cfAe25 -> 这个合约的地址,上链后可以一直用
    function awardItem(address player, string memory tokenURI) public returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _mint(player, tokenId);
        _setTokenURI(tokenId, tokenURI);

        return tokenId;
    }
}
