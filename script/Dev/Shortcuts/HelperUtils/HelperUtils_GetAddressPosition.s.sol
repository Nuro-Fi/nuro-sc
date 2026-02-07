// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script, console } from "forge-std/Script.sol";
import { HelperUtils } from "@src/HelperUtils.sol";
import { Helper } from "@script/DevTools/Helper.sol";
import { SelectRpc } from "@script/DevTools/SelectRpc.sol";

/**
 * @title HelperUtils_GetAddressPosition
 * @notice Shortcut script to get the position address of a user in a lending pool
 */
contract HelperUtils_GetAddressPosition is Script, Helper, SelectRpc {
    address public owner = vm.envAddress("PUBLIC_KEY");

    // Replace with actual addresses
    address public lendingPool = 0x1cDbb68c15EF610d6350BC14387D56002f8827A6;
    address public user = 0x0EcE75f3C36f7Df2136Dac7633165DBff53dE3CD;

    // Configurable address via environment variable
    address public helperUtilsAddress = vm.envOr("HELPER_UTILS", address(0));

    function setUp() public {
        selectRpc();
        if (user == address(0)) {
            user = owner;
        }
    }

    function run() public view {
        require(lendingPool != address(0), "Lending pool address not set");
        require(user != address(0), "User address not set");
        require(helperUtilsAddress != address(0), "HELPER_UTILS env not set");

        HelperUtils helperUtils = HelperUtils(helperUtilsAddress);

        address positionAddress = helperUtils.getAddressPosition(lendingPool, user);

        console.log("=== Position Address ===");
        console.log("Lending Pool:", lendingPool);
        console.log("User:", user);
        console.log("Position Address:", positionAddress);
    }
}

// RUN
// forge script HelperUtils_GetAddressPosition -vvv
