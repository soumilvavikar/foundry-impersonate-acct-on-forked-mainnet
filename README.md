# Simple Test Contract to Impersonate a Whale Account

This project provides a simple example of how to interact with the USDC token contract, impersonate a whale account, transfer tokens, and verify the transaction's success on a forked Ethereum blockchain.

## Initial Setup

### Create a new project

```shell
forge init
```

Remove the default files from the src, script, and test folders.

### Setup the `.env` file

Create a `.env` file, please refer to the `.env.sample` file. Once the file is prepared, execute the following command.

```shell
source .env
```

**NOTE**: We need to execute this command on both the terminal windows
  
- One for running forked instance of the mainnet on anvil local chain
- One for running the test commands

## Start the forked instance of Mainnet

```shell
# This command will start the local anvil chain forked from mainnet
anvil --fork-url $INFURA_RPC_URL --fork-block-number $FORKED_BLOCK_NUMBER

# Validate that the correct block number has been used for forking.
cast block-number
```

## Run the Test which Impersonates the Whale Account

```shell
forge test --rpc-url $RPC_URL --mt testTokenTransfer  -vvvv
# OR
forge test --rpc-url $RPC_URL
```
