const Deployer1 = artifacts.require('Deployer1')
const Deployer2 = artifacts.require('Deployer2')
const Deployer3 = artifacts.require('Deployer3')
const Implementation = artifacts.require('Implementation')
const Root = artifacts.require('Root')

const TestnetWBTC = artifacts.require('TestnetWBTC')

// async function deployTestnetWBTC(deployer) {
//   await deployer.deploy(TestnetWBTC)
// }

async function deployTestnet(deployer) {
  const d1 = await deployer.deploy(Deployer1) // Deployer 1 gets deployed and stored at d1
  const root = await deployer.deploy(Root, d1.address) // Root gets deployed with Deployer 1 address passed in
  const rootAsD1 = await Deployer1.at(root.address) // Deployer 1 gets loaded with Root address

  const d2 = await deployer.deploy(Deployer2) // Deployer 2 gets deployed and stored at d2
  await rootAsD1.implement(d2.address) // Root gets a function called to add Deployer 2 address
  const rootAsD2 = await Deployer2.at(root.address) // Deployer 2 gets loaded with Root address

  const d3 = await deployer.deploy(Deployer3) // Deployer 3 gets deployed and stored at d3
  await rootAsD2.implement(d3.address) // Root gets 
  const rootAsD3 = await Deployer3.at(root.address)

  const implementation = await deployer.deploy(Implementation)
  await rootAsD3.implement(implementation.address)
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
        await deployTestnet(deployer)
        // await deployTestnetWBTC(deployer)
        break
      default:
        throw 'Unsupported network'
    }
  })
}