// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "UberToken.sol";
import "RideContract.sol";
import {Customers} from "./CustomersLib.sol";
import {Drivers} from "./DriversLib.sol";
import {Rides} from "./RidesLib.sol";

/// @title Uber Contract
/// @author Laurent BLETZACKER
/// @notice
/// @dev 
contract Uber {
    
    UberToken token;
    
    mapping(address => Customers.Customer) internal customers;
    address[] internal customerAddresses;
    
    mapping(address => Drivers.Driver) internal drivers;
    address[] internal driverAddresses;
    
    mapping(address => Rides.Ride) internal rides;
    address[] internal rideAddresses;

    event Registered(address indexed addr, string name, uint fund);
    event Getted(address indexed addr);
    event Updated(address indexed addr, string oldName, string newName);
    event unRegistered(address indexed addr, uint refund);
    
    /// @notice constructor
    /// @dev constructor
    constructor() public payable {
        token = new UberToken(address(this));
    }

    modifier onlyUnregisteredCustomer() {
        require(!Customers.contains(customers, msg.sender), "You are already registered as customer.");
        _;
    }
    
    modifier onlyRegisteredCustomer() {
        require(Customers.contains(customers, msg.sender), "You are unregister as customer.");
        _;
    }
    
    modifier onlyAvailableCustomer(address _addr) {
        require(Customers.getByaddress(customers, _addr).status == Customers.Status.available , "You are in ride.");
        _;
    }
    
    modifier onlyUnregisteredDriver() {
        require(!Drivers.contains(drivers, msg.sender), "You are already registered as driver.");
        _;
    }
    
    modifier onlyRegisteredDriver() {
        require(Drivers.contains(drivers, msg.sender), "You are unregister as driver.");
        _;
    }
    
    modifier onlyAvailableDriver(address _addr) {
        require(Drivers.getByaddress(drivers, _addr).status == Drivers.Status.available , "You are in ride.");
        _;
    }
    
// DEBUG

    /// @notice balance
    /// @dev balance
    /// @param addr address
    /// @return uint balance of the addr in UberToken
    function balance(address addr) public view returns(uint) {
        return token.balanceOf(addr);
    }
    
// Create operation

    /// @notice registerCustomer
    /// @dev registerCustomer
    /// @param _name Customer's Name
    /// @return uint string
    function registerCustomer(string memory _name) public payable onlyUnregisteredCustomer() returns(string memory) {
        Customers.add(customers, customerAddresses, msg.sender, _name);
        token.transfer(msg.sender, msg.value);
        emit Registered(msg.sender, _name, token.balanceOf(msg.sender));
        return "You are registered as Customer.";
    }
    
    /// @notice registerDriver
    /// @dev registerDriver
    /// @param _name Driver's Name
    /// @return uint string
    function registerDriver(string memory _name) public payable onlyUnregisteredDriver() returns(string memory) {
        Drivers.add(drivers, driverAddresses, msg.sender, _name);
        token.transfer(msg.sender, msg.value);
        emit Registered(msg.sender, _name, token.balanceOf(msg.sender));
        return "You are registered as Driver.";
    }

// Read operation
    
    /// @notice readCustomer
    /// @dev readCustomer
    /// @return uint Customers.Customer
    function readCustomer() public onlyRegisteredCustomer() returns(Customers.Customer memory) {
        emit Getted(msg.sender);
        return Customers.getByaddress(customers, msg.sender);
    }
    
    /// @notice readDriver
    /// @dev readDriver
    /// @return uint Drivers.Driver
    function readDriver() public onlyRegisteredDriver() returns(Drivers.Driver memory) {
        emit Getted(msg.sender);
        return Drivers.getByaddress(drivers, msg.sender);
    }
    
// Update operation

    /// @notice updateCustomer
    /// @dev updateCustomer
    /// @return string
    function updateCustomer(string memory newName) public onlyRegisteredCustomer() returns(string memory) {
        string memory oldName = Customers.getByaddress(customers, msg.sender).name;
        Customers.updateName(customers, msg.sender, newName);
        emit Updated(msg.sender, oldName, newName);
        return "Your name is updated";
    }
    
    /// @notice updateDriver
    /// @dev updateDriver
    /// @return string
    function updateDriver(string memory newName) public onlyRegisteredDriver() returns(string memory) {
        string memory oldName = Drivers.getByaddress(drivers, msg.sender).name;
        Drivers.updateName(drivers, msg.sender, newName);
        emit Updated(msg.sender, oldName, newName);
        return "Your name is updated";
    }
    
//  Delete operation

    /// @notice unregiste
    /// @dev unregiste
    function unregister() private {
        uint refund = token.balanceOf(msg.sender);
        if (refund > 0 ) {
            token.approveAndTransferUberToken(msg.sender,address(this), refund);
            msg.sender.transfer(refund);
        }
        emit unRegistered(msg.sender, refund);
    }
  
    /// @notice unregisterCustomer
    /// @dev unregisterCustomer
    /// @return string
    function unregisterCustomer() public onlyRegisteredCustomer() returns(string memory) {
        Customers.remove(customers, customerAddresses, msg.sender);
        unregister();
        return "You are registered as Customer.";
    }
    
    /// @notice unregisterDriver
    /// @dev unregisterDriver
    /// @return string
    function unregisterDriver() public onlyRegisteredDriver() returns(string memory) {
        Drivers.remove(drivers, driverAddresses, msg.sender);
        unregister();
        return "You are registered as Driver.";
    }
   
// Uber logic used by customer  
   
    /// @notice sendRide
    /// @dev sendRide
    /// @param _pickup_lat Pickup latitude
    /// @param _pickup_long Pickup longitude
    /// @param _destination_lat Destination latitude
    /// @param _destination_long Destination longitude
    /// @return string
    function sendRide(  uint _pickup_lat, 
                        uint _pickup_long, 
                        uint _destination_lat, 
                        uint _destination_long) 
                        public onlyRegisteredCustomer() onlyAvailableCustomer(msg.sender) returns (string memory) {
        
        require(!Rides.contains(rides, msg.sender), "You have already requested a ride");
        
        Rides.add(rides, rideAddresses, msg.sender, _pickup_lat, _pickup_long, _destination_lat, _destination_long);
        RideContract ride = Rides.getByaddress(rides, msg.sender).rideContract;
        address rideAddress = address(ride);
        Customers.updateRideAddress(customers, msg.sender, rideAddress);
        uint rideCost = ride.costCalculation();

        token.approveAndTransferUberToken(msg.sender, rideAddress, rideCost);

        return "Your ride is sent.";
    }
   
    /// @notice cancelRide
    /// @dev cancelRide
    /// @return string
    function cancelRide() public onlyRegisteredCustomer() onlyAvailableCustomer(msg.sender) returns (string memory) {
        require(Rides.contains(rides, msg.sender), "You have not requested a ride");
        
        RideContract ride = Rides.getByaddress(rides, msg.sender).rideContract;
        address rideAddress = address(ride);
        uint rideCost = ride.costCalculation();
        
        token.approveAndTransferUberToken(rideAddress, msg.sender, rideCost);
        
        Rides.remove(rides, rideAddresses, msg.sender);
        Customers.updateRideAddress(customers, msg.sender, address(0));
        
        return "Your ride is refund.";
    }

// Uber logic used by driver

    /// @notice getRides
    /// @dev getRides
    /// @return address[]
    function getRides() public view onlyRegisteredDriver() onlyAvailableDriver(msg.sender) returns (address[] memory) {
        return Rides.getAddresses(rideAddresses);
    }
   
    /// @notice startRide
    /// @dev startRide
    /// @param customerAddress Choice one of Customers Address in asdress[] given par getRides
    function startRide(address customerAddress) public onlyRegisteredDriver() onlyAvailableDriver(msg.sender) onlyAvailableCustomer(customerAddress) {
        
        Customers.updateStatus(customers, customerAddress, Customers.Status.unavailable);
        Drivers.updateStatus(drivers, msg.sender, Drivers.Status.unavailable);
        
        address rideAddress = Customers.getByaddress(customers, customerAddress).rideAddress;
        Drivers.updateRideAddress(drivers, msg.sender, rideAddress);
        Rides.remove(rides, rideAddresses, customerAddress);
    }
   
    /// @notice endRide
    /// @dev endRide
    function endRide() public onlyRegisteredDriver() {
        require(Drivers.getByaddress(drivers, msg.sender).status == Drivers.Status.unavailable , "You are not in ride.");
        
        address rideAddress = Drivers.getByaddress(drivers,msg.sender).rideAddress;
        
        Customers.updateStatus(customers, rideAddress,Customers.Status.available);
        Drivers.updateStatus(drivers, msg.sender,Drivers.Status.available);
        
        token.approveAndTransferUberToken(rideAddress, msg.sender, token.balanceOf(rideAddress));
    }
}