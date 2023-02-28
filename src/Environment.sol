// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "./BaseFactory.sol";

contract Environment is Ownable {
  mapping(address => bool) registeredFactories;

  // Only registered levels will be allowed to generate and validate level instances.
  function registerFactory(BaseFactory _factory) public onlyOwner {
    registeredFactories[address(_factory)] = true;
  }

  struct EmittedInstanceData {
    address interactor;
    BaseFactory factory;
    bool completed;
  }

  mapping(address => EmittedInstanceData) emittedInstances;

  event InstaceCreatedLog(address indexed interactor, address instance);
  event HackCompletedLog(address indexed interactor, BaseFactory level);

  function createInstance(BaseFactory _factory) public payable returns (address) {
    require(registeredFactories[address(_factory)]);

    address instance = _factory.createInstance{ value: msg.value }(msg.sender);

    emittedInstances[instance] = EmittedInstanceData(msg.sender, _factory, false);
    emit InstaceCreatedLog(msg.sender, instance);

    return instance;
  }

  function validateInstance(address payable _instance) public returns (bool) {
    EmittedInstanceData storage data = emittedInstances[_instance];

    require(data.interactor == msg.sender); // instance was emitted for this interactor
    require(data.completed == false); // avoid double submission

    if (data.factory.validateInstance(_instance, msg.sender)) {
      // Register instance as completed.
      data.completed = true;
      emit HackCompletedLog(msg.sender, data.factory);
      return true;
    }

    return false;
  }
}
