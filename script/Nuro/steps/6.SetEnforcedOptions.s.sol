// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetEnforcedOptions is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        // _setEnforcedOptions(ETH_TESTNET_USDM_OFT_ADAPTER);
        // _setEnforcedOptions(MEGAETH_TESTNET_USDM_OFT_ADAPTER);
        // _setEnforcedOptions(BASE_TESTNET_USDM_OFT_ADAPTER);

        _setEnforcedOptions(KAIA_TESTNET_USDT_OFT_ADAPTER);
        _setEnforcedOptions(KAIA_TESTNET_USDC_OFT_ADAPTER);
        _setEnforcedOptions(KAIA_TESTNET_WETH_OFT_ADAPTER);
        _setEnforcedOptions(KAIA_TESTNET_WKAIA_OFT_ADAPTER);
        _setEnforcedOptions(KAIA_TESTNET_BTCB_OFT_ADAPTER);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/steps/6.SetEnforcedOptions.s.sol:SetEnforcedOptions --broadcast -vvv --skip-simulation
// forge script script/Nuro/steps/6.SetEnforcedOptions.s.sol:SetEnforcedOptions --broadcast -vvv
// forge script script/Nuro/steps/6.SetEnforcedOptions.s.sol:SetEnforcedOptions -vvv
