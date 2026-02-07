// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetPeers is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        // _setPeers(oappSrc, oappDst);
        _setPeers(ARC_TESTNET_USDC_OFT_ADAPTER, BASE_TESTNET_NUSDC_OFT_ADAPTER);
        _setPeers(ARC_TESTNET_USYC_OFT_ADAPTER, BASE_TESTNET_NUSYC_OFT_ADAPTER);
        _setPeers(ARC_TESTNET_EURC_OFT_ADAPTER, BASE_TESTNET_NEURC_OFT_ADAPTER);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/steps/5.SetPeers.s.sol:SetPeers --broadcast -vvv --skip-simulation
// forge script script/Nuro/steps/5.SetPeers.s.sol:SetPeers --broadcast -vvv
// forge script script/Nuro/steps/5.SetPeers.s.sol:SetPeers -vvv
