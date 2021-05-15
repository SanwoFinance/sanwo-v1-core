// SPDX-License-Identifier: MIT

pragma solidity >=0.7.5 <0.8.0;
pragma abicoder v2;

//interface
interface  ISanwoV1Config{

    // checks for the owner 
    function owner() external view returns (address);

  // Approves the provided plugin.
  function approvePlugin(address plugin) external returns(bool);

  // Event to emit newly approved plugin.
  event PluginApproved(
    address indexed pluginAddress
  );

  // Disapproves the provided plugin.
  function disapprovePlugin(address plugin) external returns(bool);

  // Event to emit disapproved plugin.
  event PluginDisapproved(
    address indexed pluginAddress
  );
}
