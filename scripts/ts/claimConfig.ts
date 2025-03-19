import { ethers } from 'ethers';
import { config } from './config';

async function main() {
  console.log(config);
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
  const owner = await waifuClaim.owner();
  console.log(`Owner:`, owner);
  const operator = await waifuClaim.operator();
  console.log(`Operator:`, operator);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
