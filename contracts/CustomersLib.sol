// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

library Customers {
    
    enum Status {available, unavailable}
    
    struct Customer {
        uint index; // index start from 1
        string name;
        Status status;
        address rideAddress;
        address driverAddress;
    }
    
    function add(mapping(address => Customer) storage _mapping, address[] storage _array, address _address, string memory _name) internal {
        Customer memory customer = Customer(0, _name, Status.available,address(0),address(0));
        _array.push(_address);
        customer.index = _array.length; // index start from 1
        _mapping[_address] = customer;
    }
    
    function updateName(mapping(address => Customer) storage _mapping, address _address, string memory _name) internal {
        _mapping[_address].name = _name;
    }
    
    function updateStatus(mapping(address => Customer) storage _mapping, address _address, Customers.Status _status) internal {
        _mapping[_address].status = _status;
    }
    
    function updateRideAddress(mapping(address => Customer) storage _mapping, address _address, address _rideAddress) internal {
        _mapping[_address].rideAddress = _rideAddress;
    }
    
    function updateDriverAddress(mapping(address => Customer) storage _mapping, address _address, address _driverAddress) internal {
        _mapping[_address].driverAddress = _driverAddress;
    }
    
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
    
    function size(address[] storage _array) internal view returns (uint) {
        return uint(_array.length);
    }
    
    function contains(mapping(address => Customer) storage _mapping, address _address) internal view returns (bool) {
        return _mapping[_address].index > 0;
    }
        
    function getByAddress(mapping(address => Customer) storage _mapping, address _address) internal view returns (Customer memory) {
        return _mapping[_address];
    }
       
    function getByIndex(mapping(address => Customer) storage _mapping, address[] storage _array, uint _index) internal view returns (Customer memory) {
        require(_index >= 0);
        require(_index <= _array.length);
        return _mapping[_array[_index-1]];
    }
    
    function getAddresses(address[] storage _array) internal pure returns (address[] memory) {
        return _array;
    }
}