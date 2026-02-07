// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetOftAddress is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        _setOftAddress(ARC_TESTNET_MOCK_USDC, ARC_TESTNET_USDC_OFT_ADAPTER);
        _setOftAddress(ARC_TESTNET_MOCK_USYC, ARC_TESTNET_USYC_OFT_ADAPTER);
        _setOftAddress(ARC_TESTNET_MOCK_EURC, ARC_TESTNET_EURC_OFT_ADAPTER);
        vm.stopBroadcast();
    }
}

// RUN
// forge script SetOftAddress --broadcast -vvv --verify
// forge script SetOftAddress --broadcast -vvv
// forge script SetOftAddress -vvv
