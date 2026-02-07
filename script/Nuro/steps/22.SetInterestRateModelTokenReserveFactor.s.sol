// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetInterestRateModelTokenReserveFactor is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        _setInterestRateModelTokenReserveFactor(ARC_TESTNET_MOCK_USDC, 10e16);
        _setInterestRateModelTokenReserveFactor(ARC_TESTNET_MOCK_USYC, 10e16);
        _setInterestRateModelTokenReserveFactor(ARC_TESTNET_MOCK_EURC, 10e16);
        vm.stopBroadcast();
    }
}

// RUN
// forge script SetInterestRateModelTokenReserveFactor --broadcast -vvv --verify
// forge script SetInterestRateModelTokenReserveFactor --broadcast -vvv
// forge script SetInterestRateModelTokenReserveFactor -vvv
