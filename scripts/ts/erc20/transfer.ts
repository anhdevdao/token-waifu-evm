import { ethers } from 'ethers';
import { config, getSigner } from '../config';
const erc20Abi = require('../../../out/ERC20.sol/Token.json'); // We'll define this below


async function transferTokens(
  to: `0x${string}`,
  amount: bigint
) {
  try {
    const signer = getSigner();
    console.log(`Transferring ${amount} to ${to}`);

    // Create contract instance
    const token = new ethers.Contract(
      config.twai,
      erc20Abi.abi,
      signer
    );

    // Send transfer transaction
    const tx = await token.transfer(to, amount);

    console.log('Transaction hash:', tx.hash);
    await tx.wait();
    console.log('Transaction confirmed!');

  } catch (error) {
    console.error('Error:', error);
  }
}

// Example usage
const recipientAddress = '0x9d293fFc6C1aCfF3AF5a931d8eCD57cB55D4B44B' as `0x${string}`;
const amount = BigInt(99999000000000000000000); // 1 token with 18 decimals

transferTokens(recipientAddress, amount);
