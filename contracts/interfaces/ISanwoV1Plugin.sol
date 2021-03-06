// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;
pragma abicoder v2;

interface ISanwoV1Plugin {

  function execute(
    address[] calldata path,
    uint[] calldata amounts,
    address[] calldata addresses,
    string[] calldata data
  ) external payable returns(bool);

  function delegate() external returns(bool);
}
