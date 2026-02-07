// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { DeployNTokens } from "../DeployNTokens.s.sol";

contract SetRoleNTokenToElevated is DeployNTokens {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        _setRoleNTokenToElevated(BASE_TESTNET_NUSDC, BASE_TESTNET_NUSDC_ELEVATED_MINTER_BURNER);
        _setRoleNTokenToElevated(BASE_TESTNET_NUSYC, BASE_TESTNET_NUSYC_ELEVATED_MINTER_BURNER);
        _setRoleNTokenToElevated(BASE_TESTNET_NEURC, BASE_TESTNET_NEURC_ELEVATED_MINTER_BURNER);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/NTokens/steps/6.SetRoleNTokenToElevated.s.sol:SetRoleNTokenToElevated --broadcast -vvv --skip-simulation
// forge script script/Nuro/NTokens/steps/6.SetRoleNTokenToElevated.s.sol:SetRoleNTokenToElevated --broadcast -vvv
// forge script script/Nuro/NTokens/steps/6.SetRoleNTokenToElevated.s.sol:SetRoleNTokenToElevated -vvv
