// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title Registerable NFT
 */

interface IRegisterableNFT {
  /**
   * @dev fires when nft registered to game contract
   */
  event Registered(uint256 id);

  /**
   * @dev fires when nft removed from game contract
   */
  event Removed(uint256 id);

  /**
   * @dev register NFT to game contract(called by game contract)
   */
  function register(uint256 id) external;

  /**
   * @dev remove NFT to game contract(called by game contract)
   */
  function remove(uint256 id) external;
}
