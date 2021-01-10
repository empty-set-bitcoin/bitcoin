require('dotenv').config();
const PrivateKeyProvider = require('truffle-privatekey-provider');
const HDWalletProvider = require("@truffle/hdwallet-provider");
const privateKey = process.env.ESB_PRIVATE_KEY;
const infuraId = process.env.ESB_INFURA_ID;
const etherscanKey = process.env.ESB_ETHERSCAN_KEY;
const alchemyId = process.env.ESB_ALCHEMY_ID;
const mnemonic = process.env.ESB_MNEMONIC;

module.exports = {

  networks: {
    
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
      skipDryRun: true,
      // gas: 8000000,
    },

    //Another network with more advanced options...
    mainnet: {
      networkCheckTimeout: 10000000,
      provider: () =>
        new HDWalletProvider({
          mnemonic: {
            phrase: mnemonic
          },
          providerOrUrl: 'https://eth-mainnet.alchemyapi.io/v2/' + alchemyId,
        }),
      network_id: 1,          // Mainnet's id
      gas: 5500000,           // Gas sent with each transaction (default: ~6700000)
      gasPrice: 51000000000,  // 20 gwei (in wei) (default: 100 gwei)
      timeoutBlocks: 1440,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true
    },

    ropsten: {
      networkCheckTimeout: 10000000,
      provider: () => new PrivateKeyProvider(privateKey, 'https://eth-ropsten.alchemyapi.io/v2/' + alchemyId),
      network_id: 3,       // Ropsten's id
      gas: 5500000,        // Ropsten has a lower block limit than mainnet
      // timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },

    rinkeby: {
      provider: () => new PrivateKeyProvider(privateKey, 'https://rinkeby.infura.io/v3/' + infuraId),
      network_id: 4,       // rinkeby's id
      gas: 5500000,        // rinkeby has a lower block limit than mainnet
      confirmations: 2,    // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },

  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    enableTimeouts: false,
    before_timeout: 120000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.5.17",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
      //  evmVersion: "byzantium"
      // }
    }
  },

  plugins: [
    'truffle-plugin-verify'
  ],

  api_keys: {
    etherscan: etherscanKey
  }
}
