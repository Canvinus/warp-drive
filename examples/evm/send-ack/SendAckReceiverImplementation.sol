// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import { SendAckReceiver } from './SendAckReceiver.sol';
import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';
import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import './CrossChainNFT.sol';

contract SendAckReceiverImplementation is SendAckReceiver {
    constructor(address gateway_) SendAckReceiver(gateway_) {}

    CrossChainNFT public deployment;

    mapping(address => address) pair;
    mapping(address => mapping(address => string)) parent;

    string[] public messages;

    function messagesLength() external view returns (uint256) {
        return messages.length;
    }

    function _executePostAck(string memory /*sourceChain*/, string memory /*sourceAddress*/, bytes memory payload) internal override {
        // string memory message = abi.decode(payload, (string));
        // messages.push(message);

        (
            address parentNFT,
            uint256 tokenId,
            string memory name,
            string memory symbol,
            string memory parentChain,
            address recipient,
            string memory tokenURI
        ) = abi.decode(payload, (address, uint256, string, string, string, address, string));
        if (pair[parentNFT] == address(0)) {
            deployment = new CrossChainNFT(name, symbol);
            deployment.mint(recipient, tokenId); //minted the right token ID, NAME, SYMBOL, RECIPIENT
            deployment.setTokenURI(tokenId, tokenURI); //set the right tokenURI
            pair[parentNFT] == address(deployment); //paired up with the parentNFT
            parent[parentNFT][address(deployment)] = parentChain;
        }

        //pair[parentNFT] =
        messages.push(symbol); //checking
    }
}
