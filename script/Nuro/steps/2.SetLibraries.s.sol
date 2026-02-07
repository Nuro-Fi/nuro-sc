// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetLibraries is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        // _setLibraries(ETH_TESTNET_USDM_OFT_ADAPTER);
        // _setLibraries(MEGAETH_TESTNET_USDM_OFT_ADAPTER);
        // _setLibraries(BASE_TESTNET_USDM_OFT_ADAPTER);
        _setLibraries(KAIA_TESTNET_USDT_OFT_ADAPTER);
        _setLibraries(KAIA_TESTNET_USDC_OFT_ADAPTER);
        _setLibraries(KAIA_TESTNET_WETH_OFT_ADAPTER);
        _setLibraries(KAIA_TESTNET_BTCB_OFT_ADAPTER);
        _setLibraries(KAIA_TESTNET_WKAIA_OFT_ADAPTER);
        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/steps/2.SetLibraries.s.sol:SetLibraries --broadcast -vvv --skip-simulation
// forge script script/Nuro/steps/2.SetLibraries.s.sol:SetLibraries --broadcast -vvv
// forge script script/Nuro/steps/2.SetLibraries.s.sol:SetLibraries -vvv
