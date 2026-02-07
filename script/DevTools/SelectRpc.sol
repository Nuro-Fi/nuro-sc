// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";

contract SelectRpc is Script {
    function selectRpc() public {
        // vm.createSelectFork(vm.rpcUrl("megaeth_testnet"));
        // vm.createSelectFork(vm.rpcUrl("eth_testnet"));
        vm.createSelectFork(vm.rpcUrl("kaia_testnet"));
    }

    function selectDstRpc() public {
        // vm.createSelectFork(vm.rpcUrl("eth_testnet"));
        vm.createSelectFork(vm.rpcUrl("base_testnet"));
    }
}
