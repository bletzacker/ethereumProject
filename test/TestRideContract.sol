// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RideContract.sol";

contract TestRideContract {

    RideContract rideContract = new RideContract(10,9,8,7);
    
    function testCostCalculation() public {
        Assert.equal(rideContract.costCalculation(), uint(8*10**15), "");
    }
} 