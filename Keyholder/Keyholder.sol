// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)

pragma solidity ^0.8.0;

contract Keyholder {
    event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType); 

    struct Key {
        uint256 _keyPurpose;
        uint256 _keyType;
        bytes32 _keyId;
    }

    mapping (bytes32 => Key) keys;
    mapping (uint256 => bytes32[]) keysByPurpose;

    constructor(bytes32 claimKey, bytes32 actionKey) {
        // Soul Key
        bytes32 soulKeyId = keccak256(abi.encodePacked(msg.sender));
        keys[soulKeyId]._keyId = soulKeyId;
        keys[soulKeyId]._keyPurpose = 1;
        keys[soulKeyId]._keyType = 1;
        keysByPurpose[1].push(soulKeyId);
        emit KeyAdded(soulKeyId, 1, 1);
        // Claim Key
        bytes32 claimKeyId = claimKey;
        keys[claimKeyId]._keyId = claimKeyId;
        keys[claimKeyId]._keyPurpose = 2;
        keys[claimKeyId]._keyType = 2;
        keysByPurpose[2].push(claimKeyId);
        emit KeyAdded(claimKeyId, 2, 2);
        // Action Key
        bytes32 actionKeyId = actionKey;
        keys[actionKeyId]._keyId = actionKeyId;
        keys[actionKeyId]._keyPurpose = 3;
        keys[actionKeyId]._keyType = 1;
        keysByPurpose[3].push(actionKeyId);
        emit KeyAdded(actionKeyId, 3, 1);
    }

    function addKey(bytes32 keyId, uint256 keyPurpose, uint256 keyType) public returns(bool success) {
        require(keys[keyId]._keyId != keyId, "ERC725: key already exists");
        if (msg.sender != address(this)) {
            require(keyHasPurpose(keccak256(abi.encodePacked(msg.sender)), 1), "ERC725: sender does not have soul key");
        }

        keys[keyId]._keyId = keyId;
        keys[keyId]._keyPurpose = keyPurpose;
        keys[keyId]._keyType = keyType;

        keysByPurpose[keyPurpose].push(keyId);

        emit KeyAdded(keyId, keyPurpose, keyType);

        return true;
    }

    function getKey(bytes32 keyId) public view returns(uint256 purpose, uint256 keyType, bytes32 key) {
        return (keys[keyId]._keyPurpose, keys[keyId]._keyType, keys[keyId]._keyId);
    }

    function getKeyPurpose(bytes32 keyId) public view returns(uint256 purpose) {
        return (keys[keyId]._keyPurpose);
    }

    function getKeysByPurpose(uint256 keyPurpose) public view returns(bytes32[] memory purpose) {
        return keysByPurpose[keyPurpose];
    }

    function keyHasPurpose(bytes32 keyId, uint256 keyPurpose) public view returns(bool result) {
        bool isThere;
        if (keys[keyId]._keyId == 0) return false;
        isThere = keys[keyId]._keyPurpose <= keyPurpose;
        return isThere;
    }
}
