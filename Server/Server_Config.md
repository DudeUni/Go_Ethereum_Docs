**This serves as a memo about what is exactly done to set up the Geth server.**
=======================================================
**Date:** June 17th 2022

Most of the codes are running on the following machine:
>  
> system OS: 
>> NAME="Ubuntu"                                     
>> VERSION="16.04.6 LTS (Xenial Xerus)"              
>> ID=ubuntu                                         
>> ID_LIKE=debian                                    
>> PRETTY_NAME="Ubuntu 16.04.6 LTS"                  
>> VERSION_ID="16.04" 

The initial steps come from this [tutorial](https://medium.com/blockchainbistro/set-up-a-private-ethereum-blockchain-and-deploy-your-first-solidity-smart-contract-on-the-caa8334c343d). **Note** some of the commands/parameters are different due to the fact that it is a 4-year-old post.

# 1. Geth set up


Geth is short for Go-Ethereum, which is the official go realization of Ethereum Blockchain.

### **step 1, installation **
First, make sure the `npm` and `go` are installed by checking:

    npm -v
    go version

Then install Geth:

    go install github.com/ethereum/go-ethereum/cmd/geth


More information could be found in [the official site](https://geth.ethereum.org/docs/install-and-build/installing-geth#most-linux-systems-and-macos).

### **step 2, the genesis block**

Make a new directory (`Geth_Blockchain` here), and create `genesis.json` within:

    mkdir Geth_Blockchain
    cd Geth_Blockchain
    vim genesis.json

and put the following content:

    {
        "config": {
        "chainId": 143,
        "homesteadBlock": 0,
        "eip155Block": 0,
        "eip150Block": 0,
        "eip158Block": 0,
        "byzantiumBlock": 0,
        "constantinopleBlock": 0
        },
        "alloc": {},
        "difficulty" : "0x20000",
        "gasLimit"   : "0x8880000"
    }

### **step 3, running Blockchain**

Make a data directory `Blockchain` under the main directory. And then initialize the blockchain, together with `genesis.json`:

    mkdir Blockchain
    geth --datadir  Blockchain init genesis.json

Then finally, run the blockchain:

    geth --port 3001 --networkid 58343 --nodiscover --datadir=./Blockchain --maxpeers=0  --http --http.port 8543 --http.addr 127.0.0.1 --http.corsdomain "*" --http.api "eth,net,web3,personal,miner" --allow-insecure-unlock

# 2. Geth Javascript Console

Open another terminal while keep the blockchain running at the other:

    geth attach http://127.0.0.1:8543

Then blockchain can now be managed by this console. The following commands are one of the examples.

    personal.newAccount('seed')
    personal.unlockAccount(web3.eth.coinbase, "seed", 15000)
    miner.start()
    miner.stop()
    web3.fromWei(eth.getBalance(eth.coinbase), "ether")

# 3. Write and deploy a smart contract using `Truffle`

### **Step 1**

First install `Truffle`, and `solidity` the coding language of smart contract.

    npm install -g truffle
    npm install -g solc

Note that after installing `truffle`, it can be found that the command `truffle` is a mere soft link to such file: `cli.bundled.js`, whose permission mode has to be changed.

    $ ls /usr/local/bin/truffle -l
    lrwxrwxrwx 1 root root 48 Jun 14 22:52 /usr/local/bin/truffle -> ../lib/node_modules/truffle/build/cli.bundled.js

    $ ls /usr/local/lib/node_modules/truffle/build/cli.bundled.js -l
    -rwxr-xr-- 1 root root 17197 Jun 14 23:24 /usr/local/lib/node_modules/truffle/build/cli.bundled.js

    $ sudo chmod -a+x cli.bundled.js

Then we go back to the main folder of the blockchain and initiate `truffle`:

    mkdir truffle
    cd truffle
    truffle init

The truffle directory now reads:

    $ ls
    build  contracts  migrations  node_modules  package.json  package-lock.json  test  truffle-config.js

Go to the `contract` folder, and create the following contract: `Hello.sol`.

    pragma solidity ^0.5.16;
    contract Hello {
        string public message;
        constructor public {
        message = "Hello, World : This is a Solidity Smart Contract on the Private Ethereum Blockchain ";
        }
    }

Then we go back to the `migrant` folder and create `2_deploy_contracts.js`:

    var Hello = artifacts.require("./Hello.sol");
        module.exports = function(deployer) {
        deployer.deploy(Hello);
    };

At the last step we update `truffle-config.js`:

    module.exports = {
        rpc: {
        host:"localhost",
         port:8543
        },
        networks: {
            development: {
                host: "localhost", 
                port: 8543, 
                network_id: "*",
                from: "0xd786e61e7541205c5aed08d04b34bae00d44cab1", 
                gas: 20000000
            }
        },
    };

The `from:` has to match the account address, this can be checked in the `geth` javascript console. Then we can deploy the contract by:

    truffle compile
    truffle migrate

Note during these steps the miner has to be on by calling in the `geth` console

    miner.start()

### **Step 2, call the contract!!**

Finaly we can call the smart contract by using truffle console:

    truffle console

and input the following command:

    var dApp
    Hello.deployed().then(function(instance) { dApp = instance; })
    dApp.message.call()

All the deployed contract can be viewed by:

    truffle networks
