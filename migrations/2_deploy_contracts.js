const Uber = artifacts.require("Uber");
const UberToken = artifacts.require("UberToken");

module.exports = function(deployer) {
  deployer.deploy(Uber).then(function() {
    return deployer.deploy(UberToken, Uber.address);
  });
};
