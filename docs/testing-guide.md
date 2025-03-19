# Testing Guide with Foundry

This document outlines the testing strategy for the NFT and claim contracts using Foundry.

## Test Environment Setup

### Prerequisites

- [Foundry](https://getfoundry.sh/) installed
- Project initialized with Forge

### Project Structure

```javascript
const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("Contract Tests", function () {
  // Test variables
  let owner, operator, user1, user2;
  let nftContract, claimContract;

  beforeEach(async function () {
    // Get signers
    [owner, operator, user1, user2] = await ethers.getSigners();

    // Deploy contracts for each test
    // ...
  });

  // Tests will go here
});
```

## NFT Contract Tests

1. Basic deployment tests
2. Single mint functionality
3. Batch mint functionality
4. Access control (only owner can mint)
5. URI management

## Claim Contract Tests

1. Basic deployment and initialization
2. Adding/removing allowed tokens
3. Signature verification
4. Claim functionality with valid signatures
5. Rejection of invalid signatures
6. Nonce management (preventing replay)
7. Pausability
8. Emergency withdrawal functionality

## Upgrade Tests

1. Successful upgrade
2. State persistence after upgrade
3. New functionality in upgraded version
4. Authorization checks for upgrades

## Test Commands

```bash
# Run all tests
npx hardhat test

# Run specific test file
npx hardhat test test/OwnerMintableNFT.test.js

# Run with gas reporting
REPORT_GAS=true npx hardhat test

# Run with specific network
npx hardhat test --network rinkeby
```
