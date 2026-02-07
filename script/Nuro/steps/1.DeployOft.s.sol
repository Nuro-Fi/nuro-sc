// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { DeployCoreNuro } from "../DeployCoreNuro.s.sol";

contract DeployOFT is Script, DeployCoreNuro {
    function run() public override {
        vm.startBroadcast(privateKey);
        _getUtils();

        // _deployOft(ETH_TESTNET_MOCK_USDM);
        // _deployOft(MEGAETH_TESTNET_MOCK_USDM);
        // _deployOft(BASE_TESTNET_MOCK_USDM);
        // _deployOft(usdc);
        // _deployOft(usdt);
        // _deployOft(wNative);
        // _deployOft(weth);
        // _deployOft(wbtc);
        _deployOft(KAIA_TESTNET_MOCK_USDC);
        _deployOft(KAIA_TESTNET_MOCK_USDT);
        _deployOft(KAIA_TESTNET_MOCK_WETH);
        _deployOft(KAIA_TESTNET_MOCK_BTCB);
        _deployOft(KAIA_TESTNET_MOCK_WKAIA);

        vm.stopBroadcast();
    }
}

// RUN
// forge script script/Nuro/steps/1.DeployOft.s.sol:DeployOFT --broadcast -vvv --verify --skip-simulation --verifier blockscout --verifier-url https://megaeth-testnet-v2.blockscout.com/api/
// forge script script/Nuro/steps/1.DeployOft.s.sol:DeployOFT --broadcast -vvv --verify --verifier etherscan --etherscan-api-key $ETHERSCAN_API_KEY
// forge script script/Nuro/steps/1.DeployOft.s.sol:DeployOFT --broadcast -vvv --verify --verifier oklink --verifier-url https://www.oklink.com/api/v5/explorer/contract/verify-source-code-plugin/kaia
// forge script script/Nuro/steps/1.DeployOft.s.sol:DeployOFT --broadcast -vvv --verify
// forge script script/Nuro/steps/1.DeployOft.s.sol:DeployOFT --broadcast -vvv
// forge script script/Nuro/steps/1.DeployOft.s.sol:DeployOFT -vvv
