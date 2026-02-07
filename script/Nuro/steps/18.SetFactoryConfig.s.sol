// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetFactoryConfig is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        _setFactoryConfig();
        vm.stopBroadcast();
    }
}

// RUN
// forge script SetFactoryConfig --broadcast -vvv --verify
// forge script SetFactoryConfig --broadcast -vvv
// forge script SetFactoryConfig -vvv
