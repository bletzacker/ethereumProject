// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import {Rides} from "../contracts/RidesLib.sol"; // Rides is a library

contract TestRidesLib {

    mapping(address => Rides.Ride) _mapping;
    address[] _array;

    function beforeEach() public {
        Rides.add(_mapping, _array, msg.sender, 10, 9, 8, 7);
    }

    function afterEach() public {
        if (_array.length != 0) {
            Rides.remove(_mapping, _array, msg.sender);
        }         
    } 

    function testAdd() public {
        Assert.equal(_array[0], msg.sender, "");
        Assert.equal(_array.length, uint(1), "");
        Assert.equal(_mapping[msg.sender].index, uint(1), "");
        Assert.equal(_mapping[msg.sender].rideContract.costCalculation(), uint(8*10**15), "");
    }

    function testRemove() public {        
        Rides.remove(_mapping, _array, msg.sender);

        //Assert.equal(_array, [], "_array[0]"); Chercher la valeur par défault pour array
        Assert.equal(_array.length, uint(0), "");
        Assert.equal(_mapping[msg.sender].index, uint(0), "");
        Assert.equal(address(_mapping[msg.sender].rideContract), address(0), "");
    }

    function testSize() public {
        Assert.equal(Rides.size(_array), uint(1), "");
    }
    
    function testContains() public {
        Assert.equal(Rides.contains(_mapping, msg.sender), true, "");
        Assert.equal(Rides.contains(_mapping, address(0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7)), false, "");
        Assert.equal(Rides.contains(_mapping, address(0)), false, "");
    }

    function testGetByAddres() public {
        Assert.equal(Rides.getByAddress(_mapping, msg.sender).index, uint(1), "");
        Assert.equal(Rides.getByAddress(_mapping, msg.sender).rideContract.costCalculation(), uint(8*10**15), "");
    }

    function testgetByIndex() public {
        Assert.equal(Rides.getByIndex(_mapping, _array, 1).index, uint(1), "");
        Assert.equal(Rides.getByIndex(_mapping, _array, 1).rideContract.costCalculation(), uint(8*10**15), "");
    }

    function testGetAddresses() public {
         Assert.equal(Rides.getAddresses(_array)[0], msg.sender, "");
    }
}