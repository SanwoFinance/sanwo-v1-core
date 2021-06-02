// SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

// Helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library SafeToken{
  function safeTransferETH(address to, uint256 value) internal {
    (bool success, ) = to.call{value: value}(new bytes(0));
    require(success, 'Helper::safeTransferETH: ETH transfer failed');
  }
}
