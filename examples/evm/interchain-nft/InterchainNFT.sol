// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';
import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';
import { IERC20 } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IERC20.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Counters.sol';

contract InterchainNFT is AxelarExecutable, ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    string public value;
    string public remoteChain;
    string public remoteAddress;
    IAxelarGasService public immutable gasService;
    string public chainName;
    uint256 public chainId;

    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => mapping(uint256 => string)) selector;

    constructor(
        address gateway_,
        address gasReceiver_,
        string memory chainName_,
        uint256 chainId_
    ) AxelarExecutable(gateway_) ERC721('Warp', 'DRV') {
        gasService = IAxelarGasService(gasReceiver_);
        chainId = chainId_;
        chainName = chainName_;
        chainId = chainId_;
        safeMint(0xA640F6f8fb40C5521c2D94C369755E3573F5D4B9);

        // selector['Avalanche'][1] = 'ipfs://bafyreig7sa7sxudqszzti3tqurgur56mcp4cpumrc2watfjddofrgb6u6u/metadata.json';
        // selector['Avalanche'][2] = 'ipfs://bafyreigwpn3geryp74f6bllphg6jtk6cj3mwee7byjlsc4zyjf6mpqpzje/metadata.json';
        // selector['Avalanche'][3] = 'ipfs://bafyreihdlre7skq2huu4r73rimswikgk3oem7gwgclemkgavforuzfnrse/metadata.json';
        // selector['Binance'][1] = 'ipfs://bafyreihvvdvxacjybkzxidip24w72m37qqtcf2eehksqaas4n76qtezmza/metadata.json';
        // selector['Binance'][2] = 'ipfs://bafyreibqpb7qjbpbketab7ji4shwh7mdk5figibim6hfa4wxixthonkdva/metadata.json';
        // selector['Binance'][3] = 'ipfs://bafyreieztrxsshzzrpcozrgzo6uixnpbzpyg4sunnsiac3k2uhrmqhhlya/metadata.json';
        // selector['Ethereum'][1] = 'ipfs://bafyreibf3wgkfi5jdeokwor5exdxjrbc7nnau6m7spczpzkx5vnzqfergi/metadata.json';
        // selector['Ethereum'][2] = 'ipfs://bafyreibjkhrilzdisvv7sx36dr7mtil2p4rr6gspbc6pgtovawzl3ad3kq/metadata.json';
        // selector['Ethereum'][3] = 'ipfs://bafyreihxlmcgd5gfxtbb7rkmi5q445nu6fktmwqlbwichxe6pmpmxa3evm/metadata.json';
        // selector['Polygon'][1] = 'ipfs://bafyreifxfo3i2kh4ruk53uu3xexbky5k7ptxxpfyea4h3pueuzyhxirhyi/metadata.json';
        // selector['Polygon'][2] = 'ipfs://bafyreie3ro4y7ygf4j25gjjfccvxpr2l5vjg4oyxzhaqijymsnchktxypu/metadata.json';
        // selector['Polygon'][3] = 'ipfs://bafyreiffcikbsn3cdq5m7iyq4bsa3s4ty3te2bq3vunkjq23wzd5vtnxg4/metadata.json';

        // selector[43114][1] = 'ipfs://bafyreig7sa7sxudqszzti3tqurgur56mcp4cpumrc2watfjddofrgb6u6u/metadata.json';
        // selector[43114][2] = 'ipfs://bafyreigwpn3geryp74f6bllphg6jtk6cj3mwee7byjlsc4zyjf6mpqpzje/metadata.json';
        // selector[43114][3] = 'ipfs://bafyreihdlre7skq2huu4r73rimswikgk3oem7gwgclemkgavforuzfnrse/metadata.json';
        // selector[97][1] = 'ipfs://bafyreihvvdvxacjybkzxidip24w72m37qqtcf2eehksqaas4n76qtezmza/metadata.json';
        // selector[97][2] = 'ipfs://bafyreibqpb7qjbpbketab7ji4shwh7mdk5figibim6hfa4wxixthonkdva/metadata.json';
        // selector[97][3] = 'ipfs://bafyreieztrxsshzzrpcozrgzo6uixnpbzpyg4sunnsiac3k2uhrmqhhlya/metadata.json';
        // selector[5][1] = 'ipfs://bafyreibf3wgkfi5jdeokwor5exdxjrbc7nnau6m7spczpzkx5vnzqfergi/metadata.json';
        // selector[5][2] = 'ipfs://bafyreibjkhrilzdisvv7sx36dr7mtil2p4rr6gspbc6pgtovawzl3ad3kq/metadata.json';
        // selector[5][3] = 'ipfs://bafyreihxlmcgd5gfxtbb7rkmi5q445nu6fktmwqlbwichxe6pmpmxa3evm/metadata.json';
        // selector[80001][1] = 'ipfs://bafyreifxfo3i2kh4ruk53uu3xexbky5k7ptxxpfyea4h3pueuzyhxirhyi/metadata.json';
        // selector[80001][2] = 'ipfs://bafyreie3ro4y7ygf4j25gjjfccvxpr2l5vjg4oyxzhaqijymsnchktxypu/metadata.json';
        // selector[80001][3] = 'ipfs://bafyreiffcikbsn3cdq5m7iyq4bsa3s4ty3te2bq3vunkjq23wzd5vtnxg4/metadata.json';
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        //_tokenURIs[tokenId] = 'ipfs://bafyreiffcikbsn3cdq5m7iyq4bsa3s4ty3te2bq3vunkjq23wzd5vtnxg4/metadata.json';
        //initializeURI(tokenId);
    }

    function safeWarp() public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        //_tokenURIs[tokenId] = 'ipfs://bafyreiffcikbsn3cdq5m7iyq4bsa3s4ty3te2bq3vunkjq23wzd5vtnxg4/metadata.json';
        initializeURI(tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
        return _tokenURIs[tokenId];
    }

    function connectNFTs(string calldata destinationChain, string calldata destinationAddress) external payable {
        remoteChain = destinationChain;
        remoteAddress = destinationAddress;
        bytes memory payload = abi.encode(1);
        send(payload);
    }

    function update(string calldata newURI, uint token) external payable {
        _tokenURIs[token] = newURI;
        if (bytes(remoteChain).length <= 0 || bytes(remoteAddress).length <= 0) {
            // This NFT isn't connected, so it won't be transferred
            return;
        }
        bytes memory payload = abi.encode(2, newURI, token);
        send(payload);
    }

    function send(bytes memory payload) internal {
        if (msg.value > 0) {
            gasService.payNativeGasForContractCall{ value: msg.value }(address(this), remoteChain, remoteAddress, payload, msg.sender);
        }
        gateway.callContract(remoteChain, remoteAddress, payload);
    }

    function _execute(string calldata sourceChain_, string calldata sourceAddress_, bytes calldata payload_) internal override {
        uint method;
        (method) = abi.decode(payload_, (uint8));
        // Connect
        if (method == 1) {
            remoteChain = sourceChain_;
            remoteAddress = sourceAddress_;
            // Update
        } else if (method == 2) {
            string memory newURI;
            uint tokenId;

            (, newURI, tokenId) = abi.decode(payload_, (uint8, string, uint));
            _tokenURIs[tokenId] = newURI;
        }
    }

    //    string avax_3 = "ipfs://bafyreig7sa7sxudqszzti3tqurgur56mcp4cpumrc2watfjddofrgb6u6u/metadata.json"
    //    string avax_2 = "ipfs://bafyreigwpn3geryp74f6bllphg6jtk6cj3mwee7byjlsc4zyjf6mpqpzje/metadata.json"
    //    string avax_1 = "ipfs://bafyreihdlre7skq2huu4r73rimswikgk3oem7gwgclemkgavforuzfnrse/metadata.json"
    //    string bnb_3 = "ipfs://bafybeic35acq374gm7xvyskxi5ceeydpe64k3jjo5cjjhiwofrlp6j77ey"
    //    string bnb_2 = "ipfs://bafybeic35acq374gm7xvyskxi5ceeydpe64k3jjo5cjjhiwofrlp6j77ey"
    //    string bnb_1 = "ipfs://bafybeic35acq374gm7xvyskxi5ceeydpe64k3jjo5cjjhiwofrlp6j77ey"
    //    string eth_3 = "ipfs://bafybeic35acq374gm7xvyskxi5ceeydpe64k3jjo5cjjhiwofrlp6j77ey"
    //    string eth_2 = "ipfs://bafybeic35acq374gm7xvyskxi5ceeydpe64k3jjo5cjjhiwofrlp6j77ey"
    //    string eth_1 = "ipfs://bafybeic35acq374gm7xvyskxi5ceeydpe64k3jjo5cjjhiwofrlp6j77ey"
    //    string matic_3 = "ipfs://bafybeic35acq374gm7xvyskxi5ceeydpe64k3jjo5cjjhiwofrlp6j77ey"
    //    string matic_2 = "ipfs://bafybeic35acq374gm7xvyskxi5ceeydpe64k3jjo5cjjhiwofrlp6j77ey"
    //    string matic_1 = "ipfs://bafybeic35acq374gm7xvyskxi5ceeydpe64k3jjo5cjjhiwofrlp6j77ey"

    // selector["Avalanche"][1]='ipfs://bafyreig7sa7sxudqszzti3tqurgur56mcp4cpumrc2watfjddofrgb6u6u/metadata.json';
    // selector["Avalanche"][2]='ipfs://bafyreigwpn3geryp74f6bllphg6jtk6cj3mwee7byjlsc4zyjf6mpqpzje/metadata.json';
    // selector["Avalanche"][3]='ipfs://bafyreihdlre7skq2huu4r73rimswikgk3oem7gwgclemkgavforuzfnrse/metadata.json';
    // selector["Binance"][1]='ipfs://bafyreihvvdvxacjybkzxidip24w72m37qqtcf2eehksqaas4n76qtezmza/metadata.json';
    // selector["Binance"][2]='ipfs://bafyreibqpb7qjbpbketab7ji4shwh7mdk5figibim6hfa4wxixthonkdva/metadata.json';
    // selector["Binance"][3]='ipfs://bafyreieztrxsshzzrpcozrgzo6uixnpbzpyg4sunnsiac3k2uhrmqhhlya/metadata.json';
    // selector["Ethereum"][1]='ipfs://bafyreibf3wgkfi5jdeokwor5exdxjrbc7nnau6m7spczpzkx5vnzqfergi/metadata.json';
    // selector["Ethereum"][2]='ipfs://bafyreibjkhrilzdisvv7sx36dr7mtil2p4rr6gspbc6pgtovawzl3ad3kq/metadata.json';
    // selector["Ethereum"][3]='ipfs://bafyreihxlmcgd5gfxtbb7rkmi5q445nu6fktmwqlbwichxe6pmpmxa3evm/metadata.json';
    // selector["Polygon"][1]='ipfs://bafyreifxfo3i2kh4ruk53uu3xexbky5k7ptxxpfyea4h3pueuzyhxirhyi/metadata.json';
    // selector["Polygon"][2]='ipfs://bafyreie3ro4y7ygf4j25gjjfccvxpr2l5vjg4oyxzhaqijymsnchktxypu/metadata.json';
    // selector["Polygon"][3]='ipfs://bafyreiffcikbsn3cdq5m7iyq4bsa3s4ty3te2bq3vunkjq23wzd5vtnxg4/metadata.json';

    function initializeURI(uint256 tokenId) internal {
        require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');

        // if (block.number % 3 == 0) {
        //     _tokenURIs[tokenId] = selector[chainId][1];
        // } else if (block.number % 3 == 1) {
        //     _tokenURIs[tokenId] = selector[chainId][2];
        // } else {
        //     _tokenURIs[tokenId] = selector[5][3];
        // }

        // if (block.number % 3 == 0) {
        //     _tokenURIs[tokenId] = selector[chainId][1];
        // } else if (block.number % 3 == 1) {
        //     _tokenURIs[tokenId] = selector[chainId][2];
        // } else {
        //     _tokenURIs[tokenId] = 'ipfs://bafyreiffcikbsn3cdq5m7iyq4bsa3s4ty3te2bq3vunkjq23wzd5vtnxg4/metadata.json';
        // }

        if (chainId == 43114) {
            if (block.number % 3 == 0) {
                _tokenURIs[tokenId] = 'ipfs://bafyreig7sa7sxudqszzti3tqurgur56mcp4cpumrc2watfjddofrgb6u6u/metadata.json';
            } else if (block.number % 3 == 1) {
                _tokenURIs[tokenId] = 'ipfs://bafyreigwpn3geryp74f6bllphg6jtk6cj3mwee7byjlsc4zyjf6mpqpzje/metadata.json';
            } else {
                _tokenURIs[tokenId] = 'ipfs://bafyreihdlre7skq2huu4r73rimswikgk3oem7gwgclemkgavforuzfnrse/metadata.json';
            }
        } else if (chainId == 97) {
            if (block.number % 3 == 0) {
                _tokenURIs[tokenId] = 'ipfs://bafyreihvvdvxacjybkzxidip24w72m37qqtcf2eehksqaas4n76qtezmza/metadata.json';
            } else if (block.number % 3 == 1) {
                _tokenURIs[tokenId] = 'ipfs://bafyreibqpb7qjbpbketab7ji4shwh7mdk5figibim6hfa4wxixthonkdva/metadata.json';
            } else {
                _tokenURIs[tokenId] = 'ipfs://bafyreieztrxsshzzrpcozrgzo6uixnpbzpyg4sunnsiac3k2uhrmqhhlya/metadata.json';
            }
        } else if (chainId == 5) {
            if (block.number % 3 == 0) {
                _tokenURIs[tokenId] = 'ipfs://bafyreibf3wgkfi5jdeokwor5exdxjrbc7nnau6m7spczpzkx5vnzqfergi/metadata.json';
            } else if (block.number % 3 == 1) {
                _tokenURIs[tokenId] = 'ipfs://bafyreibjkhrilzdisvv7sx36dr7mtil2p4rr6gspbc6pgtovawzl3ad3kq/metadata.json';
            } else {
                _tokenURIs[tokenId] = 'ipfs://bafyreihxlmcgd5gfxtbb7rkmi5q445nu6fktmwqlbwichxe6pmpmxa3evm/metadata.json';
            }
        } else if (chainId == 80001) {
            if (block.number % 3 == 0) {
                _tokenURIs[tokenId] = 'ipfs://bafyreifxfo3i2kh4ruk53uu3xexbky5k7ptxxpfyea4h3pueuzyhxirhyi/metadata.json';
            } else if (block.number % 3 == 1) {
                _tokenURIs[tokenId] = 'ipfs://bafyreie3ro4y7ygf4j25gjjfccvxpr2l5vjg4oyxzhaqijymsnchktxypu/metadata.json';
            } else {
                _tokenURIs[tokenId] = 'ipfs://bafyreiffcikbsn3cdq5m7iyq4bsa3s4ty3te2bq3vunkjq23wzd5vtnxg4/metadata.json';
            }
        }
    }
}
