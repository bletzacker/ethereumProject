// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./RideContract.sol";

library Rides {
    
    struct Ride {
        uint index; // index start from 1
        RideContract rideContract;
    }
    
    // Ride's address = Customer's address
    function add(
        mapping(address => Ride) storage _mapping,
        address[] storage _array,
        address _address,
        uint _pickup_lat,
        uint _pickup_long,
        uint _destination_lat,
        uint _destination_long
        ) internal {
        RideContract rideContract = new RideContract(_pickup_lat,_pickup_long,_destination_lat,_destination_long);
        Ride memory ride = Ride(0, rideContract);
        _array.push(_address);
        ride.index = _array.length; // index start from 1
        _mapping[_address] = ride;
    }
    
    function remove(mapping(address => Ride) storage _mapping, address[] storage _array, address _address) internal {
        Ride memory ride = _mapping[_address];
        require(ride.index != 0);
        require(ride.index <= _array.length);
        
        uint _arrayIndex = ride.index - 1;
        uint _arrayLastIndex = _array.length - 1;
        _mapping[_array[_arrayLastIndex]].index = _arrayIndex + 1;
        _array[_arrayIndex] = _array[_arrayLastIndex];
        _array.pop();
        delete _mapping[_address];
    }
       
    function size(address[] storage _array) internal view returns (uint) {
        return uint(_array.length);
    }
    
    function contains(mapping(address => Ride) storage _mapping, address _address) internal view returns (bool) {
        return _mapping[_address].index > 0;
    }
    
    function getByAddress(mapping(address => Ride) storage _mapping, address _address) internal view returns (Ride memory) {
        return _mapping[_address];
    }
         
    function getByIndex(mapping(address => Ride) storage _mapping, address[] storage _array, uint _index) internal view returns (Ride memory) {
        require(_index >= 0);
        require(_index <= _array.length);
        return _mapping[_array[_index-1]];
    }
    
    function getAddresses(address[] storage _array) internal pure returns (address[] memory) {
        return _array;
    }
}