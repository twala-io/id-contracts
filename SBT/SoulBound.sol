// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./tokens/ERC721/ERC721.sol";
import "./tokens/ERC721/extensions/ERC721Storage.sol";
import "./access/Ownable.sol";
import "./tokens/ERC721/extensions/ERC721Burnable.sol";

contract SoulBound is ERC721, ERC721Storage, Ownable, ERC721Burnable {
    /**
     * @dev Emitted when a SoulBound token is minted.
     */
    event Minted(bytes32 newTokenId);

    constructor(address owner_, string memory name_, string memory symbol_) ERC721(name_, symbol_) Ownable(owner_) {}

    function mint(address to, string memory metadata)
        public
        onlyOwner
    {
        bytes32 tokenId = keccak256(abi.encodePacked(address(this), to));
        _mint(to, tokenId);
        _setTokenMetadata(tokenId, metadata);
        emit Minted(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, bytes32 tokenId)
        internal
        override
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(bytes32 tokenId) internal override(ERC721, ERC721Storage) {
        super._burn(tokenId);
    }

    function tokenMetadata(bytes32 tokenId)
        public
        view
        override(ERC721, ERC721Storage)
        returns (string memory)
    {
        return super.tokenMetadata(tokenId);
    }
}
