// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "RideContract.sol";

/// @title Library for Rides
/// @author Laurent BLETZACKER
/// @notice
/// @dev
library Rides {
    
    struct Ride {
        uint index; // index start from 1
        RideContract rideContract;
    }
    
    /// @notice add
    /// @dev add
    /// @param _mapping Mapping of Ride's by address
    /// @param _array Array of Ride
    /// @param _address Ride's address = Customer's address
    /// @param _pickup_lat Pickup latitude
    /// @param _pickup_long Pickup longitude
    /// @param _destination_lat Destination latitude
    /// @param _destination_long Destination longitude
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
    
    /// @notice remove
    /// @dev remove
    /// @param _mapping Mapping of Ride's by address
    /// @param _array Array of Ride
    /// @param _address Ride's address    
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
    
    /// @notice size
    /// @dev size
    /// @return uint    
    function size(address[] storage _array) internal view returns (uint) {
        return uint(_array.length);
    }
    
    /// @notice contains
    /// @dev contains
    /// @param _mapping Mapping of Ride's by address
    /// @param _address Ride's address
    /// @return bool 
    function contains(mapping(address => Ride) storage _mapping, address _address) internal view returns (bool) {
        return _mapping[_address].index > 0;
    }
    
    /// @notice getByaddress
    /// @dev getByaddress
    /// @param _mapping Mapping of Ride's by address
    /// @param _address Ride's address
    /// @return Ride 
    function getByaddress(mapping(address => Ride) storage _mapping, address _address) internal view returns (Ride memory) {
        return _mapping[_address];
    }
    
    /// @notice getByIndex
    /// @dev getByIndex
    /// @param _mapping Mapping of Ride's by address
    /// @param _array Array of Ride
    /// @param _index Ride's index
    /// @return Ride      
    function getByIndex(mapping(address => Ride) storage _mapping, address[] storage _array, uint _index) internal view returns (Ride memory) {
        require(_index >= 0);
        require(_index < _array.length);
        return _mapping[_array[_index]];
    }
    
    /// @notice getAddresses
    /// @dev getAddresses
    /// @param _array Array of Ride
    /// @return address[]  
    function getAddresses(address[] storage _array) internal pure returns (address[] memory) {
        return _array;
    }
}