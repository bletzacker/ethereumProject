// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import {Drivers} from "../contracts/DriversLib.sol"; // Drivers is a library

contract TestDriversLib {

    mapping(address => Drivers.Driver) _mapping;
    address[] _array;

    function beforeEach() public {
        Drivers.add(_mapping, _array, msg.sender, "Laurent");
    }

    function afterEach() public {
        if (_array.length != 0) {
            Drivers.remove(_mapping, _array, msg.sender);
        }         
    }        
 
    function testAdd() public {     
        Assert.equal(_array[0], msg.sender, "");
        Assert.equal(_array.length, uint(1), "");
        Assert.equal(_mapping[msg.sender].name, "Laurent", "");
        Assert.equal(_mapping[msg.sender].index, uint(1), "");
        Assert.equal(uint(_mapping[msg.sender].status), uint(Drivers.Status.available), "");
        Assert.equal(_mapping[msg.sender].rideAddress, address(0), "");
    }
        
    function testUpdateName() public {
        Drivers.updateName(_mapping, msg.sender, "Mathieu");

        Assert.equal(_array[0], msg.sender, "");
        Assert.equal(_array.length, uint(1), "");
        Assert.equal(_mapping[msg.sender].name, "Mathieu", "");
        Assert.equal(_mapping[msg.sender].index, uint(1), "");
        Assert.equal(uint(_mapping[msg.sender].status), uint(Drivers.Status.available), "");
        Assert.equal(_mapping[msg.sender].rideAddress, address(0), "");
    }

    function testUpdateStatus() public {
        Drivers.updateStatus(_mapping, msg.sender, Drivers.Status.unavailable);

        Assert.equal(_array[0], msg.sender, "");
        Assert.equal(_array.length, uint(1), "");
        Assert.equal(_mapping[msg.sender].name, "Laurent", "");
        Assert.equal(_mapping[msg.sender].index, uint(1), "");
        Assert.equal(uint(_mapping[msg.sender].status), uint(Drivers.Status.unavailable), "");
        Assert.equal(_mapping[msg.sender].rideAddress, address(0), "");  
    }

    function testUpdateRideAddress() public {
        Drivers.updateRideAddress(_mapping, msg.sender, 0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7);

        Assert.equal(_array[0], msg.sender, "");
        Assert.equal(_array.length, uint(1), "");
        Assert.equal(_mapping[msg.sender].name, "Laurent", "");
        Assert.equal(_mapping[msg.sender].index, uint(1), "");
        Assert.equal(uint(_mapping[msg.sender].status), uint(Drivers.Status.available), "");
        Assert.equal(_mapping[msg.sender].rideAddress, address(0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7), "");
    }

    function testRemove() public {
        Drivers.remove(_mapping, _array, msg.sender);

        //Assert.equal(_array, [], "_array[0]"); Chercher la valeur par défault pour array
        Assert.equal(_array.length, uint(0), "");
        Assert.equal(_mapping[msg.sender].name, "", "");
        Assert.equal(_mapping[msg.sender].index, uint(0), "");
        Assert.equal(uint(_mapping[msg.sender].status), uint(Drivers.Status.available), "");
        Assert.equal(_mapping[msg.sender].rideAddress, address(0), "");
    }

    function testSize() public {
        Assert.equal(Drivers.size(_array), uint(1), "");
    }

    function testContains() public {
        Assert.equal(Drivers.contains(_mapping, msg.sender), true, "");
        Assert.equal(Drivers.contains(_mapping, address(0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7)), false, "");
        Assert.equal(Drivers.contains(_mapping, address(0)), false, "");
    }

    function testGetByaddress() public {
        Assert.equal(Drivers.getByAddress(_mapping, msg.sender).name, "Laurent", "");
        Assert.equal(Drivers.getByAddress(_mapping, msg.sender).index, uint(1), "");
        Assert.equal(uint(Drivers.getByAddress(_mapping, msg.sender).status), uint(Drivers.Status.available), "");
        Assert.equal(Drivers.getByAddress(_mapping, msg.sender).rideAddress, address(0), "");
    }

    function testGetByIndex() public {
        Assert.equal(Drivers.getByIndex(_mapping, _array, 1).name, "Laurent", "");
        Assert.equal(Drivers.getByIndex(_mapping, _array, 1).index, uint(1), "");
        Assert.equal(uint(Drivers.getByIndex(_mapping, _array, 1).status), uint(Drivers.Status.available), "");
        Assert.equal(Drivers.getByIndex(_mapping, _array, 1 ).rideAddress, address(0), "");
    }

    function testGetAddresses() public {
        Assert.equal(Drivers.getAddresses(_array)[0], msg.sender, "");
    }
}