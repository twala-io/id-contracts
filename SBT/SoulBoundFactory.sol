// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./access/AccessControl.sol";
import "./SoulBound.sol";

contract SoulBoundFactory is AccessControl  {
    /**
     * @dev Emitted when a SoulBound contract is deployed.
     */
    event Deployed(address newContract);

    bytes32 public constant DEPLOYER_ROLE = keccak256("DEPLOYER_ROLE");

    address[] contracts;

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(DEPLOYER_ROLE, msg.sender);
    }
 
    function deployContract (
        address owner,
        string calldata name,
        string calldata symbol
    ) external onlyRole(DEPLOYER_ROLE) returns (address) {
        SoulBound newContract = new SoulBound(owner, name, symbol);
        contracts.push(address(newContract));

        emit Deployed(address(newContract));

        return address(newContract);
    }

    function listContracts()
        external view returns (address[] memory)
    {
        return contracts;
    }
}
