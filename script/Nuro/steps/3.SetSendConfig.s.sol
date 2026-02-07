// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetSendConfig is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        // _setSendConfig(ETH_TESTNET_USDM_OFT_ADAPTER);
        // _setSendConfig(MEGAETH_TESTNET_USDM_OFT_ADAPTER);
        // _setSendConfig(BASE_TESTNET_USDM_OFT_ADAPTER);
        _setSendConfig(KAIA_TESTNET_USDC_OFT_ADAPTER);
        _setSendConfig(KAIA_TESTNET_USDT_OFT_ADAPTER);
        _setSendConfig(KAIA_TESTNET_WETH_OFT_ADAPTER);
        _setSendConfig(KAIA_TESTNET_WKAIA_OFT_ADAPTER);
        _setSendConfig(KAIA_TESTNET_BTCB_OFT_ADAPTER);
        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/steps/3.SetSendConfig.s.sol:SetSendConfig --broadcast -vvv --skip-simulation
// forge script script/Nuro/steps/3.SetSendConfig.s.sol:SetSendConfig --broadcast -vvv
// forge script script/Nuro/steps/3.SetSendConfig.s.sol:SetSendConfig -vvv
