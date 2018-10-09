pragma solidity ^0.4.20;
pragma experimental ABIEncoderV2;

import "@ensdomains/ens/contracts/ENS.sol";
import "./RBAC.sol";
import "./OwnerResolver.sol";

/**
 * OwnedRegistrar implements an ENS registrar that accepts registrations by a
 * list of approved parties (IANA registrars). Registrations must be submitted
 * by a "transactor", and signed by a "registrar". Registrars can be added or
 * removed by an account with the "authoriser" role.
 *
 * An audit of this code is available here: https://hackmd.io/s/SJcPchO57
 */
contract OwnedRegistrar is RBAC {
    ENS public ens;
    OwnerResolver public resolver;
    mapping(uint=>mapping(address=>bool)) public registrars; // Maps IANA IDs to authorised accounts
    mapping(bytes32=>uint) public nonces; // Maps namehashes to domain nonces

    event RegistrarAdded(uint id, address registrar);
    event RegistrarRemoved(uint id, address registrar);
    event Associate(bytes32 indexed node, bytes32 indexed subnode, address indexed owner);
    event Disassociate(bytes32 indexed node, bytes32 indexed subnode);

    constructor(ENS _ens) public {
        ens = _ens;
        resolver = new OwnerResolver(_ens);
        _addRole(msg.sender, "owner");
    }

    function addRole(address addr, string role) external onlyRole("owner") {
        _addRole(addr, role);
    }

    function removeRole(address addr, string role) external onlyRole("owner") {
        // Don't allow owners to remove themselves
        require(keccak256(abi.encode(role)) != keccak256(abi.encode("owner")) || msg.sender != addr);
        _removeRole(addr, role);
    }

    function setRegistrar(uint id, address registrar) public onlyRole("authoriser") {
        registrars[id][registrar] = true;
        emit RegistrarAdded(id, registrar);
    }

    function unsetRegistrar(uint id, address registrar) public onlyRole("authoriser") {
        registrars[id][registrar] = false;
        emit RegistrarRemoved(id, registrar);
    }

    function associateWithSig(bytes32 node, bytes32 label, address owner, uint nonce, uint registrarId, bytes32 r, bytes32 s, uint8 v) public onlyRole("transactor") {
        bytes32 subnode = keccak256(abi.encode(node, label));
        require(nonce == nonces[subnode]);
        nonces[subnode]++;

        bytes32 sighash = keccak256(abi.encode(subnode, owner, nonce));
        address registrar = ecrecover(sighash, v, r, s);
        require(registrars[registrarId][registrar]);

        ens.setSubnodeOwner(node, label, address(this));
        if(owner == 0) {
            ens.setResolver(subnode, 0);
        } else {
            ens.setResolver(subnode, resolver);
        }
        ens.setOwner(subnode, owner);

        emit Associate(node, label, owner);
    }

    function multicall(bytes[] calls) public {
        for(uint i = 0; i < calls.length; i++) {
            require(address(this).delegatecall(calls[i]));
        }
    }
}
