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
    string public tokenName1 = "USDT";
    string public tokenName2 = "USDC";
    string public tokenName3 = "WETH";
    string public tokenName4 = "WBTC";
    string public tokenName5 = "WKAIA";
    string public tokenName6 = "USDm";
    string public tokenName7 = "BTCB";

    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        // address deployedToken1 = _deployMockToken(tokenName1);
        // console.log("address public constant %s_MOCK_%s = %s;", chainName, tokenName1, deployedToken1);

        address deployedToken2 = _deployMockToken(tokenName2);
        console.log("address public constant %s_MOCK_%s = %s;", chainName, tokenName2, deployedToken2);

        // address deployedToken3 = _deployMockToken(tokenName3);
        // console.log("address public constant %s_MOCK_%s = %s;", chainName, tokenName3, deployedToken3);

        // address deployedToken4 = _deployMockToken(tokenName4);
        // console.log("address public constant %s_MOCK_%s = %s;", chainName, tokenName4, deployedToken4);

        // address deployedToken5 = _deployMockToken(tokenName5);
        // console.log("address public constant %s_MOCK_%s = %s;", chainName, tokenName5, deployedToken5);

        // address deployedToken6 = _deployMockToken(tokenName6);
        // console.log("address public constant %s_MOCK_%s = %s;", chainName, tokenName6, deployedToken6);

        address deployedToken7 = _deployMockToken(tokenName7);
        console.log("address public constant %s_MOCK_%s = %s;", chainName, tokenName7, deployedToken7);

        vm.stopBroadcast();
    }
}

// RUN EXAMPLES:
// Deploy:
// forge script DeployMockToken --broadcast -vvv --verify --skip-simulation --verifier blockscout --verifier-url https://megaeth-testnet-v2.blockscout.com/api/
// forge script DeployMockToken --broadcast -vvv --verify --verifier etherscan --etherscan-api-key $ETHERSCAN_API_KEY
// forge script DeployMockToken --broadcast -vvv --verify
// forge script DeployMockToken --broadcast -vvv
// forge script DeployMockToken -vvv

// For other tokens, modify the tokenName variable in the contract or create separate scripts:
// DeployMockUSDC.s.sol, DeployMockWMNT.s.sol, DeployMockWETH.s.sol
