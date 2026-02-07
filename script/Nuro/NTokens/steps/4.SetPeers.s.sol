// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { DeployNTokens } from "../DeployNTokens.s.sol";

contract SetPeers is DeployNTokens {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        _setPeers(BASE_TESTNET_NUSDC_OFT_ADAPTER, KAIA_TESTNET_USDC_OFT_ADAPTER);
        _setPeers(BASE_TESTNET_NUSDT_OFT_ADAPTER, KAIA_TESTNET_USDT_OFT_ADAPTER);
        _setPeers(BASE_TESTNET_NWETH_OFT_ADAPTER, KAIA_TESTNET_WETH_OFT_ADAPTER);
        _setPeers(BASE_TESTNET_NBTCB_OFT_ADAPTER, KAIA_TESTNET_BTCB_OFT_ADAPTER);
        _setPeers(BASE_TESTNET_NWKAIA_OFT_ADAPTER, KAIA_TESTNET_WKAIA_OFT_ADAPTER);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/NTokens/steps/4.SetPeers.s.sol:SetPeers --broadcast -vvv --skip-simulation
// forge script script/Nuro/NTokens/steps/4.SetPeers.s.sol:SetPeers --broadcast -vvv
// forge script script/Nuro/NTokens/steps/4.SetPeers.s.sol:SetPeers -vvv
