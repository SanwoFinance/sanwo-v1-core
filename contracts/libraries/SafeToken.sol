// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import './openzeppelin/contracts/token/ERC20/SafeERC20.sol';

// Helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
contract SafeToken{
  using SafeERC20 for IERC20;
  
  function safeTransferETH(address to, uint256 value) external {
    (bool success, ) = to.call{value: value}(new bytes(0));
    require(success, 'Helper::safeTransferETH: ETH transfer failed');
  }

  function SafeTransfer(IERC20 token, address to, uint256 value) external {
       token.safeTransfer(to, value);
  }

  function SafeTransferFrom(IERC20 token, address from, address to, uint256 value) external {
    token.safeTransferFrom( from, to, value);
    
  }
}

