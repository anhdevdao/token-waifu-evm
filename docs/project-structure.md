# Project Structure

This document outlines the structure of the smart contract project, including contracts, tests, and deployment scripts.

## Contracts

- `WaifuCollection.sol`: ERC721 implementation with owner-only minting capabilities
- `WaifuClaim.sol`: Upgradeable contract for claiming ERC20 tokens with operator signatures

## Tests

- `WaifuCollection.test.js`: Tests for the NFT contract functionality
- `WaifuClaim.test.js`: Tests for the claim contract functionality
- `Upgrade.test.js`: Tests for the upgrade functionality of the claim contract

## Scripts

- `deploy_nft.js`: Script to deploy the NFT contract
- `deploy_claim.js`: Script to deploy the claim contract and its proxy
- `upgrade_claim.js`: Script to upgrade the claim contract implementation
