# <h1 align="center"> A Tangle Blueprint 🌐 </h1>

**A simple Hello World Blueprint for Tangle**

## 📚 Prerequisites
Before you can run this project, you will need to have the following software installed on your machine:

- [Rust](https://www.rust-lang.org/tools/install)
- [Forge](https://getfoundry.sh)
- [Tangle](https://github.com/webb-tools/tangle?tab=readme-ov-file#-getting-started-)

You will also need to install `cargo-tangle`, our CLI tool for creating and deploying Tangle Blueprints:

To install the Tangle CLI, run the following command:

> Supported on Linux, MacOS, and Windows (WSL2)

```bash
curl --proto '=https' --tlsv1.2 -LsSf https://github.com/webb-tools/gadget/releases/download/cargo-tangle-v0.1.2/cargo-tangle-installer.sh | sh
```

Or, if you prefer to install the CLI from crates.io:

```bash
cargo install cargo-tangle --force # to get the latest version.
```
and follow the instructions to create a new project.


#### RISC Zero dependencies
This project relies on RISC Zero for proving rust program execution. The rzup toolchain is required.

```shell
curl -L https://risczero.com/install | bash

Run rzup to install RISC Zero:

rzup install
```

#### Tangle Node
To build and run the Tangle node, clone the [github repository](https://github.com/tangle-network/tangle), and follow the readme instructions.

## 🛠️ Development

Once you have created a new project, you can run the following command to start the project:

```sh
cargo build
forge build
```
to build the project, and


```sh
export EVM_SIGNER="0xcb6df9de1efca7a3998a8ead4e02159d5fa99c3e0d4fd6432667390bb4726854" # EVM signer account
export SIGNER="//Alice" # Substrate Signer account
cargo tangle gadget deploy
```
to deploy the blueprint to the Tangle network.

## 📚 Overview

TBD

## 🚄 Quick Start
These steps walk you through running the Tangle node, starting a local zkvm gadget which listens for onchain events, and deploying a service and executing the job. The gadget responds to the event by generating a proof and submitting it to the onchain verifer contract, which verifies the proof.

### Start Tangle Node
In Tangle Project:
```shell
./scripts/run-standalone-local.sh --clean
```

### Start Gadget
Note the log target, which allows you to check the progress of the proof generation and submission
```shell
# Prepare the well-known "Alice" key for use by inserting into the keystore
cargo tangle blueprint keygen --key-type sr25519 --path ./keystore/ --seed e5be9a5092b81bca64be81d212e7f2f9eba183bb7a90954f7b76361f6edb5c0a
RUST_LOG=gadget=info RUST_BACKTRACE=1 RPC_URL=ws://localhost:9944 BLUEPRINT_ID=0 cargo r -p zkvm-blueprint run --bind-addr=127.0.0.1 --bind-port 9944 --blueprint-id 0 --url ws://localhost:9944 --service-id=0 --keystore-uri file://./keystore --protocol tangle
```

### Deploy Contracts and Create a Test Job
```shell
nvm use
yarn
yarn tsx deploy.ts 
```



## 📬 Feedback

If you have any feedback or issues, please feel free to open an issue on our [GitHub repository](https://github.com/webb-tools/blueprint-template/issues).

## 📜 License

This project is licensed under the unlicense License. See the [LICENSE](./LICENSE) file for more details.
