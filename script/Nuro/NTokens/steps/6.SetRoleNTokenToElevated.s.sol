// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { DeployNTokens } from "../DeployNTokens.s.sol";

contract SetRoleNTokenToElevated is DeployNTokens {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        // Grant MINTER_ROLE to ElevatedMinterBurner contracts
        _setRoleNTokenToElevated(BASE_TESTNET_NUSDC, BASE_TESTNET_NUSDC_ELEVATED_MINTER_BURNER);
        _setRoleNTokenToElevated(BASE_TESTNET_NUSDT, BASE_TESTNET_NUSDT_ELEVATED_MINTER_BURNER);
        _setRoleNTokenToElevated(BASE_TESTNET_NWETH, BASE_TESTNET_NWETH_ELEVATED_MINTER_BURNER);
        _setRoleNTokenToElevated(BASE_TESTNET_NBTCB, BASE_TESTNET_NBTCB_ELEVATED_MINTER_BURNER);
        _setRoleNTokenToElevated(BASE_TESTNET_NWKAIA, BASE_TESTNET_NWKAIA_ELEVATED_MINTER_BURNER);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/NTokens/steps/6.SetRoleNTokenToElevated.s.sol:SetRoleNTokenToElevated --broadcast -vvv --skip-simulation
// forge script script/Nuro/NTokens/steps/6.SetRoleNTokenToElevated.s.sol:SetRoleNTokenToElevated --broadcast -vvv
// forge script script/Nuro/NTokens/steps/6.SetRoleNTokenToElevated.s.sol:SetRoleNTokenToElevated -vvv
