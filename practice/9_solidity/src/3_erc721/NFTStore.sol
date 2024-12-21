// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {INFTStore} from "./NFT.sol";
import {TORATokenInNFT} from "./TORATokenInNFT.sol";

contract NFTStore is INFTStore, IERC721Receiver {
    error NFTStore__NotNFTAddress();
    error NFTStore__NFTNotOwner();
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
        if (_NFTOwner != s_NFTMap[_NFTId].owner) {
            revert NFTStore__NFTNotOwner();
        }

        // update the inner map
        s_NFTMap[_NFTId] = NFTMetadata(address(0), 0);
    }

    function buyNFT(address _NFTBuyer, uint256 _NFTId) external m_checkNFTAddress {
        // transfer Token
        provideToken(_NFTBuyer, s_NFTMap[_NFTId].owner, s_NFTMap[_NFTId].price);

        // update the inner map
        s_NFTMap[_NFTId] = NFTMetadata(address(0), 0);
    }

    function provideToken(address _from, address _to, uint256 tokenAmount) private {
        TORATokenInNFT(s_TokenAddress).approve(_from, _to, tokenAmount);
        TORATokenInNFT(s_TokenAddress).transferFrom(_from, _to, tokenAmount);
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        override
        returns (bytes4)
    {
        s_NFTMap[tokenId] = NFTMetadata(operator, type(uint256).max);
        return this.onERC721Received.selector;
    }

    function getMetadata(uint256 nftId) external returns (NFTMetadata memory) {
        return s_NFTMap[nftId];
    }
}
