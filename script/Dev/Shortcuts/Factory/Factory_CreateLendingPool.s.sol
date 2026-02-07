// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { LendingPoolFactory } from "@src/LendingPoolFactory.sol";
import { LendingPoolFactoryHook } from "@src/lib/LendingPoolFactoryHook.sol";
import { Helper } from "@script/DevTools/Helper.sol";
import { MOCKEURC } from "@src/MockToken/MOCKEURC.sol";
import { SelectRpc } from "@script/DevTools/SelectRpc.sol";

contract Factory_CreateLendingPool is Script, Helper, SelectRpc {
    LendingPoolFactory public factory;
    MOCKEURC public mockUsdt;

    address public owner = vm.envAddress("PUBLIC_KEY");
    uint256 public privateKey = vm.envUint("PRIVATE_KEY");

    // Configurable addresses via environment variables
    address public mockUsdtAddress = vm.envOr("MOCK_USDT", address(0));
    address public mockWethAddress = vm.envOr("MOCK_WETH", address(0));
    address public factoryAddress = vm.envOr("LENDING_POOL_FACTORY", address(0));

    function setUp() public {
        selectRpc();
    }

    function run() public {
        require(mockUsdtAddress != address(0), "MOCK_USDT env not set");
        require(mockWethAddress != address(0), "MOCK_WETH env not set");
        require(factoryAddress != address(0), "LENDING_POOL_FACTORY env not set");

        mockUsdt = MOCKEURC(mockUsdtAddress);
        factory = LendingPoolFactory(payable(factoryAddress));

        vm.startBroadcast(privateKey);
        mockUsdt.mint(owner, 1e6);
        mockUsdt.approve(address(factory), 1e6);
        LendingPoolFactoryHook.LendingPoolParams memory lendingPoolParams = LendingPoolFactoryHook.LendingPoolParams({
            collateralToken: mockWethAddress,
            borrowToken: mockUsdtAddress,
            ltv: 70e16,
            supplyLiquidity: 1e6,
            baseRate: 0.05e16,
            rateAtOptimal: 6e16,
            optimalUtilization: 80e16,
            maxUtilization: 100e16,
            maxRate: 20e16,
            liquidationThreshold: 75e16,
            liquidationBonus: 10e16
        });
        factory.createLendingPool(lendingPoolParams);
        vm.stopBroadcast();
    }
}

// RUN
// forge script Factory_CreateLendingPool --broadcast -vvv
// forge script Factory_CreateLendingPool -vvv
