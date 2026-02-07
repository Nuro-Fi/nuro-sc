// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetMockDexFactory is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        _setMockDexFactory();
        vm.stopBroadcast();
    }
}

// RUN
// forge script SetMockDexFactory --broadcast -vvv --verify
// forge script SetMockDexFactory --broadcast -vvv
// forge script SetMockDexFactory -vvv
