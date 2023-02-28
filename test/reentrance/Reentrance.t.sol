// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "~/reentrance/ReentranceBank.sol";
import "~/reentrance/ReentranceAttack.sol";

contract ReentranceTest is Test {
  address depositor = vm.addr(1);
  address hacker = vm.addr(2);

  function setUp() public {
    // Deal EOA address some ether
    vm.deal(depositor, 100 ether);
    vm.deal(hacker, 1 ether);
  }

  // NOTE: `forge test` thread limit is 128
  function testReentranceAttack() public {
    ReentranceBank bankContract = new ReentranceBank();
    address bankAddress = address(bankContract);

    // Depositor deposits 100 ether into the bank.
    vm.prank(depositor);
    bankContract.deposit{ value: 100 ether }();

    // Hacker exploit the smart contract.
    vm.startPrank(hacker);
    ReentranceAttack exploiterContract = new ReentranceAttack(bankAddress);
    exploiterContract.attack{ value: 0.5 ether }();
    exploiterContract.withdraw();
    vm.stopPrank();

    assertEq(bankAddress.balance, 0 ether, "Bank balance should be zero");
    assertEq(hacker.balance, 101 ether, "Hacker should drain all money in the bank");
  }
}
