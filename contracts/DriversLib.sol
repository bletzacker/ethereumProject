// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

library Drivers {
    
    enum Status {available, unavailable}
    
    struct Driver {
        uint index; // index start from 1
        string name;
        Status status;
        address rideAddress;
    }

    function add(mapping(address => Driver) storage _mapping, address[] storage _array, address _address, string memory _name) internal {
        Driver memory driver = Driver(0, _name, Status.available,address(0));
        _array.push(_address);
        driver.index = _array.length; // index start from 1
        _mapping[_address] = driver;
    }

    function updateName(mapping(address => Driver) storage _mapping, address _address, string memory _name) internal {
        _mapping[_address].name = _name;
    }

    function updateStatus(mapping(address => Driver) storage _mapping, address _address, Drivers.Status _status) internal {
        _mapping[_address].status = _status;
    }

    function updateRideAddress(mapping(address => Driver) storage _mapping, address _address, address _rideAddress) internal {
        _mapping[_address].rideAddress = _rideAddress;
    }

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
    
    function size(address[] storage _array) internal view returns (uint) {
        return uint(_array.length);
    }
    
    function contains(mapping(address => Driver) storage _mapping, address _address) internal view returns (bool) {
        return _mapping[_address].index > 0;
    }
    
    function getByAddress(mapping(address => Driver) storage _mapping, address _address) internal view returns (Driver memory) {
        return _mapping[_address];
    }

    function getByIndex(mapping(address => Driver) storage _mapping, address[] storage _array, uint _index) internal view returns (Driver memory) {
        require(_index >= 0);
        require(_index <= _array.length);
        return _mapping[_array[_index-1]];
    }
    
    function getAddresses(address[] storage _array) internal pure returns (address[] memory) {
        return _array;
    }
}