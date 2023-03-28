// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Nonopoly main token
 */
contract NERD is ERC20, Ownable {
  constructor() ERC20("NERD", "NERD") {}

  /**
   * @dev Only owner can mint token. Owner would be nonopoly manager contract
   */
  function mint(uint256 amount, address to) public onlyOwner {
    _mint(to, amount);
  }

  /**
   * @dev Only owner can burn token. Owner would be nonopoly manager contract
   */
  function burn(uint256 amount, address to) public onlyOwner {
    _burn(to, amount);
  }
}
