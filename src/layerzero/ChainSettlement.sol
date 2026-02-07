// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title ChainSettlement
 * @notice Defines the settlement chain ID for cross-chain operations
 * @dev Arc Testnet chain ID (update when Arc mainnet is available)
 */
abstract contract ChainSettlement {
    /// @notice Settlement chain ID for Arc Testnet
    uint256 public constant SETTLEMENT_CHAIN_ID = 5042002;
}
