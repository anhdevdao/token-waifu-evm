import { ethers } from 'ethers';
import { config } from './config';

async function main() {
  console.log(config);
  const provider = new ethers.JsonRpcProvider(config.rpcUrl);

  // Get contract ABI from artifacts
  const waifuCollectionArtifact = require('../../out/WaifuCollection.sol/WaifuCollection.json');

  // Create contract instance
  const waifuCollection = new ethers.Contract(
    config.waifuCollection,
    waifuCollectionArtifact.abi,
    provider
  );

  // Get nonce status
  const owner = await waifuCollection.owner();
  console.log(`Owner:`, owner);

  return { owner };
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
