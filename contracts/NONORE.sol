// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./utils/RegisterableNFT.sol";

/**
 * @title Nonopoly Real Estate NFT
 */
contract NonopolyRealEstate is RegisterableNFT {
  /**
   * @param nonopoly Nonopoly game contract address
   */
  constructor(
    address nonopoly
  ) RegisterableNFT("Nonopoly Real Estate", "NONORE", 1, 5000, nonopoly) {}

  function _mintPlayer() external {
    _mint(msg.sender, 1);
  }
}
