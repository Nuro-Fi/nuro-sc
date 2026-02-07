// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetLibraries is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        _setLibraries(ARC_TESTNET_USDC_OFT_ADAPTER);
        _setLibraries(ARC_TESTNET_USYC_OFT_ADAPTER);
        _setLibraries(ARC_TESTNET_EURC_OFT_ADAPTER);
        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/steps/2.SetLibraries.s.sol:SetLibraries --broadcast -vvv
// forge script script/Nuro/steps/2.SetLibraries.s.sol:SetLibraries -vvv
