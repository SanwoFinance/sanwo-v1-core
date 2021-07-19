// SPDX-License-Identifier: MIT
// This file has been copied and modified from the DePayV1 core repo

pragma solidity 0.8.0;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import '../libraries/SafeToken.sol';

contract SanwoV1PaymentPlugin01 {

  // Address representating ETH (e.g. in payment routing paths)
  address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  // Indicates that this plugin requires delegate call
  bool public immutable delegate = true;

  event Payment(
    address indexed sender,
    address payable indexed receiver
  );

  function execute(
    address[] calldata path,
    uint[] calldata amounts,
    address[] calldata addresses,
    string[] calldata data
  ) external payable returns(bool) {
    (data);
    if(path[path.length-1] == ETH) {
      SafeToken.safeTransferETH(payable(addresses[addresses.length-1]), amounts[1]);
    } else {
      SafeERC20.safeTransfer(IERC20(path[path.length-1]), payable(addresses[addresses.length-1]), amounts[1]);
    }

    return true;
  }
}
