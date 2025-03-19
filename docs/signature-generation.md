# Signature Generation Guide

This guide explains how to generate valid signatures for the ERC20 claim contract.

## Signature Format

The signature is an ECDSA signature of the following parameters:
- User address (who will claim the tokens)
- Token address (which token will be claimed)
- Amount (how many tokens will be claimed)
- Nonce (unique value to prevent replay attacks)

## Backend Signature Generation (NodeJS example)

```javascript
const ethers = require('ethers');

/**
 * Generate a signature for token claiming
 * @param {string} userAddress - Address of the user claiming tokens
 * @param {string} tokenAddress - Address of the token being claimed
 * @param {string} amount - Amount of tokens to claim (as a string)
 * @param {string} nonce - Unique nonce for this claim
 * @param {string} privateKey - Operator's private key
 * @returns {string} The generated signature
 */
function generateClaimSignature(userAddress, tokenAddress, amount, nonce, privateKey) {
  const messageHash = ethers.utils.solidityKeccak256(
    ['address', 'address', 'uint256', 'uint256'],
    [userAddress, tokenAddress, amount, nonce]
  );

  const messageHashBinary = ethers.utils.arrayify(messageHash);

  // Sign the message hash
  const wallet = new ethers.Wallet(privateKey);
  const signature = wallet.signMessage(messageHashBinary);

  return signature;
}

// Usage
const signature = generateClaimSignature(
  '0x123...', // User address
  '0x456...', // Token address
  '1000000000000000000', // 1 token with 18 decimals
  '1',        // Nonce
  'abcdef...' // Operator private key
);
```

## Frontend Claim Example

```javascript
async function claimTokens(tokenAddress, amount, nonce, signature) {
  const claimContract = new ethers.Contract(
    CLAIM_CONTRACT_ADDRESS,
    CLAIM_ABI,
    signer
  );

  const tx = await claimContract.claimTokens(
    tokenAddress,
    amount,
    nonce,
    signature
  );

  await tx.wait();
  console.log('Tokens claimed successfully!');
}
```

## Security Considerations

1. **Private Key Security**: The operator's private key should be stored securely and never exposed.
2. **Nonce Management**: Use monotonically increasing or random nonces to prevent replay attacks.
3. **Backend Validation**: Validate all claim requests on your backend before generating signatures.
4. **Rate Limiting**: Implement rate limiting for signature generation to prevent abuse.
