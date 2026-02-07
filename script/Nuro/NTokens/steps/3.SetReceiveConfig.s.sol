// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { DeployNTokens } from "../DeployNTokens.s.sol";

contract SetReceiveConfig is DeployNTokens {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        // Update with the OApp address - use address(0) to use the default oapp from Helper
        _setReceiveConfig(BASE_TESTNET_NUSDC_OFT_ADAPTER);
        _setReceiveConfig(BASE_TESTNET_NUSDT_OFT_ADAPTER);
        _setReceiveConfig(BASE_TESTNET_NWETH_OFT_ADAPTER);
        _setReceiveConfig(BASE_TESTNET_NBTCB_OFT_ADAPTER);
        _setReceiveConfig(BASE_TESTNET_NWKAIA_OFT_ADAPTER);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/NTokens/steps/3.SetReceiveConfig.s.sol:SetReceiveConfig --broadcast -vvv --skip-simulation
// forge script script/Nuro/NTokens/steps/3.SetReceiveConfig.s.sol:SetReceiveConfig --broadcast -vvv
// forge script script/Nuro/NTokens/steps/3.SetReceiveConfig.s.sol:SetReceiveConfig -vvv
