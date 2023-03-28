// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";
import "../interfaces/IRegisterableNFT.sol";

/**
 * @title Registerable NFT
 */

contract RegisterableNFT is IRegisterableNFT, ERC721A {
  address public immutable nonopoly;
  uint256 public immutable MAX_SUPPLY;

  mapping(uint256 => bool) private registered;

  uint256 public walletLimit;

  modifier onlyNonopoly() {
    require(msg.sender == nonopoly, "RegisteralbleNFT: invalid game contract");
    _;
  }

  /**
   * @param _name NFT Name
   * @param _symbol NFT Symbol
   * @param limit Wallet Limit
   * @param maxSupply Maximum # of NFTs
   * @param _nonopoly Nonopoly game contract
   */
  constructor(
    string memory _name,
    string memory _symbol,
    uint256 limit,
    uint256 maxSupply,
    address _nonopoly
  ) payable ERC721A(_name, _symbol) {
    walletLimit = limit;
    MAX_SUPPLY = maxSupply;
    nonopoly = _nonopoly;
  }

  /**
   * @dev register NFT to game contract(called by game contract)
   * @param id yield id
   */
  function register(uint256 id) external onlyNonopoly {
    registered[id] = true;
  }

  /**
   * @dev remove NFT to game contract(called by game contract)
   * @param id yield id
   */
  function remove(uint256 id) external onlyNonopoly {
    registered[id] = false;
  }

  /**
   * @dev prevent transfer function about registered nft
   */
  function _beforeTokenTransfers(
    address from,
    address to,
    uint256 startTokenId,
    uint256 quantity
  ) internal virtual override {
    for (uint256 i = 0; i < quantity; i++) {
      require(
        registered[startTokenId + i] == false,
        "RegisterableNFT: can't transfer registered token"
      );
    }
  }
}
