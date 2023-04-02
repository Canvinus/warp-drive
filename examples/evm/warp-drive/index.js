'use strict';

const {
    utils: { deployContract },
} = require('@axelar-network/axelar-local-dev');

const WarpDrive = rootRequire('./artifacts/examples/evm/warp-drive/WarpDrive.sol/WarpDrive.json'); //og

async function deploy(chain, wallet) {
    console.log(`Deploying WarpDrive for ${chain.name}.`);
    //return ['Binance', 'Avalanche', 'Ethereum', 'Polygon'];
    //return ['Binance']; //97
    //return ['Avalanche']; //43114
    //return ['Ethereum']; //5
    //return ['Polygon']; //80001
    chain.contract = await deployContract(wallet, WarpDrive, [chain.gateway, chain.gasService, chain.name.toString(), 80001]);
    chain.wallet = wallet;
    console.log(`Deployed WarpDrive for ${chain.name} at ${chain.contract.address}.`);
}

async function execute(chains, wallet, options) {
    const args = options.args || [];
    const { source, destination, calculateBridgeFee } = options;
    const message = args[2] || `Hello ${destination.name} from ${source.name}, it is ${new Date().toLocaleTimeString()}.`;

    async function logValue() {
        console.log('Source chain is:', source.name);
        console.log(` URL of token 0 is "${await source.contract.tokenURI(0)}"`);
        console.log(` NFT connection to ${await source.contract.remoteChain()} ${await source.contract.remoteAddress()} `);
        console.log('Destination chain:', destination.name);
        console.log(` URL of token 0 is "${await destination.contract.tokenURI(0)}"`);
        console.log(` NFT connection to ${await destination.contract.remoteChain()} ${await destination.contract.remoteAddress()} `);
        console.log('-');
    }

    console.log('--- Initially ---');
    await logValue();

    const fee = await calculateBridgeFee(source, destination);

    const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
    const tx = await source.contract.connectNFTs(destination.name, destination.contract.address, { value: fee });
    await tx.wait();
    const txMint = await source.contract.safeWarp();
    console.log(` NFT SAFEWARP MINTED ${await source.contract.tokenURI(1)}`);
    await tx.wait();

    console.log('Remote connection created successfully!');

    const newURI = 'kek'; //changed
    let tx2 = await source.contract.update(0, {
        value: fee,
    });
    await tx2.wait();
    while ((await destination.contract.tokenURI(0)) !== (await source.contract.tokenURI(0))) {
        await sleep(1000);
    }

    console.log('Shared NFT Updates successful!');
    await logValue();

    console.log('--- After ---');
    await logValue();
}

module.exports = {
    deploy,
    execute,
};
