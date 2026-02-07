// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script, console } from "forge-std/Script.sol";
import { HelperUtils } from "@src/HelperUtils.sol";
import { Helper } from "@script/DevTools/Helper.sol";
import { SelectRpc } from "@script/DevTools/SelectRpc.sol";

/**
 * @title HelperUtils_GetExchangeRate
 * @notice Shortcut script to get the exchange rate between two tokens
 */
contract HelperUtils_GetExchangeRate is Script, Helper, SelectRpc {
    // Replace with actual addresses
    address public tokenIn = address(0); // Replace with actual input token address
    address public tokenOut = address(0); // Replace with actual output token address
    address public position = address(0); // Replace with actual position address
    uint256 public amountIn = 1e18; // Amount of input token (default 1 token with 18 decimals)

    function setUp() public {
        selectRpc();
    }

    function run() public view {
        require(tokenIn != address(0), "TokenIn address not set");
        require(tokenOut != address(0), "TokenOut address not set");
        require(position != address(0), "Position address not set");

        HelperUtils helperUtils = HelperUtils(KAIA_TESTNET_HELPER_UTILS);

        uint256 exchangeRate = helperUtils.getExchangeRate(tokenIn, tokenOut, amountIn, position);

        console.log("=== Exchange Rate ===");
        console.log("Token In:", tokenIn);
        console.log("Token Out:", tokenOut);
        console.log("Amount In:", amountIn);
        console.log("Exchange Rate:", exchangeRate);
    }
}

// RUN
// forge script HelperUtils_GetExchangeRate -vvv
