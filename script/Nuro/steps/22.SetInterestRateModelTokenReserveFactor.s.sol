// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetInterestRateModelTokenReserveFactor is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        _setInterestRateModelTokenReserveFactor(KAIA_TESTNET_MOCK_USDT, 10e16);
        _setInterestRateModelTokenReserveFactor(address(1), 10e16);
        _setInterestRateModelTokenReserveFactor(KAIA_TESTNET_MOCK_WETH, 10e16);
        _setInterestRateModelTokenReserveFactor(KAIA_TESTNET_MOCK_WKAIA, 10e16);
        vm.stopBroadcast();
    }
}

// RUN
// forge script SetInterestRateModelTokenReserveFactor --broadcast -vvv --verify --verifier oklink --verifier-url https://www.oklink.com/api/v5/explorer/contract/verify-source-code-plugin/kaia
// forge script SetInterestRateModelTokenReserveFactor --broadcast -vvv --verify
// forge script SetInterestRateModelTokenReserveFactor --broadcast -vvv
// forge script SetInterestRateModelTokenReserveFactor -vvv
