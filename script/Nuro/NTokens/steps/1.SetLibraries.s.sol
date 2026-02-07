// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { DeployNTokens } from "../DeployNTokens.s.sol";

contract SetLibraries is DeployNTokens {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        _setLibraries(BASE_TESTNET_NUSDC_OFT_ADAPTER);
        _setLibraries(BASE_TESTNET_NUSYC_OFT_ADAPTER);
        _setLibraries(BASE_TESTNET_NEURC_OFT_ADAPTER);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/NTokens/steps/1.SetLibraries.s.sol:SetLibraries --broadcast -vvv --skip-simulation
// forge script script/Nuro/NTokens/steps/1.SetLibraries.s.sol:SetLibraries --broadcast -vvv
// forge script script/Nuro/NTokens/steps/1.SetLibraries.s.sol:SetLibraries -vvv
