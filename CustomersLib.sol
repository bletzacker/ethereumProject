// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/// @title Library for Customers
/// @author Laurent BLETZACKER
/// @notice
/// @dev
library Customers {
    
    enum Status {available, unavailable}
    
    struct Customer {
        uint index; // index start from 1
        string name;
        Status status;
        address rideAddress;
    }
    
    /// @notice add
    /// @dev add
    /// @param _mapping Mapping of Customer's by address
    /// @param _array Array of Customer
    /// @param _address Customer's address
    /// @param _name Name of the new Customer
    function add(mapping(address => Customer) storage _mapping, address[] storage _array, address _address, string memory _name) internal {
        Customer memory customer = Customer(0, _name, Status.available,address(0));
        _array.push(_address);
        customer.index = _array.length; // index start from 1
        _mapping[_address] = customer;
        }
    
    /// @notice updateName
    /// @dev updateName
    /// @param _mapping Mapping of Customer's by address
    /// @param _address Customer's address
    /// @param _name New name of the Customer
    function updateName(mapping(address => Customer) storage _mapping, address _address, string memory _name) internal {
        _mapping[_address].name = _name;
    }
    
    /// @notice updateStatus
    /// @dev updateStatus
    /// @param _mapping Mapping of Customer's by address
    /// @param _address Customer's address
    /// @param _status New status of the Customer
    function updateStatus(mapping(address => Customer) storage _mapping, address _address, Customers.Status _status) internal {
        _mapping[_address].status = _status;
    }
    
    /// @notice updateRideAddress
    /// @dev updateRideAddress
    /// @param _mapping Mapping of Customer's by address
    /// @param _address Customer's address
    /// @param _rideAddress New rideAddress of the Customer
    function updateRideAddress(mapping(address => Customer) storage _mapping, address _address, address _rideAddress) internal {
        _mapping[_address].rideAddress = _rideAddress;
    }
    
    /// @notice remove
    /// @dev remove
    /// @param _mapping Mapping of Customer's by address
    /// @param _array Array of Customer
    /// @param _address Customer's address
    function remove(mapping(address => Customer) storage _mapping, address[] storage _array, address _address) internal {
        Customer memory customer = _mapping[_address];
        require(customer.index != 0);
        require(customer.index <= _array.length);
        
        uint _arrayIndex = customer.index - 1;
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
    /// @param _mapping Mapping of Customer's by address
    /// @param _address Customer's address
    /// @return bool
    function contains(mapping(address => Customer) storage _mapping, address _address) internal view returns (bool) {
        return _mapping[_address].index > 0;
    }
    
    /// @notice getByaddress
    /// @dev getByaddress
    /// @param _mapping Mapping of Customer's by address
    /// @param _address Customer's address
    /// @return Customer     
    function getByaddress(mapping(address => Customer) storage _mapping, address _address) internal view returns (Customer memory) {
        return _mapping[_address];
    }
    
    /// @notice getByIndex
    /// @dev getByIndex
    /// @param _mapping Mapping of Customer's by address
    /// @param _array Array of Customer
    /// @param _index Customer's index
    /// @return Customer     
    function getByIndex(mapping(address => Customer) storage _mapping, address[] storage _array, uint _index) internal view returns (Customer memory) {
        require(_index >= 0);
        require(_index < _array.length);
        return _mapping[_array[_index]];
    }
    
    /// @notice getAddresses
    /// @dev getAddresses
    /// @param _array Array of Customer
    /// @return address[] 
    function getAddresses(address[] storage _array) internal pure returns (address[] memory) {
        return _array;
    }
}