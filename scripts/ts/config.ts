import { ethers } from 'ethers';
import dotenv from 'dotenv';
dotenv.config();

export const config = {
  // Contract addresses (to be filled after deployment)
  waifuCollection: process.env.WAIFU_COLLECTION_ADDRESS || '',
  waifuClaim: process.env.WAIFU_CLAIM_PROXY || '',
  twai: process.env.TWAI_ADDRESS || '',

  // Network settings
  rpcUrl: process.env.RPC_URL || 'http://localhost:8545',
  chainId: parseInt(process.env.CHAIN_ID || '31337'),

  // Account settings
  privateKey: process.env.PRIVATE_KEY || '',
  operatorPrivateKey: process.env.OPERATOR_PRIVATE_KEY || '',

  // Contract settings
  baseURI: process.env.BASE_URI || 'https://api.waifucollection.com/metadata/',
};

export const getProvider = () => {
  return new ethers.JsonRpcProvider(config.rpcUrl);
};

export const getSigner = () => {
  const provider = getProvider();
  return new ethers.Wallet(config.privateKey, provider);
};

export const getOperatorSigner = () => {
  const provider = getProvider();
  return new ethers.Wallet(config.operatorPrivateKey, provider);
};
