import { ethers } from 'ethers';
import { config, getSigner } from './config';

async function main() {
  const signer = getSigner();

  // Get contract ABI from artifacts
  const waifuClaimArtifact = require('../../out/WaifuClaim.sol/WaifuClaim.json');

  // Create contract instance
  const waifuClaim = new ethers.Contract(
    config.waifuClaim,
    waifuClaimArtifact.abi,
    signer
  );

  // Get command and parameters
  const command = process.argv[2];
  const param1 = process.argv[3];
  const param2 = process.argv[4];

  if (!command) {
    throw new Error(
      'Please provide a command: addToken, removeToken, pause, unpause, setOperator, emergencyWithdraw'
    );
  }

  try {
    let tx;

    switch (command) {
      case 'addToken':
        if (!param1) throw new Error('Token address required');
        console.log(`Adding token ${param1} to allowed tokens...`);
        tx = await waifuClaim.addAllowedToken(param1);
        break;

      case 'removeToken':
        if (!param1) throw new Error('Token address required');
        console.log(`Removing token ${param1} from allowed tokens...`);
        tx = await waifuClaim.removeAllowedToken(param1);
        break;

      case 'pause':
        console.log('Pausing contract...');
        tx = await waifuClaim.pause();
        break;

      case 'unpause':
        console.log('Unpausing contract...');
        tx = await waifuClaim.unpause();
        break;

      case 'setOperator':
        if (!param1) throw new Error('Operator address required');
        console.log(`Setting operator to ${param1}...`);
        tx = await waifuClaim.setOperator(param1);
        break;

      case 'emergencyWithdraw':
        if (!param1 || !param2) throw new Error('Token address and recipient address required');
        const amount = process.argv[5];
        if (!amount) throw new Error('Amount required');
        console.log(`Emergency withdrawing ${amount} tokens to ${param2}...`);
        tx = await waifuClaim.emergencyWithdraw(param1, param2, amount);
        break;

      default:
        throw new Error('Invalid command');
    }

    console.log('Transaction hash:', tx.hash);
    await tx.wait();
    console.log('Transaction confirmed!');
  } catch (error) {
    console.error('Error executing command:', error);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
