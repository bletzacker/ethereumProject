// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/// @title Library for Drivers
/// @author Laurent BLETZACKER
/// @notice
/// @dev
library Drivers {
    
    enum Status {available, unavailable}
    
    struct Driver {
        uint index; // index start from 1
        string name;
        Status status;
        address rideAddress;
    }
    
    /// @notice add
    /// @dev add
    /// @param _mapping Mapping of Driver's by address
    /// @param _array Array of Driver
    /// @param _address Driver's address
    /// @param _name Name of the new Driver
    function add(mapping(address => Driver) storage _mapping, address[] storage _array, address _address, string memory _name) internal {
        Driver memory driver = Driver(0, _name, Status.available,address(0));
        _array.push(_address);
        driver.index = _array.length; // index start from 1
        _mapping[_address] = driver;
        }
        
    /// @notice updateName
    /// @dev updateName
    /// @param _mapping Mapping of Driver's by address
    /// @param _address Driver's address
    /// @param _name New name of the Driver
    function updateName(mapping(address => Driver) storage _mapping, address _address, string memory _name) internal {
        _mapping[_address].name = _name;
    }
    
    /// @notice updateStatus
    /// @dev updateStatus
    /// @param _mapping Mapping of Driver's by address
    /// @param _address Driver's address
    /// @param _status New status of the Driver
    function updateStatus(mapping(address => Driver) storage _mapping, address _address, Drivers.Status _status) internal {
        _mapping[_address].status = _status;
    }
    
    /// @notice updateRideAddress
    /// @dev updateRideAddress
    /// @param _mapping Mapping of Driver's by address
    /// @param _address Driver's address
    /// @param _rideAddress New rideAddress of the Driver
    function updateRideAddress(mapping(address => Driver) storage _mapping, address _address, address _rideAddress) internal {
        _mapping[_address].rideAddress = _rideAddress;
    }
    
    /// @notice remove
    /// @dev remove
    /// @param _mapping Mapping of Driver's by address
    /// @param _array Array of Driver
    /// @param _address Driver's address
    function remove(mapping(address => Driver) storage _mapping, address[] storage _array, address _address) internal {
        Driver memory driver = _mapping[_address];
        require(driver.index != 0);
        require(driver.index <= _array.length);
        
        uint _arrayIndex = driver.index - 1;
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
    /// @param _mapping Mapping of Driver's by address
    /// @param _address Driver's address
    /// @return bool
    function contains(mapping(address => Driver) storage _mapping, address _address) internal view returns (bool) {
        return _mapping[_address].index > 0;
    }
    
    /// @notice getByaddress
    /// @dev getByaddress
    /// @param _mapping Mapping of Driver's by address
    /// @param _address Driver's address
    /// @return Driver 
    function getByaddress(mapping(address => Driver) storage _mapping, address _address) internal view returns (Driver memory) {
        return _mapping[_address];
    }
    
    /// @notice getByIndex
    /// @dev getByIndex
    /// @param _mapping Mapping of Driver's by address
    /// @param _array Array of Driver
    /// @param _index Driver's index
    /// @return Driver   
    function getByIndex(mapping(address => Driver) storage _mapping, address[] storage _array, uint _index) internal view returns (Driver memory) {
        require(_index >= 0);
        require(_index < _array.length);
        return _mapping[_array[_index]];
    }
    
    /// @notice getAddresses
    /// @dev getAddresses
    /// @param _array Array of Driver
    /// @return address[] 
    function getAddresses(address[] storage _array) internal pure returns (address[] memory) {
        return _array;
    }
}