// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./VaccinationCA.sol";
import "./VaccinationVA.sol";

contract VaccinationRecord {
  VaccinationCA ca;
  address public owner;
  bytes32 vaccinationHash;
  event Message(string message);

  constructor(address _ca) {
    ca = VaccinationCA(_ca);
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only the owner can call this function");
    _;
  }

  function registerVaccination(string memory _name, string memory _id) public onlyOwner {
    vaccinationHash = ca.recordVaccination(msg.sender, _name, _id);
    emit Message("Vaccination certification success!");
  }

  function verifyVaccination(
    address _va,
    string memory _name,
    string memory _id
  ) public view returns (bool) {
    VaccinationVA va = VaccinationVA(_va);
    bool isVaccinated = va.verifyVaccination(address(ca), vaccinationHash, msg.sender, _name, _id);
    return isVaccinated;
  }
}
