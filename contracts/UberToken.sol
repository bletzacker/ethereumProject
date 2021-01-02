// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol"; //on Remix

contract UberToken is ERC20 {
    
    constructor(address contractAddr) public ERC20("UberToken", "UBER") {
        _mint(contractAddr, 10**6 * 10**18);
        _setupDecimals(0);
    }

    function approveUberToken(address from,address to, uint256 amount) external {
        _approve(from, to, amount);
    }
    
    function transferUberToken(address from,address to, uint256 amount) external {
        _transfer(from, to, amount);
    }
    
    function approveAndTransferUberToken(address from,address to, uint256 amount) external {
        _approve(from, to, amount);
        _transfer(from, to, amount);
    }
}