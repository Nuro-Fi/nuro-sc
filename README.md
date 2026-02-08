# NuroFi First yield-bearing collateral lending on Arc. USYC as collateral, borrow anychain

> **Unified liquidity lending protocol powered by LayerZero OFT for seamless cross-chain borrowing**

[![Website](https://img.shields.io/badge/Website-nurofi.xyz-blue)](https://www.nurofi.xyz/)
[![Twitter](https://img.shields.io/badge/Twitter-@NuroFiLend-1DA1F2)](https://x.com/NuroFiLend)
[![Docs](https://img.shields.io/badge/Docs-GitBook-green)](https://nuro-fi.gitbook.io/nuro-fi-docs/)
[![GitHub](https://img.shields.io/badge/GitHub-Nuro--Fi-black)](https://github.com/Nuro-Fi)

[Website](https://www.nurofi.xyz/) | [Documentation](https://nuro-fi.gitbook.io/nuro-fi-docs/) | [Twitter](https://x.com/NuroFiLend) | [GitHub](https://github.com/Nuro-Fi) | [Pitch Deck](https://www.canva.com/design/DAHArHlwbek/k1lcPouD2OZAmUVE0WOkAA/edit?utm_content=DAHArHlwbek&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton) | [Demo Video](https://www.youtube.com/watch?v=i7Sc11xb3C0)

NuroFi is a multi-chain lending protocol that enables users to supply liquidity on one chain and borrow against collateral on another. Built on LayerZero's Omnichain Fungible Token (OFT) standard, NuroFi eliminates liquidity fragmentation across chains while maintaining capital efficiency.

## 🎯 Problem Statement

Traditional DeFi lending protocols face critical challenges:
- **Liquidity Fragmentation**: Each chain operates as an isolated silo
- **Capital Inefficiency**: Users must maintain collateral on the same chain as their borrowing
- **Poor UX**: Complex bridging processes for cross-chain operations
- **High Slippage**: Limited liquidity pools on emerging chains

## 💡 Solution

NuroFi leverages LayerZero V2 to create a unified lending pool across multiple chains:

1. **Hub-Spoke Architecture**: Arc Network serves as the settlement layer (hub), with Base Sepolia as an initial spoke chain
2. **Native Cross-Chain Borrowing**: Borrow on any chain, backed by collateral on another
3. **Unified Liquidity**: Single liquidity pool accessible across all supported chains
4. **Stablecoin Support**: USDC, USYC, and EURC with consistent 6-decimal precision
5. **USDC Gas Fees**: Arc Network uses USDC as the native gas token

## 🏗️ Architecture

### Core Components

```
┌──────────────────────────────────────────────────────────────┐
│              Arc Network (Hub Chain - USDC Gas)              │
│                                                              │
│  ┌──────────────┐  ┌─────────────┐  ┌──────────────────┐  │
│  │ LendingPool  │  │  OFT USDC   │  │  OFT EURC/USYC  │  │
│  │   Factory    │  │   Adapter   │  │    Adapters      │  │
│  │              │  │ Lock/Unlock │  │   Lock/Unlock    │  │
│  └──────────────┘  └─────────────┘  └──────────────────┘  │
│         │                  │                   │            │
└─────────┼──────────────────┼───────────────────┼────────────┘
          │                  │                   │
      LayerZero V2      LayerZero V2        LayerZero V2
          │                  │                   │
┌─────────┼──────────────────┼───────────────────┼────────────┐
│         │                  │                   │            │
│  ┌──────▼──────┐  ┌───────▼─────┐  ┌─────────▼────────┐  │
│  │ LendingPool │  │ nUSDC Token │  │ nEURC/nUSYC Tokens│ │
│  │  (Mirror)   │  │ Mint/Burn   │  │   Mint/Burn      │  │
│  └─────────────┘  └─────────────┘  └──────────────────┘  │
│                                                            │
│              Base Sepolia Testnet (Spoke Chain)            │
└────────────────────────────────────────────────────────────┘
```

### Smart Contract Overview

#### LayerZero Integration

1. **OFTUSDCAdapter.sol** - USDC cross-chain adapter
   - Lock/unlock on Arc (settlement chain)
   - Mint/burn on spoke chains (Kaia)
   - 6 decimal precision enforcement
   - Handles cross-chain messaging via LayerZero

2. **OFTEURCAdapter.sol** - EURC cross-chain adapter
   - Similar architecture to USDC adapter
   - Supports Euro-backed stablecoin transfers

3. **OFTadapter.sol** - Generic OFT adapter for USYC and other tokens

4. **ChainSettlement.sol** - Chain identification helper
   - Determines if current chain is hub or spoke
   - Routes logic for lock/unlock vs mint/burn

5. **ElevatedMinterBurner.sol** - Privileged minting contract
   - Controls token supply on spoke chains
   - Only callable by OFT adapters

#### Core Lending Contracts

1. **LendingPool.sol** - Core lending pool logic
   - Supply/withdraw liquidity
   - Borrow/repay with collateral
   - Interest rate calculations
   - Cross-chain position management
   - UUPS upgradeable pattern

2. **LendingPoolFactory.sol** - Pool deployment factory
   - Creates isolated lending pools per token
   - Configures oracle adapters
   - Manages pool parameters

3. **LendingPoolRouter.sol** - User-facing router
   - Aggregates pool interactions
   - Manages user positions
   - Native token wrapping/unwrapping

4. **Position.sol** - User collateral positions
   - Tracks collateral across chains
   - Health factor calculations
   - Liquidation logic

5. **InterestRateModel.sol** - Dynamic interest rates
   - Utilization-based rate curves
   - Configurable per pool

#### Oracle & Data Feeds

1. **OracleAdapter.sol** - Price feed adapter
   - Integrates with Band Protocol on Arc
   - Chainlink-compatible interface
   - Handles price updates for risk calculations

2. **Pricefeed.sol** - Price aggregation
   - Multi-source price validation
   - Staleness checks
   - Supports custom oracle feeds

### Key Design Decisions

**Why Hub-Spoke Model?**
- **Security**: Arc serves as single source of truth for liquidity
- **Gas Efficiency**: Only one settlement layer reduces cross-chain message overhead
- **Scalability**: Easy to add new spoke chains without modifying existing infrastructure

**Why 6 Decimals for All Tokens?**
- **Consistency**: Avoids decimal conversion errors across chains
- **USDC Standard**: Aligns with USDC's native 6 decimals on most chains
- **Gas Optimization**: Smaller numbers reduce calldata costs

**Lock/Unlock vs Mint/Burn**
- **Arc (Hub)**: Locks real USDC/EURC/USYC - maintains backing 1:1
- **Base Sepolia (Spoke)**: Mints synthetic nUSDC/nEURC/nUSYC - pegged to hub reserves
- **Benefit**: No liquidity splitting, all reserves on Arc

**USDC as Gas Token on Arc**
- Arc Network uses USDC as the native gas fee token instead of ETH
- All transactions on Arc are paid in USDC (6 decimals)
- Users need USDC balance to interact with contracts on Arc

## 🚀 Deployment

### Prerequisites

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Clone repository
git clone <your-repo>
cd nuro-sc-deploy

# Install dependencies
forge install
```

### Environment Setup

Create `.env` file:

```bash
# RPC Endpoints
ARC_TESTNET_RPC=https://rpc.arc.network/testnet
BASE_TESTNET_RPC=https://sepolia.base.org

# Private Keys
PRIVATE_KEY=your_private_key_here

# LayerZero Endpoints
ARC_LZ_ENDPOINT=0x6EDCE65403992e310A62460808c4b910D972f10f
BASE_LZ_ENDPOINT=0x6EDCE65403992e310A62460808c4b910D972f10f

# Token Addresses (from deployment)
USDC_ARC=0x8c064bCf7C0DA3B3b090BAbFE8f3323534D84d68
NUSDC_BASE=0xc773715a19aCCbC2C7Fde4416CC59Eb55c009D02
```

### Deployment Steps

The deployment process is modular, using numbered scripts in `script/Nuro/steps/`:

#### 1. Deploy OFT Adapters

```bash
# Deploy on Arc (Hub)
forge script script/Nuro/steps/1.DeployOft.s.sol:DeployOft \
  --rpc-url arc_testnet \
  --broadcast \
  --verify

# Deploy on Base Sepolia (Spoke)
forge script script/Nuro/steps/1.DeployOft.s.sol:DeployOft \
  --rpc-url base_testnet \
  --broadcast \
  --verify
```

#### 2. Configure LayerZero Pathways

```bash
# Set peer addresses (run on both chains)
forge script script/Nuro/steps/2.SetPeer.s.sol:SetPeer \
  --rpc-url arc_testnet \
  --broadcast

forge script script/Nuro/steps/2.SetPeer.s.sol:SetPeer \
  --rpc-url base_testnet \
  --broadcast
```

#### 3. Configure Enforcers & Security

```bash
# Set DVN config
forge script script/Nuro/steps/3.SetEnforcedOptions.s.sol \
  --rpc-url arc_testnet \
  --broadcast

# Set receive config
forge script script/Nuro/steps/4.SetReceiveConfig.s.sol \
  --rpc-url arc_testnet \
  --broadcast
```

#### 4. Deploy Core Lending Contracts

```bash
# Deploy factory & pools
forge script script/Nuro/steps/9.DeployDeployers.s.sol \
  --rpc-url arc_testnet \
  --broadcast

# Initialize pools
forge script script/Nuro/steps/18.SetFactoryConfig.s.sol \
  --rpc-url arc_testnet \
  --broadcast
```

### Deployed Contracts

#### Arc Testnet (Chain ID: 5042002)

| Contract | Address | Description |
|----------|---------|-------------|
| Mock USDC | `0x8c064bCf7C0DA3B3b090BAbFE8f3323534D84d68` | USDC token (gas + bridging) |
| Mock USYC | `0x04C37dc1b538E00b31e6bc883E16d97cD7937a10` | USYC token |
| Mock EURC | `0x15858A57854BBf0DF60A737811d50e1Ee785f9bc` | EURC token |
| OFT USDC Adapter | `0x5C368bd6cE77b2ca47B4ba791fCC1f1645591c84` | Lock/unlock USDC on Arc |
| OFT USYC Adapter | `0x39926DA4905f5Edb956F5dB5F2e2FF044E0882B2` | Lock/unlock USYC on Arc |
| OFT EURC Adapter | `0x886ba47579DC4f5DcB53ffd20429089A7788C072` | Lock/unlock EURC on Arc |
| Lending Pool Factory | `0xb0FCA55167f94D0f515877C411E0deb904321761` | Pool creator contract |
| Protocol | `0x394239573079a46e438ea6D118Fd96d37A61f270` | Protocol configuration |
| Nuro Emitter | `0xec32CC0267002618c339274C18AD48D2Bf2A9c7e` | Event emitter |

#### Base Sepolia Testnet (Chain ID: 84532)

| Contract | Address | Description |
|----------|---------|-------------|
| nUSDC Token | `0xc773715a19aCCbC2C7Fde4416CC59Eb55c009D02` | Synthetic USDC on Base |
| nUSYC Token | `0xE70269A183e244CC90959AE4A8a3230b6519E11D` | Synthetic USYC on Base |
| nEURC Token | `0xDB5603AD7D60DAF731ccdC48bC4db66Fb85A3f79` | Synthetic EURC on Base |
| nUSDC OFT Adapter | `0x0c832FeE16d5A8BC99B888E16D3712E6BEf96Fb7` | Mint/burn nUSDC on Base |
| nUSYC OFT Adapter | `0x8f388874B0195CA2F9De3E85D17EE3EfA0058B7c` | Mint/burn nUSYC on Base |
| nEURC OFT Adapter | `0x427cc6C2359E2a2AbaBF7A45Ce66Ba82Bb77B282` | Mint/burn nEURC on Base |
| USDC Elevated Minter | `0xDbcdd37a885201f368D105EBaF1A8962204351a4` | Token supply controller |
| USYC Elevated Minter | `0x3f4776f560770Fc9B7C4eE15b7Bf4f1cE02Ab64e` | Token supply controller |
| EURC Elevated Minter | `0x009F50A69cE2Fbc3806824C81c0D9865A4b758f7` | Token supply controller |

## 🧪 Testing

### Run Test Suite

```bash
# Run all tests
forge test

# Run with verbosity
forge test -vvv

# Run specific test file
forge test --match-path test/LendingPool.t.sol

# Run with gas reporting
forge test --gas-report
```

### Integration Test Flow

```bash
# Test cross-chain transfer
forge script script/DevTools/TestCrossChainTransfer.s.sol \
  --rpc-url arc_testnet \
  --broadcast
```

### Manual Testing via Cast

```bash
# Check OFT adapter balance
cast call $OFT_ADAPTER "balanceOf(address)(uint256)" $YOUR_ADDRESS \
  --rpc-url arc_testnet

# Send cross-chain message
cast send $OFT_ADAPTER "send((uint32,bytes32,uint256,uint256,bytes,bytes,bytes),(uint256,uint256))" \
  "(1001,0x...,1000000,0,'','','')" "(0,0)" \
  --rpc-url arc_testnet \
  --private-key $PRIVATE_KEY \
  --value 0.1ether
```

## 🔒 Security Considerations

### Known Limitations

1. **Decimal Precision**: All tokens MUST use 6 decimals. Mixing decimals will cause incorrect balance handling.

2. **Settlement Chain Dependency**: Arc Network acts as single point of failure. If Arc goes down, cross-chain operations halt.

3. **Oracle Dependency**: Price feed staleness can prevent liquidations. Monitor oracle uptime.

4. **Gas Price Volatility**: Cross-chain messages require gas on destination. Users must have native tokens on both chains.

### Security Features

- ✅ **Reentrancy Guards**: All external calls protected
- ✅ **Access Control**: Role-based permissions on admin functions
- ✅ **Pausable**: Emergency pause mechanism
- ✅ **Upgradeable**: UUPS pattern with timelock (TODO)
- ✅ **Slippage Protection**: Minimum amount checks on bridging
- ✅ **Health Factor**: Over-collateralization requirements

## 📊 Gas Estimates

| Operation | Arc Network (USDC) | Base Sepolia (ETH) |
|-----------|--------------------|--------------------|
| Supply Liquidity | ~150k gas (~$0.15 USDC) | ~150k gas |
| Borrow | ~180k gas (~$0.18 USDC) | ~180k gas |
| Repay | ~120k gas (~$0.12 USDC) | ~120k gas |
| Cross-chain Bridge | ~250k gas + LZ fees | ~250k gas + LZ fees |
| Liquidation | ~200k gas (~$0.20 USDC) | ~200k gas |

**Important Notes:**
- Arc Network uses USDC as gas token (assumes ~$1/USDC, actual cost depends on gas price)
- Base Sepolia uses ETH for gas fees
- LayerZero fees: ~0.01-0.05 ETH per cross-chain message (varies by gas price)

## 🛠️ Development

### Project Structure

```
nuro-sc-deploy/
├── src/
│   ├── LendingPool.sol           # Core lending logic
│   ├── LendingPoolFactory.sol    # Pool factory
│   ├── LendingPoolRouter.sol     # User-facing router
│   ├── Position.sol               # Collateral positions
│   ├── InterestRateModel.sol     # Rate calculations
│   ├── OracleAdapter.sol          # Price feeds
│   ├── layerzero/
│   │   ├── OFTUSDCAdapter.sol    # USDC OFT
│   │   ├── OFTEURCAdapter.sol    # EURC OFT
│   │   ├── OFTadapter.sol        # Generic OFT
│   │   ├── ChainSettlement.sol   # Hub/spoke logic
│   │   └── ElevatedMinterBurner.sol
│   └── interfaces/                # Contract interfaces
├── script/
│   ├── Nuro/steps/               # Deployment scripts (numbered)
│   └── DevTools/                 # Testing utilities
├── test/                         # Foundry tests
├── lib/                          # Dependencies (git submodules)
└── foundry.toml                  # Foundry config
```

### Adding a New Chain

1. Add RPC endpoint to `foundry.toml`
2. Deploy OFT adapter on new chain (mint/burn mode)
3. Deploy Elevated Minter Burner
4. Set peer connections to Arc hub
5. Configure DVN and gas limits
6. Deploy mirror lending pool (optional)

### Extending Token Support

1. Create new `OFTTokenAdapter.sol` based on USDC adapter
2. Deploy on Arc (lock/unlock)
3. Deploy on spoke chains (mint/burn)
4. Add to LendingPoolFactory whitelist
5. Configure oracle price feed

## 🤝 Built With

- **[Foundry](https://book.getfoundry.sh/)** - Smart contract development framework
- **[LayerZero V2](https://docs.layerzero.network/)** - Omnichain messaging protocol
- **[OpenZeppelin](https://docs.openzeppelin.com/)** - Secure contract libraries
- **[Arc Network](https://arc.network/)** - EVM-compatible settlement layer with USDC gas
- **[Base](https://base.org/)** - Coinbase L2 blockchain built on Optimism

## 🏆 ETH Global Hackathon

### Innovation Highlights

1. **Hub-Spoke Lending**: First lending protocol using LayerZero OFT with asymmetric lock/unlock + mint/burn model
2. **Unified Liquidity**: Eliminates liquidity fragmentation across chains
3. **Capital Efficiency**: Borrow on any chain backed by collateral on another
4. **Stablecoin Focus**: Supports multiple stablecoins (USDC, USYC, EURC) with consistent decimal handling

## 📝 License

MIT License - see LICENSE file for details

## 🙏 Acknowledgments

- LayerZero Labs for OFT standard and cross-chain infrastructure
- Arc Network team for settlement layer support and USDC gas innovation
- Base team for L2 infrastructure and testnet access
- OpenZeppelin for battle-tested smart contract libraries
- ETH Global for organizing this hackathon

---

**Built with ❤️ by Nuro Labs**
