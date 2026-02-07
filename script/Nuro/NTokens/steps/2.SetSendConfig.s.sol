// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { DeployNTokens } from "../DeployNTokens.s.sol";

contract SetSendConfig is DeployNTokens {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        _setSendConfig(BASE_TESTNET_NUSDC_OFT_ADAPTER);
        _setSendConfig(BASE_TESTNET_NUSYC_OFT_ADAPTER);
        _setSendConfig(BASE_TESTNET_NEURC_OFT_ADAPTER);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/NTokens/steps/2.SetSendConfig.s.sol:SetSendConfig --broadcast -vvv --skip-simulation
// forge script script/Nuro/NTokens/steps/2.SetSendConfig.s.sol:SetSendConfig --broadcast -vvv
// forge script script/Nuro/NTokens/steps/2.SetSendConfig.s.sol:SetSendConfig -vvv
