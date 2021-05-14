pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol"

// Helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library SafeToken is SafeERC20{
  function safeTransferETH(address to, uint256 value) internal {
    (bool success, ) = to.call{value: value}(new bytes(0));
    require(success, 'Helper::safeTransferETH: ETH transfer failed');
  }
}
