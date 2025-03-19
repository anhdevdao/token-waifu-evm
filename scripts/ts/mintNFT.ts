import { ethers } from 'ethers';
import { config, getSigner } from './config';

async function main() {
  const signer = getSigner();

  // Get contract ABI from artifacts
  const waifuCollectionArtifact = require('../../out/WaifuCollection.sol/WaifuCollection.json');

  // Create contract instance
  const waifuCollection = new ethers.Contract(
    config.waifuCollection,
    waifuCollectionArtifact.abi,
    signer
  );

  // Parameters for minting
  const toAddress = process.argv[2];
  const amount = parseInt(process.argv[3] || '1');

  if (!toAddress) {
    throw new Error('Please provide a recipient address as first argument');
  }

  console.log(`Minting ${amount} NFT(s) to ${toAddress}...`);

  try {
    // Use batchMint for multiple NFTs, or mint for single NFT
    const tx = amount > 1
      ? await waifuCollection.batchMint(toAddress, amount)
      : await waifuCollection.mint(toAddress);

    console.log('Transaction hash:', tx.hash);
    await tx.wait();

    console.log('Successfully minted NFT(s)!');
  } catch (error) {
    console.error('Error minting NFT:', error);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
