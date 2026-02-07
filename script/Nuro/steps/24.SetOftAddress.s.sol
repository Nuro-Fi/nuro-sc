// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract SetOftAddress is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();
        _setOftAddress(KAIA_TESTNET_MOCK_USDT, KAIA_TESTNET_USDT_OFT_ADAPTER);
        _setOftAddress(KAIA_TESTNET_MOCK_USDC, KAIA_TESTNET_USDC_OFT_ADAPTER);
        _setOftAddress(KAIA_TESTNET_MOCK_WETH, KAIA_TESTNET_WETH_OFT_ADAPTER);
        _setOftAddress(KAIA_TESTNET_MOCK_BTCB, KAIA_TESTNET_BTCB_OFT_ADAPTER);
        _setOftAddress(KAIA_TESTNET_MOCK_WKAIA, KAIA_TESTNET_WKAIA_OFT_ADAPTER);
        vm.stopBroadcast();
    }
}

// RUN
// forge script SetOftAddress --broadcast -vvv --verify --verifier oklink --verifier-url https://www.oklink.com/api/v5/explorer/contract/verify-source-code-plugin/kaia
// forge script SetOftAddress --broadcast -vvv --verify
// forge script SetOftAddress --broadcast -vvv
// forge script SetOftAddress -vvv
