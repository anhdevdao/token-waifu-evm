import { generatePrivateKey, privateKeyToAccount } from 'viem/accounts'

// Generate a random private key
const privateKey = generatePrivateKey()
console.log('Private Key:', privateKey)

// Create an account from the private key
const account = privateKeyToAccount(privateKey)
console.log('Address:', account.address)
console.log('Public Key:', account.publicKey)
