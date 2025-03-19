# Contract Overview

## WaifuCollection

An ERC721 compliant NFT collection with controlled minting capabilities. Only the contract owner can mint tokens.

### Key Features

- Single token minting (`mint` function)
- Batch token minting (`batchMint` function)
- Configurable base URI for token metadata
- Full ERC721 compatibility including enumeration extension

### Access Control

- Owner-only minting functions
- Owner-only base URI configuration

## WaifuClaim (Upgradeable)

An upgradeable contract that allows users to claim ERC20 tokens with operator signatures.

### Key Features

- Signature-based claim verification
- Support for multiple ERC20 tokens
- Nonce management to prevent replay attacks
- Pausable functionality for emergency situations
- Upgradeable using UUPS pattern

### Access Control

- Owner can add/remove allowed tokens
- Owner can update the operator address
- Owner can pause/unpause the contract
- Owner can authorize contract upgrades
- Only valid operator signatures can authorize claims
