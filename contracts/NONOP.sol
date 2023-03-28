// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./utils/RegisterableNFT.sol";

/**
 * @title Nonopoly City NFT
 */
contract NonopolyCity is RegisterableNFT {
  /**
   * @param nonopoly Nonopoly game contract address
   */
  constructor(address nonopoly) RegisterableNFT("Nonopoly City", "NONOC", 1, 5000, nonopoly) {}

  function _mintPlayer() external {
    _mint(msg.sender, 1);
  }
}
