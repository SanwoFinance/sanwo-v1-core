// SPDX-License-Identifier: MIT
// This file has been copied and modified from the DePayV1 core repo
pragma solidity 0.8.1;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";

// Prevents unwanted access to configuration in SanwoRouterV1
// Potentially occuring through delegatecall(ing) plugins.
contract SanwoV1Config is Ownable {
  
  // List of approved plugins. Use approvePlugin to add new plugins.
  mapping (address => address) public approvedPlugins;

  // Approves the provided plugin.
  function approvePlugin(address plugin) external onlyOwner returns(bool) {
    approvedPlugins[plugin] = plugin;
    emit PluginApproved(plugin);
    return true;
  }

  // Event to emit newly approved plugin.
  event PluginApproved(
    address indexed pluginAddress
  );

  // Disapproves the provided plugin.
  function disapprovePlugin(address plugin) external onlyOwner returns(bool) {
    approvedPlugins[plugin] = address(0);
    emit PluginDisapproved(plugin);
    return true;
  }

  // Event to emit disapproved plugin.
  event PluginDisapproved(
    address indexed pluginAddress
  );
}
