// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./token/ERC721/ERC721.sol";
import "./token/ERC721/extensions/ERC721Enumerable.sol";
import "./token/ERC721/extensions/ERC721URIStorage.sol";
import "./access/AccessControl.sol";

contract Claim is ERC721, ERC721Enumerable, ERC721URIStorage, AccessControl {

    bytes32 public constant ISSUER_ROLE = keccak256("ISSUER_ROLE");

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        _grantRole(ADMIN_ROLE, msg.sender);
        _grantRole(ISSUER_ROLE, msg.sender);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    function safeMint(address to, uint256 tokenId, string memory tokenCid) public onlyRole(ISSUER_ROLE) {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenCid);
    }

    // The following functions are overrides required by Solidity.

    // function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    //     internal
    //     override(ERC721, ERC721Enumerable)
    // {
    //     super._beforeTokenTransfer(from, to, tokenId);
    // }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        require(from == address(0), "ERC721: token transfer is disabled");   
        super._beforeTokenTransfer(from, to, tokenId);  
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
