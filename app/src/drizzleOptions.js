import Web3 from "web3";
import Uber from "./contracts/Uber.json";
import UberToken from "./contracts/UberToken.json";

const options = {
//  web3: {
//    block: false,
//    customProvider: new Web3(Web3.givenProvider || "ws://localhost:8545"),
//    customProvider: new Web3("ws://localhost:8545"),
//  },
  contracts: [Uber, UberToken],
  events: {
    Uber: ["Registered", "Getted", "Updated", "unRegistered"],
  },
  polls: {
    accounts: 100
  },
};

export default options;
