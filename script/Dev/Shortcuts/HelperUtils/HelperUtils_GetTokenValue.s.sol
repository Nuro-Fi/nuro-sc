// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script, console } from "forge-std/Script.sol";
import { HelperUtils } from "@src/HelperUtils.sol";
import { Helper } from "@script/DevTools/Helper.sol";
import { SelectRpc } from "@script/DevTools/SelectRpc.sol";

/**
 * @title HelperUtils_GetTokenValue
 * @notice Shortcut script to get the current price of a token from the oracle
 */
contract HelperUtils_GetTokenValue is Script, Helper, SelectRpc {
    // Replace with actual token address
    address public token = address(0); // Replace with actual token address

    function setUp() public {
        selectRpc();
    }

    function run() public view {
        require(token != address(0), "Token address not set");

        HelperUtils helperUtils = HelperUtils(KAIA_TESTNET_HELPER_UTILS);

        uint256 tokenValue = helperUtils.getTokenValue(token);

        console.log("=== Token Value ===");
        console.log("Token:", token);
        console.log("Token Value (Price):", tokenValue);
    }
}

// RUN
// forge script HelperUtils_GetTokenValue -vvv
