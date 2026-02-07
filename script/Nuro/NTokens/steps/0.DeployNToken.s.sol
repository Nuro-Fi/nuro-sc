// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { DeployNTokens } from "../DeployNTokens.s.sol";

contract DeployNToken is DeployNTokens {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        // Deploy NToken - Update the parameters as needed
        _deployNToken("Nuro USDC", "nUSDC", 6);
        _deployNToken("Nuro USDT", "nUSDT", 6);
        _deployNToken("Nuro WETH", "nWETH", 18);
        _deployNToken("Nuro BTCB", "nBTCB", 8);
        _deployNToken("Nuro WKAIA", "nWKAIA", 18);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/NTokens/steps/0.DeployNToken.s.sol:DeployNToken --broadcast -vvv --verify
// forge script script/Nuro/NTokens/steps/0.DeployNToken.s.sol:DeployNToken --broadcast -vvv --verify --verifier etherscan --etherscan-api-key $ETHERSCAN_API_KEY
// forge script script/Nuro/NTokens/steps/0.DeployNToken.s.sol:DeployNToken --broadcast -vvv --skip-simulation --verify --verifier blockscout --verifier-url https://megaeth-testnet-v2.blockscout.com/api/
// forge script script/Nuro/NTokens/steps/0.DeployNToken.s.sol:DeployNToken --broadcast -vvv
// forge script script/Nuro/NTokens/steps/0.DeployNToken.s.sol:DeployNToken -vvv
