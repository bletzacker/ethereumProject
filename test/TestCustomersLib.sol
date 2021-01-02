// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import {Customers} from "../contracts/CustomersLib.sol"; // Customers is a library

contract TestCustomersLib {

    mapping(address => Customers.Customer) _mapping;
    address[] _array;

    function beforeEach() public {
        Customers.add(_mapping, _array, msg.sender, "Laurent");
    }

    function afterEach() public {
        if (_array.length != 0) {
            Customers.remove(_mapping, _array, msg.sender);
        }         
    }        
 
    function testAdd() public {     
        Assert.equal(_array[0], msg.sender, "");
        Assert.equal(_array.length, uint(1), "");
        Assert.equal(_mapping[msg.sender].name, "Laurent","");
        Assert.equal(_mapping[msg.sender].index, uint(1), "");
        Assert.equal(uint(_mapping[msg.sender].status), uint(Customers.Status.available), "");
        Assert.equal(_mapping[msg.sender].rideAddress, address(0), "");
    }
        
    function testUpdateName() public {
        Customers.updateName(_mapping, msg.sender, "Mathieu");

        Assert.equal(_array[0], msg.sender, "");
        Assert.equal(_array.length, uint(1), "");
        Assert.equal(_mapping[msg.sender].name, "Mathieu", "");
        Assert.equal(_mapping[msg.sender].index, uint(1), "");
        Assert.equal(uint(_mapping[msg.sender].status), uint(Customers.Status.available), "");
        Assert.equal(_mapping[msg.sender].rideAddress, address(0), "");
    }

    function testUpdateStatus() public {
        Customers.updateStatus(_mapping, msg.sender, Customers.Status.unavailable);

        Assert.equal(_array[0], msg.sender, "");
        Assert.equal(_array.length, uint(1), "");
        Assert.equal(_mapping[msg.sender].name, "Laurent", "");
        Assert.equal(_mapping[msg.sender].index, uint(1), "");
        Assert.equal(uint(_mapping[msg.sender].status), uint(Customers.Status.unavailable), "");
        Assert.equal(_mapping[msg.sender].rideAddress, address(0), "");  
    }

    function testUpdateRideAddress() public {
        Customers.updateRideAddress(_mapping, msg.sender, 0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7);

        Assert.equal(_array[0], msg.sender, "");
        Assert.equal(_array.length, uint(1), "");
        Assert.equal(_mapping[msg.sender].name, "Laurent", "");
        Assert.equal(_mapping[msg.sender].index, uint(1), "");
        Assert.equal(uint(_mapping[msg.sender].status), uint(Customers.Status.available), "");
        Assert.equal(_mapping[msg.sender].rideAddress, address(0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7), "");
    }

    function testRemove() public {
        Customers.remove(_mapping, _array, msg.sender);

        //Assert.equal(_array, [], "_array[0]"); Chercher la valeur par défault pour array
        Assert.equal(_array.length, uint(0), "");
        Assert.equal(_mapping[msg.sender].name, "", "");
        Assert.equal(_mapping[msg.sender].index, uint(0), "");
        Assert.equal(uint(_mapping[msg.sender].status), uint(Customers.Status.available), "");
        Assert.equal(_mapping[msg.sender].rideAddress, address(0), "");
    }

    function testSize() public {
        Assert.equal(Customers.size(_array), uint(1), "size(_array)");
    }

    function testContains() public {
        Assert.equal(Customers.contains(_mapping, msg.sender), true, "");
        Assert.equal(Customers.contains(_mapping, address(0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7)), false, "");
        Assert.equal(Customers.contains(_mapping, address(0)), false, "");
    }

    function testGetByaddress() public {
        Assert.equal(Customers.getByAddress(_mapping, msg.sender).name, "Laurent", "");
        Assert.equal(Customers.getByAddress(_mapping, msg.sender).index, uint(1), "");
        Assert.equal(uint(Customers.getByAddress(_mapping, msg.sender).status), uint(Customers.Status.available), "");
        Assert.equal(Customers.getByAddress(_mapping, msg.sender).rideAddress, address(0), "");
    }

    function testGetByIndex() public {
        Assert.equal(Customers.getByIndex(_mapping, _array, 1).name, "Laurent", "");
        Assert.equal(Customers.getByIndex(_mapping, _array, 1).index, uint(1), "");
        Assert.equal(uint(Customers.getByIndex(_mapping, _array, 1).status), uint(Customers.Status.available), "");
        Assert.equal(Customers.getByIndex(_mapping, _array, 1).rideAddress, address(0), "");
    }

    function testGetAddresses() public {
        Assert.equal(Customers.getAddresses(_array)[0], msg.sender, "Customers.getAddresses(_array)[0]");
    }
}