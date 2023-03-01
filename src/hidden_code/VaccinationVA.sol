// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./VaccinationCA.sol";

contract VaccinationVA {
  function verifyVaccination(
    address _ca,
    bytes32 hash,
    address _address,
    string memory _name,
    string memory _id
  ) public view returns (bool) {
    VaccinationCA ca = VaccinationCA(_ca);
    bytes32 checkCAHash = ca.getCredentials(_address);
    bytes32 checkVAHash = keccak256(abi.encodePacked(_address, _name, _id));
    if (hash == checkCAHash && hash == checkVAHash) {
      return true;
    }
    return false;
  }
}
