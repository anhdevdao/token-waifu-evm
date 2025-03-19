// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract WaifuCollection is ERC721Enumerable, Ownable {
    using Strings for uint256;

    string private _baseTokenURI;
    uint256 private _tokenIdCounter;

    event TokensMinted(
        address indexed to,
        uint256 startTokenId,
        uint256 endTokenId
    );

    constructor(
        string memory baseURI,
        address initialOwner
    ) ERC721("WaifuCollection", "WAIFU") Ownable(initialOwner) {
        _baseTokenURI = baseURI;
    }

    function mint(address to) external onlyOwner returns (uint256) {
        uint256 tokenId = _tokenIdCounter;
        _safeMint(to, tokenId);
        _tokenIdCounter++;

        emit TokensMinted(to, tokenId, tokenId);
        return tokenId;
    }

    function batchMint(
        address to,
        uint256 amount
    ) external onlyOwner returns (uint256) {
        require(amount > 0, "Amount must be greater than 0");

        uint256 startTokenId = _tokenIdCounter;

        for (uint256 i = 0; i < amount; i++) {
            _safeMint(to, _tokenIdCounter);
            _tokenIdCounter++;
        }

        emit TokensMinted(to, startTokenId, _tokenIdCounter - 1);
        return startTokenId;
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    function getCurrentTokenId() external view returns (uint256) {
        return _tokenIdCounter;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireOwned(tokenId);

        return
            bytes(_baseTokenURI).length > 0
                ? string(abi.encodePacked(_baseTokenURI, tokenId.toString()))
                : "";
    }
}
