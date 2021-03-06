pragma solidity >=0.5.0 <0.7.0;
pragma experimental ABIEncoderV2;

import "@ensdomains/ens/contracts/ENS.sol";
import "./RBAC.sol";
import "@ensdomains/resolver/contracts/Resolver.sol";

/**
 * OwnedRegistrar implements an ENS registrar that accepts registrations by a
 * list of approved parties (IANA registrars). Registrations must be submitted
 * by a "transactor", and signed by a "registrar". Registrars can be added or
 * removed by an account with the "authoriser" role.
 *
 * An audit of this code is available here: https://hackmd.io/s/SJcPchO57
 *
 * The default resolver for users is alterable in this version, but only the
 * "owner" can set it.
 */
contract OwnedRegistrar is RBAC {
    ENS public ens;
    ENS public oldENS;
    address public resolver;
    bytes32 public baseNode;
    mapping(uint=>mapping(address=>bool)) public registrars; // Maps IANA IDs to authorised accounts
    mapping(bytes32=>uint) public nonces; // Maps namehashes to domain nonces

    event RegistrarAdded(uint id, address registrar);
    event RegistrarRemoved(uint id, address registrar);
    event Associate(bytes32 indexed node, bytes32 indexed subnode, address indexed owner);
    event Disassociate(bytes32 indexed node, bytes32 indexed subnode);
    event ResolverSet(address newResolver);

    constructor(ENS _ens, address _resolver, ENS _oldENS, bytes32 _baseNode) public {
        ens = _ens;
        resolver = _resolver;
        oldENS = _oldENS;
        baseNode = _baseNode;
        _addRole(msg.sender, "owner");

    }

    /**
     * @dev Migrate a name from the previous ENSRegistry.
     * @param labelHash The hash of the label specifying the subnode.
     */

    function migrate(uint256 labelHash) public onlyRole("owner") {
        bytes32 node = keccak256(abi.encodePacked(baseNode, bytes32(labelHash)));

        if(ens.owner(node) != address(0x0)) {
            return;
        }

        address owner = oldENS.owner(node);
        address oldResolver = oldENS.resolver(node);
        ens.setSubnodeRecord(baseNode, bytes32(labelHash), owner, oldResolver, 0);
    }

    function migrateAll(uint256[] calldata labelHashes) external {
        for(uint i = 0; i < labelHashes.length; i++) {
            migrate(labelHashes[i]);
        }
    }

    function addRole(address addr, string calldata role) external onlyRole("owner") {
        _addRole(addr, role);
    }

    function removeRole(address addr, string calldata role) external onlyRole("owner") {
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

    function defaultResolver() external view returns (address) {
        return resolver;
    }

    function setResolver(address newResolver) public onlyRole("owner") {
        resolver = newResolver;
        emit ResolverSet(newResolver);
    }

    function associateWithSig(bytes32 node, bytes32 label, address owner, uint nonce, uint registrarId, bytes32 r, bytes32 s, uint8 v) public onlyRole("transactor") {
        bytes32 subnode = keccak256(abi.encode(node, label));
        require(nonce == nonces[subnode]);
        nonces[subnode]++;

        bytes32 sighash = keccak256(abi.encode(subnode, owner, nonce));
        address registrar = ecrecover(sighash, v, r, s);
        require(registrars[registrarId][registrar]);

        ens.setSubnodeOwner(node, label, address(this));
        if(owner == address(0x0)) {
            ens.setResolver(subnode, address(0x0));
        } else {
            ens.setResolver(subnode, resolver);
            Resolver(resolver).setAddr(subnode, owner);
        }
        ens.setOwner(subnode, owner);

        emit Associate(node, label, owner);
    }

    function multicall(bytes[] memory calls) public returns (bool) {
        for (uint i = 0; i < calls.length; i++) {
            (bool success, ) = address(this).delegatecall(calls[i]);
            require(success, "One or more of the transactions failed!");
        }
    }
}
