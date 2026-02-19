# Compose NFT Template (ERC-8153)

Facet-based Diamond (ERC-8153) proxy template with Foundry. This template is a simple implementation of a NFT contract

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)

## Documentation

- [Compose GitHub](https://github.com/Perfect-Abstractions/Compose)
- [Compose Documentation](https://compose.diamonds/docs)
- [ERC-8153: Facet-Based Diamonds](https://eips.ethereum.org/EIPS/eip-8153)
- [Foundry Book](https://book.getfoundry.sh/)

## Commands

### Build

```bash
forge build
```

Build with contract sizes (e.g. for CI):

```bash
forge build --sizes
```

### Test

```bash
forge test
```

Verbose output:

```bash
forge test -vvv
```

Run a specific test or match pattern:

```bash
forge test --match-test <name>
forge test --match-path <path>
```

### Format

Format all Solidity files:

```bash
forge fmt
```

Check formatting without writing (CI):

```bash
forge fmt --check
```

### Gas snapshots

```bash
forge snapshot
```

### Clean

Remove build artifacts and cache:

```bash
forge clean
```

### Dependencies

Install a dependency (e.g. from GitHub):

```bash
forge install <owner/repo>
```

### Local node (Anvil)

Start a local Ethereum node:

```bash
anvil
```

This will start a local node at `http://127.0.0.1:8545` with the default chain id `31337`.

With custom port or chain id:

```bash
anvil --port 8546 --chain-id 31337
```

### Deploy

Deploy the diamond and facets (script: `Deploy.s.sol`, contract: `DeployDiamond`):

```bash
forge script script/Deploy.s.sol:DeployDiamond \
  --rpc-url <RPC_URL> \
  --private-key <PRIVATE_KEY> \
  --broadcast
```

Optional environment variables:

- `VERBOSE=1` – log facet addresses and selectors after deployment
- `DIAMOND_OWNER=<address>` – diamond owner on non-local chains (default: broadcaster)

Example with verbose output:

```bash
VERBOSE=1 forge script script/Deploy.s.sol:DeployDiamond \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast
```

Simulate without broadcasting:

```bash
forge script script/Deploy.s.sol:DeployDiamond --rpc-url <RPC_URL>
```

### Cast (interact with chains and contracts)

Common Cast commands:

```bash
# Chain / account
cast block-number --rpc-url <RPC_URL>
cast balance <ADDRESS> --rpc-url <RPC_URL>
cast nonce <ADDRESS> --rpc-url <RPC_URL>

# Call view functions
cast call <CONTRACT> "<signature>" [args...] --rpc-url <RPC_URL>

# Send transaction
cast send <CONTRACT> "<signature>" [args...] \
  --rpc-url <RPC_URL> --private-key <PRIVATE_KEY>

# Encode / decode
cast calldata "<signature>" [args...]
cast abi-decode <type> <data>
```

### Help

```bash
forge --help
forge build --help
forge test --help
forge script --help
anvil --help
cast --help
```
