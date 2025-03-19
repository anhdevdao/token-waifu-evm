import { ethers } from 'ethers';
import { config, getSigner, getOperatorSigner } from './config';

// Domain data for EIP-712 signature
const domainData = {
  name: 'WaifuClaim',
  version: '1',
  chainId: config.chainId,
  verifyingContract: config.waifuClaim,
};

// Types for EIP-712 signature
const types = {
  Claim: [
    { name: 'user', type: 'address' },
    { name: 'token', type: 'address' },
    { name: 'amount', type: 'uint256' },
    { name: 'nonce', type: 'uint256' },
  ],
};

async function signClaim(user: string, token: string, amount: string, nonce: number) {
  const operatorSigner = getOperatorSigner();

  const value = {
    user,
    token,
    amount,
    nonce,
  };

  const signature = await operatorSigner.signTypedData(domainData, types, value);
  return signature;
}

async function claim(token: string, amount: string, nonce: number, signature: string) {
  const signer = getSigner();

  // Get contract ABI from artifacts
  const waifuClaimArtifact = require('../../out/WaifuClaim.sol/WaifuClaim.json');

  // Create contract instance
  const waifuClaim = new ethers.Contract(
    config.waifuClaim,
    waifuClaimArtifact.abi,
    signer
  );

  const tx = await waifuClaim.claimTokens(token, amount, nonce, signature);
  console.log('Transaction hash:', tx.hash);
  await tx.wait();
  console.log('Claim successful!');
}

async function getClaimData(userAddress: string) {
  const provider = new ethers.JsonRpcProvider(config.rpcUrl);

  // Get contract ABI from artifacts
  const waifuClaimArtifact = require('../../out/WaifuClaim.sol/WaifuClaim.json');

  // Create contract instance
  const waifuClaim = new ethers.Contract(
    config.waifuClaim,
    waifuClaimArtifact.abi,
    provider
  );

  // Get nonce status
  const nonce = process.argv[4] || '0';
  const isNonceUsed = await waifuClaim.isNonceUsed(userAddress, nonce);
  console.log(`Nonce ${nonce} used:`, isNonceUsed);

  return { isNonceUsed };
}

async function main() {
  const command = process.argv[2];

  if (!command) {
    throw new Error('Please provide a command: sign, claim, getData');
  }

  try {
    switch (command) {
      case 'sign': {
        const user = process.argv[3];
        const token = process.argv[4];
        const amount = process.argv[5];
        const nonce = parseInt(process.argv[6] || '0');

        if (!user || !token || !amount) {
          throw new Error('User address, token address, and amount required');
        }

        console.log('Signing claim data...');
        const signature = await signClaim(user, token, amount, nonce);
        console.log('Signature:', signature);
        break;
      }

      case 'claim': {
        const token = process.argv[3];
        const amount = process.argv[4];
        const nonce = parseInt(process.argv[5] || '0');
        const signature = process.argv[6];

        if (!token || !amount || !signature) {
          throw new Error('Token address, amount, and signature required');
        }

        console.log('Claiming tokens...');
        await claim(token, amount, nonce, signature);
        break;
      }

      case 'getData': {
        const userAddress = process.argv[3];
        if (!userAddress) {
          throw new Error('User address required');
        }

        console.log('Getting claim data...');
        await getClaimData(userAddress);
        break;
      }

      default:
        throw new Error('Invalid command');
    }
  } catch (error) {
    console.error('Error:', error);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
