// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { DeployNTokens } from "../DeployNTokens.s.sol";

contract DeployOft is DeployNTokens {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        // Deploy OFT Adapter - Update with the token address
        _deployOft(BASE_TESTNET_NUSDC);
        _deployOft(BASE_TESTNET_NUSYC);
        _deployOft(BASE_TESTNET_NEURC);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/NTokens/steps/0.1.DeployOft.s.sol:DeployOft --broadcast -vvv --verify --verifier etherscan --etherscan-api-key $ETHERSCAN_API_KEY
// forge script script/Nuro/NTokens/steps/0.1.DeployOft.s.sol:DeployOft --broadcast -vvv --verify
// forge script script/Nuro/NTokens/steps/0.1.DeployOft.s.sol:DeployOft --broadcast -vvv
// forge script script/Nuro/NTokens/steps/0.1.DeployOft.s.sol:DeployOft -vvv
