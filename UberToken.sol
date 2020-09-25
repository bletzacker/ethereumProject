// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

/// @title UberToken Contract
/// @author Laurent BLETZACKER
/// @notice
/// @dev
contract UberToken is ERC20 {
    
    /// @notice constructor
    /// @dev constructor
    /// @param contractAddr Contract's address
    constructor(address contractAddr) public ERC20("UberToken", "UBER") {
        _mint(contractAddr, 1000000);
    }
    
    /// @notice approveFrom
    /// @dev approveFrom
    /// @param from From this address
    /// @param to To this address
    /// @param amount Amount of transfer
    function approveUberToken(address from,address to, uint256 amount) private {
        _approve(from, to, amount);
    }
    
    /// @notice transferUber
    /// @dev transferUber
    /// @param from From this address
    /// @param to To this address
    /// @param amount Amount of transfer
    function transferUberToken(address from,address to, uint256 amount) private {
        _transfer(from, to, amount);
    }
    
    /// @notice approuveAndTransferUber
    /// @dev approuveAndTransferUber
    /// @param from From this address
    /// @param to To this address
    /// @param amount Amount of transfer
    function approveAndTransferUberToken(address from,address to, uint256 amount) external {
        approveUberToken(from, to, amount);
        transferUberToken(from,to, amount);
    }
}