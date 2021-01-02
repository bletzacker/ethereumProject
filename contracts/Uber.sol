// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "./UberToken.sol";
import "./RideContract.sol";
import {Customers} from "./CustomersLib.sol";
import {Drivers} from "./DriversLib.sol";
import {Rides} from "./RidesLib.sol";

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
        require(Customers.getByAddress(customers, _addr).status == Customers.Status.available , "You are in ride.");
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
        require(Drivers.getByAddress(drivers, _addr).status == Drivers.Status.available , "You are in ride.");
        _;
    }
    
// DEBUG

    function allowanceUBER(address owner,address spender) public view returns(uint) {
        return token.allowance(owner, spender)/(10**15);
    }

    function balanceUBER(address addr) public view returns(uint) {
        return token.balanceOf(addr)/(10**15);
    }
    
// Create operation

    function registerCustomer(string memory _name) public payable onlyUnregisteredCustomer() returns(string memory) {
        Customers.add(customers, customerAddresses, msg.sender, _name);
        token.approveAndTransferUberToken(address(this), msg.sender, msg.value);
        emit Registered(msg.sender, _name, token.balanceOf(msg.sender));
        return "You are registered as Customer.";
    }
    
    function registerDriver(string memory _name) public payable onlyUnregisteredDriver() returns(string memory) {
        Drivers.add(drivers, driverAddresses, msg.sender, _name);
        token.approveAndTransferUberToken(address(this), msg.sender, msg.value);
        emit Registered(msg.sender, _name, token.balanceOf(msg.sender));
        return "You are registered as Driver.";
    }

// Read operation
    
    function readCustomer() public view returns(Customers.Customer memory) {
        return Customers.getByAddress(customers, msg.sender);
    }

    function readCustomerName() public view returns(string memory) {
        return readCustomer().name;
    }
    
    function readDriver() public view returns(Drivers.Driver memory) {
        return Drivers.getByAddress(drivers, msg.sender);
    }

    function readDriverName() public view returns(string memory) {
        return readDriver().name;
    }
    
// Update operation

    function updateCustomer(string memory newName) public onlyRegisteredCustomer() returns(string memory) {
        string memory oldName = Customers.getByAddress(customers, msg.sender).name;
        Customers.updateName(customers, msg.sender, newName);
        emit Updated(msg.sender, oldName, newName);
        return "Your name is updated";
    }
    
    function updateDriver(string memory newName) public onlyRegisteredDriver() returns(string memory) {
        string memory oldName = Drivers.getByAddress(drivers, msg.sender).name;
        Drivers.updateName(drivers, msg.sender, newName);
        emit Updated(msg.sender, oldName, newName);
        return "Your name is updated";
    }
    
//  Delete operation

    function unregister() private {
        uint refund = token.balanceOf(msg.sender);
        if (refund > 0 ) {
            token.approveAndTransferUberToken(msg.sender,address(this), refund);
            msg.sender.transfer(refund);
        }
        emit unRegistered(msg.sender, refund);
    }
  
    function unregisterCustomer() public onlyRegisteredCustomer() returns(string memory) {
        require(!Rides.contains(rides, msg.sender), "You have to cancel your ride before unregister");
        Customers.remove(customers, customerAddresses, msg.sender);
        unregister();
        return "You are unregistered as Customer.";
    }
    
    function unregisterDriver() public onlyRegisteredDriver() returns(string memory) {
        Drivers.remove(drivers, driverAddresses, msg.sender);
        unregister();
        return "You are unregistered as Driver.";
    }
   
// Uber logic used by customer  
   
    function sendRide(  uint _pickup_lat, 
                        uint _pickup_long, 
                        uint _destination_lat, 
                        uint _destination_long) 
                        public onlyRegisteredCustomer() onlyAvailableCustomer(msg.sender) returns (string memory) {
        
        require(!Rides.contains(rides, msg.sender), "You have already requested a ride");
        
        Rides.add(rides, rideAddresses, msg.sender, _pickup_lat, _pickup_long, _destination_lat, _destination_long);
        RideContract ride = Rides.getByAddress(rides, msg.sender).rideContract;
        address rideAddress = address(ride);
        Customers.updateRideAddress(customers, msg.sender, rideAddress);
        uint rideCost = ride.costCalculation();

        token.approveAndTransferUberToken(msg.sender, rideAddress, rideCost);

        return "Your ride is sent.";
    }
   
    function cancelRide() public onlyRegisteredCustomer() onlyAvailableCustomer(msg.sender) returns (string memory) {
        require(Rides.contains(rides, msg.sender), "You have not requested a ride");
        
        RideContract ride = Rides.getByAddress(rides, msg.sender).rideContract;
        address rideAddress = address(ride);
        uint rideCost = ride.costCalculation();
        
        token.approveAndTransferUberToken(rideAddress, msg.sender, rideCost);
        
        Rides.remove(rides, rideAddresses, msg.sender);
        Customers.updateRideAddress(customers, msg.sender, address(0));
        
        return "Your ride is refund.";
    }
    
    function comfirmRide() public onlyRegisteredCustomer() returns (string memory) {
        address rideAddress = Customers.getByAddress(customers, msg.sender).rideAddress;
        Customers.updateStatus(customers, msg.sender, Customers.Status.available);
        token.transferUberToken( rideAddress, 
                                Customers.getByAddress(customers, msg.sender).driverAddress,
                                token.balanceOf(rideAddress));
        return "Your payment is authorized";
    }
    
// Uber logic used by driver

    function getRides() public view returns (address[] memory) {
        return Rides.getAddresses(rideAddresses);
    }
   
    // Choice one of Customers Address in asdress[] given par getRides
    function startRide(address customerAddress) public onlyRegisteredDriver() onlyAvailableDriver(msg.sender) onlyAvailableCustomer(customerAddress) {
        
        Customers.updateStatus(customers, customerAddress, Customers.Status.unavailable);
        Customers.updateDriverAddress(customers, customerAddress, msg.sender);
        Drivers.updateStatus(drivers, msg.sender, Drivers.Status.unavailable);
        
        address rideAddress = Customers.getByAddress(customers, customerAddress).rideAddress;
        Drivers.updateRideAddress(drivers, msg.sender, rideAddress);
        Rides.remove(rides, rideAddresses, customerAddress);
        
        token.approveUberToken(rideAddress, msg.sender, token.balanceOf(rideAddress));
    }
   
    function endRide() public onlyRegisteredDriver() {
        require(Drivers.getByAddress(drivers, msg.sender).status == Drivers.Status.unavailable , "You are not in ride.");
        
        Drivers.updateStatus(drivers, msg.sender, Drivers.Status.available);
    }
}