// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/**
 * @dev Showcase re-entrancy vulnerability.
 */
contract ReentranceBank {
  mapping(address => uint256) public balances;

  function deposit() public payable {
    balances[msg.sender] = balances[msg.sender] + msg.value;
  }

  function balanceOf(address _who) public view returns (uint256) {
    return balances[_who];
  }

  function withdraw(uint256 _amount) public {
    if (balances[msg.sender] >= _amount) {
      (bool result, ) = msg.sender.call{ value: _amount }("");
      require(result, "withdrawal false");
      unchecked {
        balances[msg.sender] -= _amount; // unchecked to prevent underflow errors
      }
    }
  }

  receive() external payable {}
}
