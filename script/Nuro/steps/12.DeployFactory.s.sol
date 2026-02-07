// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract DeployFactory is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        _deployFactory();
        vm.stopBroadcast();
    }
}

// RUN
// forge script DeployFactory --broadcast -vvv --verify
// forge script DeployFactory --broadcast -vvv
// forge script DeployFactory -vvv
