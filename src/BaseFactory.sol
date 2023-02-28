// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

abstract contract BaseFactory is Ownable {
  function createInstance(address _interactor) public payable virtual returns (address);
  function validateInstance(address payable _instance, address _interactor) public virtual returns (bool);
}