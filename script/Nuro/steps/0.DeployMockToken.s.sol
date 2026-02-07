// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script, console } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

/**
 * @title DeployMockToken
 * @notice Shortcut script to deploy individual mock tokens
 * @dev Usage: Set TOKEN_NAME environment variable or modify the tokenName variable
 */
contract DeployMockToken is Script, DeployCoreNuro {
    // Arc Ecosystem Tokens
    string public tokenName1 = "USDC"; // Main borrow token
    string public tokenName2 = "USYC"; // Yield-bearing collateral (US Yield Coin)
    string public tokenName3 = "EURC"; // Euro stablecoin

    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        // Deploy USDC (main borrow token)
        address deployedToken1 = _deployMockToken(tokenName1);
        console.log("address public constant %s_MOCK_%s = %s;", chainName, tokenName1, deployedToken1);

        // Deploy USYC (yield-bearing collateral)
        address deployedToken2 = _deployMockToken(tokenName2);
        console.log("address public constant %s_MOCK_%s = %s;", chainName, tokenName2, deployedToken2);

        address deployedToken3 = _deployMockToken(tokenName3);
        console.log("address public constant %s_MOCK_%s = %s;", chainName, tokenName3, deployedToken3);

        vm.stopBroadcast();
    }
}

// RUN EXAMPLES:
// Deploy:
// forge script DeployMockToken --broadcast -vvv --verify
// forge script DeployMockToken --broadcast -vvv
// forge script DeployMockToken -vvv

// For other tokens, modify the tokenName variable in the contract or create separate scripts:
// DeployMockUSDC.s.sol, DeployMockUSYC.s.sol, DeployMockEURC.s.sol
