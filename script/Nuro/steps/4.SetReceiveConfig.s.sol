// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetReceiveConfig is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        // _setReceiveConfig(ETH_TESTNET_USDM_OFT_ADAPTER);
        // _setReceiveConfig(MEGAETH_TESTNET_USDM_OFT_ADAPTER);
        // _setReceiveConfig(BASE_TESTNET_USDM_OFT_ADAPTER);

        _setReceiveConfig(KAIA_TESTNET_USDT_OFT_ADAPTER);
        _setReceiveConfig(KAIA_TESTNET_USDC_OFT_ADAPTER);
        _setReceiveConfig(KAIA_TESTNET_WETH_OFT_ADAPTER);
        _setReceiveConfig(KAIA_TESTNET_WKAIA_OFT_ADAPTER);
        _setReceiveConfig(KAIA_TESTNET_BTCB_OFT_ADAPTER);
        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/steps/4.SetReceiveConfig.s.sol:SetReceiveConfig --broadcast -vvv --skip-simulation
// forge script script/Nuro/steps/4.SetReceiveConfig.s.sol:SetReceiveConfig --broadcast -vvv
// forge script script/Nuro/steps/4.SetReceiveConfig.s.sol:SetReceiveConfig -vvv
