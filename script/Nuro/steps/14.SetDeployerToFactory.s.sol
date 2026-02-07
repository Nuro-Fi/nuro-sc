// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetDeployerToFactory is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        _setDeployerToFactory();
        vm.stopBroadcast();
    }
}

// RUN
// forge script SetDeployerToFactory --broadcast -vvv --verify --verifier oklink --verifier-url https://www.oklink.com/api/v5/explorer/contract/verify-source-code-plugin/kaia
// forge script SetDeployerToFactory --broadcast -vvv --verify
// forge script SetDeployerToFactory --broadcast -vvv
// forge script SetDeployerToFactory -vvv
