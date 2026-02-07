// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract DeployNuroEmitter is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        _deployNuroEmitter();
        vm.stopBroadcast();
    }
}

// RUN
// forge script DeployNuroEmitter --broadcast -vvv --verify
// forge script DeployNuroEmitter --broadcast -vvv
// forge script DeployNuroEmitter -vvv
