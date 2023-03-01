// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract VaccinationCA {
  mapping(address => bytes32) public credentials;

  function recordVaccination(
    address _address,
    string memory _name,
    string memory _id
  ) public returns (bytes32) {
    credentials[_address] = keccak256(abi.encodePacked(_address, _name, _id));
    return credentials[_address];
  }

  function getCredentials(address _address) public view returns (bytes32) {
    return credentials[_address];
  }
}
