# Deployment Guide

This guide outlines the steps to deploy and configure both the NFT and ERC20 claim contracts.

## Prerequisites

- Hardhat or Truffle development environment
- Ethereum wallet with sufficient ETH for gas fees
- OpenZeppelin Contracts library installed

## Deploying the NFT Contract

1. Deploy the `WaifuCollection` contract:

```javascript
const WaifuCollection = await ethers.getContractFactory("WaifuCollection");
const nft = await WaifuCollection.deploy(
  "My Collection",  // Name
  "MYCOL",          // Symbol
  "https://api.mycollection.io/metadata/", // Base URI
  ownerAddress      // Initial owner address
);
await nft.deployed();
console.log("NFT contract deployed to:", nft.address);
```

## Deploying the Upgradeable ERC20 Claim Contract

1. Deploy the implementation contract:

```javascript
const WaifuClaim = await ethers.getContractFactory("WaifuClaim");
const implementation = await WaifuClaim.deploy();
await implementation.deployed();
console.log("Implementation deployed to:", implementation.address);
```

2. Deploy the proxy contract and initialize:

```javascript
const WaifuClaimProxy = await ethers.getContractFactory("ERC1967Proxy");
const initializeData = WaifuClaim.interface.encodeFunctionData(
  "initialize", [ownerAddress, operatorAddress]
);

const proxy = await WaifuClaimProxy.deploy(
  implementation.address,
  initializeData
);
await proxy.deployed();
console.log("Proxy deployed to:", proxy.address);

// Create a contract instance at the proxy address
const claimContract = WaifuClaim.attach(proxy.address);
```

3. Configure the claim contract:

```javascript
// Add allowed tokens
for (const token of allowedTokens) {
  await claimContract.addAllowedToken(token);
  console.log(`Added ${token} to allowed tokens`);
}
```

## Upgrading the Claim Contract

1. Deploy the new implementation:

```javascript
const WaifuClaimV2 = await ethers.getContractFactory("WaifuClaimV2");
const newImplementation = await WaifuClaimV2.deploy();
await newImplementation.deployed();
console.log("New implementation deployed to:", newImplementation.address);
```

2. Upgrade the proxy:

```javascript
// Get instance of existing proxy
const claimContract = await ethers.getContractAt("WaifuClaim", proxyAddress);

// Perform the upgrade
await claimContract.upgradeTo(newImplementation.address);
console.log("Contract upgraded successfully");
```
