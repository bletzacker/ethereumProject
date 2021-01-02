// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

contract RideContract {
    
    uint internal pickup_lat;
    uint internal pickup_long;
    uint internal destination_lat;
    uint internal destination_long;
    uint internal cost;
    
    constructor(uint _pickup_lat, uint _pickup_long, uint  _destination_lat, uint _destination_long) public {
        pickup_lat = _pickup_lat;
        pickup_long = _pickup_long;
        destination_lat = _destination_lat;
        destination_long = _destination_long;
    }
    
    /// @dev New from 0.6.x
    receive() external payable {
    }
    
    function costCalculation() external returns (uint) {
        cost =  (  (destination_lat - pickup_lat)
                * (destination_lat - pickup_lat)
                + (destination_long - pickup_long)
                * (destination_long - pickup_long)
                ) * 10**15; // Model of price to change
        return cost;
    }
}