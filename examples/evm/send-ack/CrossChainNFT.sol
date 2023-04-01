// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';

error CrossChainNFT__CallerIsNotOwner();

contract CrossChainNFT is ERC721URIStorage {
    address public owner;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        owner = msg.sender;
    }

    function mint(address to, uint256 tokenId) public {
        if (msg.sender != owner) {
            revert CrossChainNFT__CallerIsNotOwner(); //Only deployer node can sign the transaction
        }
        if (_exists(tokenId)) {
            safeTransferFrom(owner, to, tokenId);
        }
        _mint(to, tokenId);
    }

    function setTokenURI(uint256 tokenId, string memory tokenURI) public {
        if (msg.sender != owner) {
            revert CrossChainNFT__CallerIsNotOwner(); //Only deployer node can sign the transaction
        }
        _setTokenURI(tokenId, tokenURI);
    }
}
