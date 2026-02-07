// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetReceiveConfig is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        _setReceiveConfig(ARC_TESTNET_USDC_OFT_ADAPTER);
        _setReceiveConfig(ARC_TESTNET_USYC_OFT_ADAPTER);
        _setReceiveConfig(ARC_TESTNET_EURC_OFT_ADAPTER);
        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/steps/4.SetReceiveConfig.s.sol:SetReceiveConfig --broadcast -vvv
// forge script script/Nuro/steps/4.SetReceiveConfig.s.sol:SetReceiveConfig -vvv
