// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * @dev Showcase memory interaction, storage variable packings and storage data visibility
 */
contract Locker {
  bool public locked = true; // 1 bytes
  bytes16 private secretKey; // 16 bytes

  constructor(bytes16 _secretKey) {
    secretKey = _secretKey;
  }

  function unlock(bytes16 _key) public {
    require(_key == bytes16(secretKey));
    locked = false;
  }
}
