// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetPeers is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        // _setPeers(ETH_TESTNET_USDM_OFT_ADAPTER, MEGAETH_TESTNET_USDM_OFT_ADAPTER);

        // _setPeers(MEGAETH_TESTNET_USDM_OFT_ADAPTER, ETH_TESTNET_USDM_OFT_ADAPTER);
        // _setPeers(MEGAETH_TESTNET_USDM_OFT_ADAPTER, BASE_TESTNET_USDM_OFT_ADAPTER);

        // _setPeers(BASE_TESTNET_USDM_OFT_ADAPTER, MEGAETH_TESTNET_USDM_OFT_ADAPTER);
        // _setPeers(MEGAETH_TESTNET_USDM_OFT_ADAPTER, BASE_TESTNET_USDM_OFT_ADAPTER);

        _setPeers(KAIA_TESTNET_USDC_OFT_ADAPTER, BASE_TESTNET_NUSDC_OFT_ADAPTER);
        _setPeers(KAIA_TESTNET_USDT_OFT_ADAPTER, BASE_TESTNET_NUSDT_OFT_ADAPTER);
        _setPeers(KAIA_TESTNET_WETH_OFT_ADAPTER, BASE_TESTNET_NWETH_OFT_ADAPTER);
        _setPeers(KAIA_TESTNET_WKAIA_OFT_ADAPTER, BASE_TESTNET_NWKAIA_OFT_ADAPTER);
        _setPeers(KAIA_TESTNET_BTCB_OFT_ADAPTER, BASE_TESTNET_NBTCB_OFT_ADAPTER);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/steps/5.SetPeers.s.sol:SetPeers --broadcast -vvv --skip-simulation
// forge script script/Nuro/steps/5.SetPeers.s.sol:SetPeers --broadcast -vvv
// forge script script/Nuro/steps/5.SetPeers.s.sol:SetPeers -vvv
