// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/// @title Ride Contract
/// @author Laurent BLETZACKER
/// @notice
/// @dev
contract RideContract {
    
    uint pickup_lat;
    uint pickup_long;
    uint destination_lat;
    uint destination_long;
    uint cost;
    
    /// @notice constructor
    /// @dev constructor
    /// @param _pickup_lat Pickup latitude
    /// @param _pickup_long Pickup longitude
    /// @param _destination_lat Destination latitude
    /// @param _destination_long Destination longitude
    constructor(uint _pickup_lat, uint _pickup_long, uint  _destination_lat, uint _destination_long) public {
        pickup_lat = _pickup_lat;
        pickup_long = _pickup_long;
        destination_lat = _destination_lat;
        destination_long = _destination_long;
    }
    
    /// @notice receive
    /// @dev New from 0.6.x
    receive () external payable {
    }
    
    /// @notice costCalcul
    /// @dev costCalcul
    /// @return uint
    function costCalculation() external returns (uint) {
        cost = 1 * (  (destination_lat - pickup_lat) 
                    * (destination_lat - pickup_lat)
                    + (destination_long - pickup_long)
                    * (destination_long - pickup_long)
                    ); // Model of price to change
        return cost;
    }
}