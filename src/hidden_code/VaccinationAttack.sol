// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract VaccinationAttack {
  address public victimAddress;
  string public victimName;
  string public victimId;
  mapping(address => bytes32) public credentials;

  event Message(string message);

  function recordVaccination(
    address _address,
    string memory _name,
    string memory _id
  ) public returns (bytes32) {
    victimAddress = _address;
    victimName = _name;
    victimId = _id;
    credentials[_address] = keccak256(abi.encodePacked(_address, _name, _id));
    emit Message("Malicious contract executed!");
    return credentials[_address];
  }

  function getCredentials(address _address) public view returns (bytes32) {
    return credentials[_address];
  }
}
