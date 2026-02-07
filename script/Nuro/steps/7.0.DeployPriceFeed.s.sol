// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract DeployPriceFeed is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        _deployPriceFeed(ARC_TESTNET_MOCK_USDC, 1e8);
        _deployPriceFeed(ARC_TESTNET_MOCK_USYC, 111000000);
        _deployPriceFeed(ARC_TESTNET_MOCK_EURC, 118000000);
        vm.stopBroadcast();
    }
}

// RUN
// forge script DeployPriceFeed --broadcast -vvv --verify
// forge script DeployPriceFeed --broadcast -vvv
// forge script DeployPriceFeed -vvv
