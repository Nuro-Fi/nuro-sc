// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script, console } from "forge-std/Script.sol";
import { Helper } from "@script/DevTools/Helper.sol";
import { IERC20 } from "forge-std/interfaces/IERC20.sol";
import { LendingPool } from "@src/LendingPool.sol";

/**
 * @title CheckBalance
 * @notice Development script for checking token balances and withdrawing liquidity from the lending pool
 * @dev This script is intended for development and testing purposes
 * It performs balance checks on OFT adapters and executes a liquidity withdrawal
 * Configure the addresses via environment variables for your target chain
 */
contract CheckBalance is Script, Helper {
    //////////////////////////////////////////////////////////////////////////////
    //                              EXTERNAL FUNCTIONS                          //
    //////////////////////////////////////////////////////////////////////////////

    /**
     * @notice Main execution function that checks balances and withdraws liquidity
     * @dev This function performs the following operations:
     * 1. Creates a fork of the target chain for testing
     * 2. Starts broadcasting transactions using the private key from environment variables
     * 3. Logs the token balance of the OFT adapter contract
     * 4. Withdraws liquidity from the lending pool
     * 5. Stops broadcasting transactions
     *
     * Security considerations:
     * - Uses PRIVATE_KEY from environment variables - ensure this is kept secure
     * - Lending pool and token addresses should be verified before execution
     *
     * Usage: forge script CheckBalance --broadcast -vvv
     */
    function run() external {
        // Configure these addresses for your target chain
        address token = vm.envOr("TOKEN_ADDRESS", address(0));
        address oftAdapter = vm.envOr("OFT_ADAPTER_ADDRESS", address(0));
        address lendingPool = vm.envOr("LENDING_POOL_ADDRESS", address(0));
        uint256 withdrawAmount = vm.envOr("WITHDRAW_AMOUNT", uint256(1e6));

        require(token != address(0), "TOKEN_ADDRESS not set");
        require(oftAdapter != address(0), "OFT_ADAPTER_ADDRESS not set");
        require(lendingPool != address(0), "LENDING_POOL_ADDRESS not set");

        vm.createSelectFork(vm.rpcUrl("base_testnet"));
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("balance of OFT_ADAPTER", IERC20(token).balanceOf(oftAdapter));
        LendingPool(payable(lendingPool)).withdrawLiquidity(withdrawAmount);
        vm.stopBroadcast();
    }
}

// RUN
// TOKEN_ADDRESS=0x... OFT_ADAPTER_ADDRESS=0x... LENDING_POOL_ADDRESS=0x... forge script CheckBalance --broadcast -vvv
