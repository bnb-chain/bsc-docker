# Binance Smart Chain Private Cluster

Create a private [Binance Smart Chain](https://github.com/binance-chain/bsc) cluster and run [bep20 truffle test](https://github.com/binance-chain/canonical-upgradeable-bep20) in local docker.

## Prerequisites

- Install `make`, `docker` and `docker-compose` on your local machine. If you are using [Docker Destop](https://www.docker.com/products/docker-desktop), please make sure to set `Resources` at least `2 CPU cores` and `6GB memory`

- Edit `docker-compose.bsc.yml`:
    - set `GIT_SOURCE` point to bsc repository source (default: `https://github.com/binance-chain/bsc`).
    - set `GIT_CHECKOUT_REF` point to `(commit / branch / tag)` that you want to build (default: `master`).

- ***(Optional)***:
    - Edit `.env`, modify `BSC_CHAIN_ID` and other attributes
    - Edit `docker-compose.simple.bootstrap.yml`, modify `INIT_HOLDER_BALANCE`
    - Edit `docker-compose.cluster.bootstrap.yml`, modify `INIT_HOLDER_BALANCE`
    
## Account & Private Keys
```
Account 1: 0xb75573a04648535Bddc52adf6fBc887149624253, private key: 0x953dbe85f02d84377f90a6eb6d8a6dd128aa50f69c4671d32414b139040be24b
Account 2: 0xA2bC4Cf857f3D7a22b29c71774B4d8f25cc7edD0, private key: 0xa568b36fca21714f879e3cf157f021a4c5dccd6229ef6e6eee7fb7888193c026
Account 3: 0x59b02D4d2F94ea5c55230715a58EBb0b703bCD4B, private key: 0xc484de1ef84e998869d59752d1f09bffa161673d54250ea152ec82d684e2f154
Account 4: 0xBb46AbbCC95213754f549E0CFa2B13bef0aBFaB6, private key: 0x4d5211ccb78c977d7ae7094b27b561458274a1c2df8be5f3c66479fe33ea8838
Account 5: 0x8E1Ad6FaC6ea5871140594ABEF5b1D503385e936, private key: 0x3c6efff45290e2204cc19b091cdefffcead5757b074b1723e9cf8973e6337ba4
Account 6: 0xC8D063A7e0A118432721daE5e059404b5598BD76, private key: 0x81f43b0303746bfacbaae64947850e86deca412d3b39b1f8d3c89bf483d615f3
Account 7: 0xc32ec0115BCB6693d4b4854531cA5e6a99217ABF, private key: 0xeca0930606860b8ae4a7f2b9a56ee62c4e11f613a894810b7642cabef689cf09
Account 8: 0x7fd60C817837dCFEFCa6D0A52A44980d12F70C59, private key: 0x68ef711b398fa47f22fbc44a972efbd2c2e25338e7c6afb92dc84b569bf784a5
```
- ***(Optional)*** Below are commands to generate above account & keys from `init-holders` folder. 
    ```
    # install web3
    pip3 install web3

    # generate account & private keys from "init-holders" folder
    python3 private-key.py
    ```
    - You can add more key files (with empty decoded password) into `init-holders` folder and re-run above command.

## Simple Validator Node Cluster

- Execute below commands to build & start a simple cluster with only `1 validator` and `1 rpc` node (refer to `Makefile` for details):
    ```shell script
    # Build all docker images
    make build-simple

    # Generate genesis.json, validators & bootstrap cluster data
    # Once finished, all cluster bootstrap data are generated at ./storage
    make bootstrap-simple

    # Start cluster
    make start-simple
    ```

- Go to http://localhost:3000/ verify all nodes gradually connected to each other and block start counting.

- Run `make run-test-simple` to start bep20 truffle test.

## Three Validator Node Cluster

- Reset existing simple cluster data
    ```shell script
    make reset
    ```

- Execute below commands to build & start `3 validators` cluster with `1 rpc` node (refer to `Makefile` for details):
    ```shell script
    # Build all docker images
    make build-cluster

    # Generate genesis.json, validators & bootstrap cluster data
    # Once finished, all cluster bootstrap data are generated at ./storage
    make bootstrap-cluster

    # Start cluster
    make start-cluster
    ```

- Go to http://localhost:3000/ verify all nodes gradually connected to each other and block start counting.

- Run `make run-test-cluster` to start bep20 truffle test.

## Development Configuration
You may need to rebuild BSC docker image, reset data or start cluster with new configuration.

### [Optional] Rebuild BSC Docker Image:
- Edit `docker-compose.bsc.yml`:
- Modify `GIT_SOURCE` point to your own private repo.
- Modify `GIT_CHECKOUT_REF`  point to related (`branch` / `tags` / `commit`).
- Execute: `make build-simple` or `make build-cluster` to rebuild bsc docker

### [Optional] Reset Data:
- Execute `make reset` to remove all data
- Execute: `make bootstrap-simple` or `make bootstrap-cluster` to generate new bsc data

### [Optional] Start Cluster With New Configuration:
- Edit below config files to adjust rpc & validators options:
    - `config/config-bsc-rpc.toml`
    - `config/config-bsc-validator.toml`
- Edit below script files to adjust rpc & validators run command:
    - `scripts/bsc-rpc.sh`
    - `scripts/bsc-validator.sh`
- Finally, execute either `make start-simple` and `make start-cluster` to start

## Bootnode Configuration

The `bsc-rpc` act as a bootstrap endpoint with `config/bootstrap.key` and its corresponding `BOOTSTRAP_PUB_KEY` (as in `.env`).

If you want to generate a new `bootstrap.key` and `BOOTSTRAP_PUB_KEY`, just execute below commands:
```shell script
# this ./bootnode binary only applicable for MacOS
chmod +x ./bootnode 

# Generate bootstrap.key
./bootnode -genkey bootstrap.key

# Create a new BOOTSTRAP_PUB_KEY from bootstrap.key
./bootnode -nodekey bootstrap.key -writeaddress
```
- Then, copy `bootstrap.key` over `config` directory
- Finally, edit `.env` set `BOOTSTRAP_PUB_KEY` to new created value.
    - It will be used to construct bootnode endpoint `enode://${BOOTSTRAP_PUB_KEY}@${BOOTSTRAP_IP}:30311` for peer discovery mechanism.