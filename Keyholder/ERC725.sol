// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)

pragma solidity ^0.8.0;

abstract contract ERC725 {
    event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
    event KeyRemoved(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);

    struct Key {
        uint256 _keyPurpose;
        uint256 _keyType;
        bytes32 _keyId;
    }

    function addKey(bytes32 keyId, uint256 keyPurpose, uint256 keyType) public virtual returns (bool success);
    function getKey(bytes32 keyId) public view virtual returns(uint256 keyPurpose, uint256 keyType, bytes32 key);
    function getKeyPurpose(bytes32 keyId) public view virtual returns(uint256 keyPurpose);
    function getKeysByPurpose(uint256 keyPurpose) public view virtual returns(bytes32[] memory keys);
}
