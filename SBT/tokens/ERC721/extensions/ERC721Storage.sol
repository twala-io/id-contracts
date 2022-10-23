// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Storage.sol)

pragma solidity ^0.8.0;

import "../ERC721.sol";

/**
 * @dev ERC721 token with storage based token metadata management.
 */
abstract contract ERC721Storage is ERC721 {
    using Strings for uint256;

    // Optional mapping for token metadata
    mapping(bytes32 => string) private _tokenMetadataMapping;

    /**
     * @dev See {IERC721Metadata-tokenMetadata}.
     */
    function tokenMetadata(bytes32 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        string memory _tokenMetadata = _tokenMetadataMapping[tokenId];
        string memory base = _baseMetadata();

        // If there is no base metadata, return the token metadata.
        if (bytes(base).length == 0) {
            return _tokenMetadata;
        }
        // If both are set, concatenate the baseMetadata and tokenMetadata (via abi.encodePacked).
        if (bytes(_tokenMetadata).length > 0) {
            return string(abi.encodePacked(base, _tokenMetadata));
        }

        return super.tokenMetadata(tokenId);
    }

    /**
     * @dev Sets `_tokenMetadata` as the tokenMetadata of `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _setTokenMetadata(bytes32 tokenId, string memory _tokenMetadata) internal virtual {
        require(_exists(tokenId), "ERC721Storage: Metadata set of nonexistent token");
        _tokenMetadataMapping[tokenId] = _tokenMetadata;
    }

    /**
     * @dev See {ERC721-_burn}. This override additionally checks to see if a
     * token-specific metadata was set for the token, and if so, it deletes the token metadata from
     * the storage mapping.
     */
    function _burn(bytes32 tokenId) internal virtual override {
        super._burn(tokenId);

        if (bytes(_tokenMetadataMapping[tokenId]).length != 0) {
            delete _tokenMetadataMapping[tokenId];
        }
    }
}
