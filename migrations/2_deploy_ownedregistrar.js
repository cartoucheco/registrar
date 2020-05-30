var OwnedRegistrar = artifacts.require("./OwnedRegistrar.sol");

module.exports = function(deployer) {
  deployer.deploy(OwnedRegistrar, "0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e", "0x42D63ae25990889E35F215bC95884039Ba354115", "0xb6168d4e6a16769316251939e18834097d5b028bd14398823528e541ac0caa3a");
};

// Mainnet:
// ENS: 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e
// PublicResolver: 0x4976fb03c32e5b8cfe2b6ccb31c09ba78ebaba41
//
// Ropsten:
// ENS: 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e
// Resolver: 0x42D63ae25990889E35F215bC95884039Ba354115
//
// baseNode: 0xb6168d4e6a16769316251939e18834097d5b028bd14398823528e541ac0caa3a
