// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {INFTStore} from "./NFT.sol";
import {TORATokenInNFT} from "./TORATokenInNFT.sol";

contract NFTStore is INFTStore {
    error NFTStore__NotNFTAddress();
    error NFTStore__NotTokenAddress();

    mapping(uint256 => NFTMetadata) s_NFTMap;
    address immutable s_NFTAddress;
    address immutable s_TokenAddress;

    modifier m_checkNFTAddress() {
        if (msg.sender != s_NFTAddress) {
            revert NFTStore__NotNFTAddress();
        }
        _;
    }

    modifier m_checkTokenAddress() {
        if (msg.sender != s_NFTAddress) {
            revert NFTStore__NotTokenAddress();
        }
        _;
    }

    struct NFTMetadata {
        address owner;
        uint256 price;
    }

    constructor(address _NFTAddress, address _TokenAddress) {
        s_NFTAddress = _NFTAddress;
        s_TokenAddress = _TokenAddress;
    }

    function putawayNFT(address _NFTOwner, uint256 _NFTId, uint256 _NFTprice) external m_checkNFTAddress {
        // update the inner map
        s_NFTMap[_NFTId] = NFTMetadata(_NFTOwner, _NFTprice);
    }

    function disPutawayNFT(address _NFTOwner, uint256 _NFTId) external m_checkNFTAddress {
        // approve the NFT
        ERC721(msg.sender).approve(_NFTOwner, _NFTId);

        // update the inner map
        s_NFTMap[_NFTId] = NFTMetadata(address(0), 0);
    }

    function buyNFT(address _NFTBuyer, uint256 _NFTId) external m_checkNFTAddress {
        // transfer Token
        provideToken(_NFTBuyer, s_NFTMap[_NFTId].owner, s_NFTMap[_NFTId].price);

        // approve the NFT
        ERC721(msg.sender).approve(_NFTBuyer, _NFTId);

        // update the inner map
        s_NFTMap[_NFTId] = NFTMetadata(address(0), 0);
    }

    function provideToken(address _from, address _to, uint256 tokenAmount) private {
        TORATokenInNFT(s_TokenAddress).approve(_from, _to, tokenAmount);
        TORATokenInNFT(s_TokenAddress).transferFrom(_from, _to, tokenAmount);
    }
}
