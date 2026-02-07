// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { DeployNTokens } from "../DeployNTokens.s.sol";

contract SetReceiveConfig is DeployNTokens {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        _setReceiveConfig(BASE_TESTNET_NUSDC_OFT_ADAPTER);
        _setReceiveConfig(BASE_TESTNET_NUSYC_OFT_ADAPTER);
        _setReceiveConfig(BASE_TESTNET_NEURC_OFT_ADAPTER);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/NTokens/steps/3.SetReceiveConfig.s.sol:SetReceiveConfig --broadcast -vvv --skip-simulation
// forge script script/Nuro/NTokens/steps/3.SetReceiveConfig.s.sol:SetReceiveConfig --broadcast -vvv
// forge script script/Nuro/NTokens/steps/3.SetReceiveConfig.s.sol:SetReceiveConfig -vvv
