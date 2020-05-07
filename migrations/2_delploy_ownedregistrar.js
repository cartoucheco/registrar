var OwnedRegistrar = artifacts.require("./OwnedRegistrar.sol");

module.exports = function(deployer) {
  deployer.deploy(OwnedRegistrar, "0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e");
};