# Getting started with EOS Smart Contracts
There are two options that I'll go over for getting nodeos up and running.
1. Docker (Recommended)
2. Local Automated Build

## Install Docker
[Click here to install Docker](https://docs.docker.com/install/)

## EOSIO Dev Docker image
Run the following commands:
- `docker pull eosio/eos-dev`
- `sudo docker run --rm --name eosio -d -p 8888:8888 -p 9876:9876 -v /tmp/work:/work -v /tmp/eosio:/mnt/dev/data eosio/eos-dev /bin/bash -c "nodeos -e -p eosio --plugin eosio::wallet_api_plugin --plugin eosio::wallet_plugin --plugin eosio::producer_plugin --plugin eosio::history_plugin --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin --plugin eosio::http_plugin -d /mnt/dev/data --http-server-address=0.0.0.0:8888 --access-control-allow-origin=* --contracts-console"`
- To follow the blocks being produced run the following: `sudo docker logs -f eosio`

You can now visit `http://localhost:8888/v1/chain/get_info` and should JSON data describing the chain.

## NODEOS

System requirements for building a local copy:
1. Amazon 2017.09 and higher.
2. Centos 7.
3. Fedora 25 and higher (Fedora 27 recommended).
4. Mint 18.
5. Ubuntu 16.04 (Ubuntu 16.10 recommended).
6. MacOS Darwin 10.12 and higher (MacOS 10.13.x recommended).

- `git clone https://github.com/EOSIO/eos --recursive`
- `cd eos`
- `./eosio_build.sh`
- `cd build`
- `sudo make install`


## CLEOS
#### Command-line tool for manging wallets and interacting with the blockchain
- `alias cleos='docker exec eosio /opt/eosio/bin/cleos --wallet-url http://localhost:8888'`
- `cleos --help` to get a list of commands.
- [Guide about accounts and wallets on EOSIO](https://developers.eos.io/eosio-nodeos/docs/learn-about-wallets-keys-and-accounts-with-cleos)

## Wallets and Accounts
Create a wallet and save your master password:
`cleos wallet create`

Create another wallet with a name and save your master password:
`cleos wallet create -n devcoffee`

List all your wallets
`cleos wallet list`

Lock a specific wallet
`cleos wallet lock -n devcoffee`

Unlock a specific wallet
`cleos wallet unlock -n devcoffee --password [YOUR_MASTER_PASSWORD]`

Create a private and public key (Make sure to save the keys somewhere secure)
`cleos create key`

Import the private key into your wallet
`cleos wallet import -n devcoffee [YOUR_MASTER_PASSWORD]`

#### Creating accounts

Create an account name to use for our smart contract
`cleos create account eosio user [PUBLIC_KEY]`

List all of your accounts
`cleos get accounts [PUBLIC_KEY]`

## Create your first Smart Contract
#### Creating a smart contract is rather simple. The library `eosio` has a lot of functions that make things easy.

- Command for creating your first smart contract:  `eosiocpp -n ping`
- cd into the ping directory: `cd ping`
- Now open up the code with your favorite text editor

- You should see the following boilerplate code
```
#include <eosiolib/eosio.hpp>

using namespace eosio;

class hello : public eosio::contract {
  public:
      using contract::contract;

      /// @abi action
      void hi( account_name user ) {
         print( "Hello, ", name{user} );
      }
};

EOSIO_ABI( hello, (hi) )
```

- Paste the following to ping.cpp
```
#include <eosiolib/eosio.hpp>

using namespace eosio;

class pingpong : public eosio::contract {
  public:
      using contract::contract;

      /// @abi action
      void ping( account_name user ) {
         print( "Pong, ", name{user} );
      }
};

EOSIO_ABI( pingpong, (ping) )
```

- Change `Hello` to `Pong` for funz.
- Create a new account for the smart contract (Make sure your wallet is unlocked) `cleos create account eosio ping.code [PUBLIC_KEY]`
- Create a new file called `compile.sh` in the `ping` directory. Paste the following code in the file:
```
eosiocpp -o ping.wast ping.cpp
eosiocpp -g ping.abi ping.cpp
cleos set contract ping.code ../ping -p ping.code
```
- Now run `sh compile.sh`. This will compile your smart contract and publish it to your local blockchain.
- You can interact with your smart contract by running: `cleos push action ping.code ping '["user"]' -p user`
- Congratulations! You just deployed and executed your first smart contract.
