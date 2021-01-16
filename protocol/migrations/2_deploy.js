const Implementation = artifacts.require('Implementation')

async function deployImplementation(deployer) { 
  await deployer.deploy(Implementation);
}

module.exports = function (deployer) {
  deployer.then(async () => {
    console.log('Deploying to', deployer.network)
    switch (deployer.network) {
      case 'development':
      case 'rinkeby':
      case 'ropsten':
      case 'mainnet':
      case 'mainnet-fork':
        await deployImplementation(deployer);
        break
      default:
        throw 'Unsupported network'
    }
  })
}