// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import '../libraries/openzeppelin/contracts/token/ERC20/SafeERC20.sol';

// Helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
interface ISafeToken{

  
  function safeTransferETH(address to, uint256 value) external;

  function SafeTransfer(IERC20 token, address to, uint256 value) external;

  function SafeTransferFrom(IERC20 token, address from, address to, uint256 value) external;
}
