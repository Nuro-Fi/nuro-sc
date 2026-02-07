// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract DeployOFT is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        _deployOft(ARC_TESTNET_MOCK_USDC);
        _deployOft(ARC_TESTNET_MOCK_USYC);
        _deployOft(ARC_TESTNET_MOCK_EURC);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/steps/1.DeployOft.s.sol:DeployOFT --broadcast -vvv --verify
// forge script script/Nuro/steps/1.DeployOft.s.sol:DeployOFT --broadcast -vvv
// forge script script/Nuro/steps/1.DeployOft.s.sol:DeployOFT -vvv
