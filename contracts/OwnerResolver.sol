pragma solidity ^0.4.20;

import "@ensdomains/ens/contracts/ENS.sol";

contract OwnerResolver {
    ENS public ens;

    constructor(ENS _ens) public {
        ens = _ens;
    }

    function addr(bytes32 node) public view returns(address) {
        return ens.owner(node);
    }

    function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
        return interfaceID == 0x01ffc9a7 || interfaceID == 0x3b3b57de;
    }
}
