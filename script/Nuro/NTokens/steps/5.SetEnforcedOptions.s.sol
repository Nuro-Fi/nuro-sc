// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { DeployNTokens } from "../DeployNTokens.s.sol";

contract SetEnforcedOptions is DeployNTokens {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        // _setEnforcedOptions(oapp);
        _setEnforcedOptions(BASE_TESTNET_NUSDC_OFT_ADAPTER);
        _setEnforcedOptions(BASE_TESTNET_NUSYC_OFT_ADAPTER);
        _setEnforcedOptions(BASE_TESTNET_NEURC_OFT_ADAPTER);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/NTokens/steps/5.SetEnforcedOptions.s.sol:SetEnforcedOptions --broadcast -vvv --skip-simulation
// forge script script/Nuro/NTokens/steps/5.SetEnforcedOptions.s.sol:SetEnforcedOptions --broadcast -vvv
// forge script script/Nuro/NTokens/steps/5.SetEnforcedOptions.s.sol:SetEnforcedOptions -vvv
