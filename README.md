# Token Waifu EVM Contracts

This repository contains the Ethereum Virtual Machine (EVM) smart contracts for the Token Waifu game ecosystem. The contracts are built with Solidity and follow modern security best practices.

## Project Overview

Token Waifu is a GameFi project that utilizes blockchain technology to provide secure, transparent gameplay with digital assets. These smart contracts form the foundation of the on-chain elements of the game.

## Project Structure

The repository is organized into the following main directories:

- `contracts/`: Contains all Solidity smart contracts
- `scripts/`: Deployment and utility scripts
- `test/`: Comprehensive test suite
- `docs/`: Documentation for various aspects of the project

For more details, see [Project Structure](./docs/project-structure.md).

## Contract Overview

The Token Waifu ecosystem consists of several key contracts:

- **Token Contracts**: ERC721 implementations for non-fungible tokens
- **Game Logic Contracts**: Core gameplay mechanics

See the [Contract Overview](./docs/contract-overview.md) for more information about each contract's purpose and functionality.

## Upgrade Architecture

This project implements upgradeable smart contracts using the OpenZeppelin Upgrades Plugins and the transparent proxy pattern. This allows for future improvements while preserving on-chain state and assets.

For more information, refer to the [Upgrade Architecture](./docs/upgrade-architecture.md) document.

## Development and Testing

### Prerequisites

- Node.js (v14+)
- npm or yarn
- Hardhat

### Installation

```bash
# Clone the repository
git clone <repository-url>

# Navigate to the project directory
cd token-waifu-evm

# Install dependencies
npm install
# or
yarn install
```

### Running Tests

The project includes a comprehensive testing suite. Follow the [Testing Guide](./docs/testing-guide.md) for detailed instructions on running tests and ensuring code quality.

```bash
forge test
```

## Deployment

For detailed deployment instructions, including environment setup, network configuration, and verification steps, see the [Deployment Guide](./docs/deployment-guide.md).

## Signature Generation

The project uses EIP-712 typed signatures for various operations. For information on how signatures are generated and verified within the system, see the [Signature Generation](./docs/signature-generation.md) guide.

## Security

These contracts follow security best practices including:
- Checks-Effects-Interactions pattern
- Comprehensive access control
- Thorough testing

## License

[MIT/Apache-2.0/GPL-3.0] (Replace with actual license)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
