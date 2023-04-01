'use strict';

const {
    getDefaultProvider,
    constants: { AddressZero },
    utils: { defaultAbiCoder },
    BigNumber,
} = require('ethers');
const {
    utils: { deployContract },
} = require('@axelar-network/axelar-local-dev');

const SendAckReceiver = rootRequire(
    './artifacts/examples/evm/send-ack/SendAckReceiverImplementation.sol/SendAckReceiverImplementation.json',
);
const SendAckSender = rootRequire('./artifacts/examples/evm/send-ack/SendAckSender.sol/SendAckSender.json');

async function deploy(chain, wallet) {
    chain.provider = getDefaultProvider(chain.rpc);
    chain.wallet = wallet.connect(chain.provider);

    console.log(`Deploying SendAckSender for ${chain.name}.`);
    chain.contract = await deployContract(wallet, SendAckSender, [chain.gateway, chain.gasService, chain.name]);
    console.log(`Deployed SendAckSender for ${chain.name} at ${chain.contract.address}.`);

    console.log(`Deploying SendAckReceiverImplementation for ${chain.name}.`);
    chain.receiver = await deployContract(wallet, SendAckReceiver, [chain.gateway]);
    console.log(`Deployed SendAckReceiverImplementation for ${chain.name} at ${chain.receiver.address}.`);
}

async function execute(chains, wallet, options) {
    const { source, destination, calculateBridgeFee, args } = options;
    const message = args[2] || `Received message that written at ${new Date().toLocaleTimeString()}.`;
    const payload = defaultAbiCoder.encode(
        ['address', 'uint256', 'string', 'string', 'string', 'address', 'string'],
        ['0xf65829b83188972c7d07db6478903c6e9fe672b4', '0', 'string', 'bayc', 'eth', '0xf65829b83188972c7d07db6478903c6e9fe672b4', 'URI'],
    );

    async function print() {
        const length = await destination.receiver.messagesLength();
        console.log(
            `SendAckReceiverImplementation at ${destination.name} has ${length} messages and the last one is "${
                length > 0 ? await destination.receiver.messages(length - 1) : ''
            }".`,
        );
    }

    const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

    console.log('--- Initially ---');
    await print();

    const feeRemote = await calculateBridgeFee(source, destination);
    const feeSource = await calculateBridgeFee(source, source);
    console.log(feeRemote);
    console.log(feeSource);

    const tx = await source.contract
        .sendContractCall(destination.name, destination.receiver.address, payload, feeRemote, {
            value: BigNumber.from(feeRemote).add(feeSource),
        })
        .then((tx) => tx.wait());
    console.log(destination.name);
    console.log(destination.receiver.address);
    console.log(payload);
    console.log(feeRemote);
    const event = tx.events.find((event) => event.event === 'ContractCallSent');
    const nonce = event.args.nonce;

    while (!(await source.contract.executed(nonce))) {
        await sleep(2000);
    }

    console.log('--- After ---');
    await print();
}

module.exports = {
    deploy,
    execute,
};
