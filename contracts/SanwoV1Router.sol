// SPDX-License-Identifier: MIT
// This file has been copied and modified from the DePayV1 core repo
pragma solidity 0.8.0;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import './interfaces/ISanwoV1Plugin.sol';
import './libraries/SafeToken.sol';
import './SanwoV1Config.sol';
import "./interfaces/I1InchAggregratorRouter.sol";
import './plugins/SanwoV1InchPlugin01.sol';

contract SanwoRouterV1 {
  
  // Address representating ETH (e.g. in payment routing paths)
  address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  // Instance of ISanwoV1Config
  SanwoV1Config public immutable configuration;

  constructor (
    address _configuration
  ) {
    configuration = SanwoV1Config(_configuration);
  }

  // Proxy modifier to ISanwoV1Config
  modifier onlyOwner() {
    require(configuration.owner() == msg.sender, "Ownable: caller is not the owner");
    _;
  }

  receive() external payable {
    // Accepts ETH payments which is require in order
    // to swap from and to ETH
    // especially unwrapping WETH as part of token swaps.
  }

  // The main function to route transactions.
  function route(
    IAggregationExecutor caller,
    SwapDescription calldata desc,
    address[] calldata plugins,
    bytes calldata data
  ) external payable returns(bool) {
    uint balanceBefore = _balanceBefore(address(desc.dstToken));
    _ensureTransferIn(address(desc.srcToken), desc.amount);
    _execute(caller, desc,plugins, data);
    _ensureBalance(address(desc.dstToken), balanceBefore);
    
    return true;
  }

  // Returns the balance for a token (or ETH) before the payment is executed.
  // In case of ETH we need to deduct what has been payed in as part of the transaction itself.
  function _balanceBefore(address token) private returns (uint balance) {
    balance = _balance(token);
    if(token == ETH) { balance -= msg.value; }
  }

  // This makes sure that the sender has payed in the token (or ETH)
  // required to perform the payment.
  function _ensureTransferIn(address tokenIn, uint amountIn) private {
    if(tokenIn == ETH) { 
      require(msg.value >= amountIn, 'Sanwo: Insufficient ETH amount payed in!'); 
    } else {
      SafeERC20.safeTransferFrom(IERC20(tokenIn), msg.sender, address(this), amountIn);
    }
  }

  // Executes plugins in the given order.
  function _execute(
        IAggregationExecutor caller,
        SwapDescription calldata desc,
        address[] calldata plugins,
        bytes calldata data
  ) internal {
    for (uint i = 0; i < plugins.length; i++) {
      require(_isApproved(plugins[i]), 'Sanwo: Plugin not approved!');
      
      ISanwoRouterV1Plugin plugin = ISanwoRouterV1Plugin(configuration.approvedPlugins(plugins[i]));

      if(plugin.delegate()) {
        (bool success, bytes memory returnData) = address(plugin).delegatecall(abi.encodeWithSelector(
            plugin.execute.selector, caller,desc,data
        ));
        require(success, string(returnData));
      } else {
        (bool success, bytes memory returnData) = address(plugin).call(abi.encodeWithSelector(
            plugin.execute.selector,caller,desc,data
        ));
        require(success, string(returnData));
      }
    }
  }


  // This makes sure that the balance after the payment not less than before.
  // Prevents draining of the contract.
  function _ensureBalance(address tokenOut, uint balanceBefore) private view {
    require(_balance(tokenOut) >= balanceBefore, 'Sanwo: Insufficient balance after payment!');
  }

  // Returns the balance of the payment plugin contract for a token (or ETH).
  function _balance(address token) private view returns(uint) {
    if(token == ETH) {
        return address(this).balance;
    } else {
        return IERC20(token).balanceOf(address(this));
      }
  }

  // Function to check if a plugin address is approved.
  function isApproved(
    address pluginAddress
  ) external view returns(bool){
    return _isApproved(pluginAddress);
  }

  // Internal function to check if a plugin address is approved.
  function _isApproved(
    address pluginAddress
  ) internal view returns(bool) {
    return (configuration.approvedPlugins(pluginAddress) != address(0));
  }
  
  // Allows to withdraw accidentally sent ETH or tokens.
  function withdraw(
    address token,
    uint amount
  ) external onlyOwner returns(bool) {
    if(token == ETH) {
      SafeToken.safeTransferETH(payable(configuration.owner()), amount);
    } else {
      SafeERC20.safeTransfer(IERC20(token), payable(configuration.owner()), amount);
    }
    return true;
  }
}
