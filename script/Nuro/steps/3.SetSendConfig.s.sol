// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetSendConfig is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        _setSendConfig(ARC_TESTNET_USDC_OFT_ADAPTER);
        _setSendConfig(ARC_TESTNET_USYC_OFT_ADAPTER);
        _setSendConfig(ARC_TESTNET_EURC_OFT_ADAPTER);
        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/steps/3.SetSendConfig.s.sol:SetSendConfig --broadcast -vvv
// forge script script/Nuro/steps/3.SetSendConfig.s.sol:SetSendConfig -vvv
