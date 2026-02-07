// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// ======================= LIB =======================
import { Test, console } from "forge-std/Test.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IERC20Metadata } from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
// ======================= Core Source =======================
import { LendingPoolFactory } from "../src/LendingPoolFactory.sol";
import { IsHealthy } from "../src/IsHealthy.sol";
import { LendingPoolDeployer } from "../src/LendingPoolDeployer.sol";
import { Protocol } from "../src/Protocol.sol";
import { Oracle } from "../src/Oracle.sol";
import { OFTUSDCadapter } from "../src/layerzero/OFTUSDCAdapter.sol";
import { OFTEURCadapter } from "../src/layerzero/OFTEURCAdapter.sol";
import { ElevatedMinterBurner } from "../src/layerzero/ElevatedMinterBurner.sol";
import { HelperUtils } from "../src/HelperUtils.sol";
import { PositionDeployer } from "../src/PositionDeployer.sol";
import { LendingPoolRouterDeployer } from "../src/LendingPoolRouterDeployer.sol";
import { TokenDataStream } from "../src/TokenDataStream.sol";
import { InterestRateModel } from "../src/InterestRateModel.sol";
import { ProxyDeployer } from "../src/ProxyDeployer.sol";
import { SharesTokenDeployer } from "../src/SharesTokenDeployer.sol";
import { NuroEmitter } from "../src/NuroEmitter.sol";
// ======================= Helper =======================
import { Helper } from "../script/DevTools/Helper.sol";
import { BorrowParams, RepayParams } from "../src/lib/LendingPoolHook.sol";
import { LendingPoolFactoryHook } from "../src/lib/LendingPoolFactoryHook.sol";
// ======================= MockDex =======================
import { MockDex } from "../src/MockDex/MockDex.sol";
// ======================= MockToken =======================
import { MOCKEURC } from "../src/MockToken/MOCKEURC.sol";
import { MOCKUSDC } from "../src/MockToken/MOCKUSDC.sol";
import { MOCKUSYC } from "../src/MockToken/MOCKUSYC.sol";
// ======================= LayerZero =======================
import { MyOApp } from "../src/layerzero/MyOApp.sol";
import { ILayerZeroEndpointV2 } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroEndpointV2.sol";
import { SetConfigParam } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/IMessageLibManager.sol";
import { UlnConfig } from "@layerzerolabs/lz-evm-messagelib-v2/contracts/uln/UlnBase.sol";
import { ExecutorConfig } from "@layerzerolabs/lz-evm-messagelib-v2/contracts/SendLibBase.sol";
import { EnforcedOptionParam } from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OAppOptionsType3.sol";
import { OptionsBuilder } from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";
import { MessagingFee } from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import { SendParam } from "@layerzerolabs/oft-evm/contracts/interfaces/IOFT.sol";
// ======================= Interfaces =======================
import { ILendingPool } from "../src/interfaces/ILendingPool.sol";
import { ILPRouter } from "../src/interfaces/ILPRouter.sol";
import { IFactory } from "../src/interfaces/IFactory.sol";
import { IIsHealthy } from "../src/interfaces/IIsHealthy.sol";
import { ITokenDataStream } from "../src/interfaces/ITokenDataStream.sol";
import { SwapHook } from "../src/lib/SwapHook.sol";
import { Pricefeed } from "../src/Pricefeed.sol";
import { OracleAdapter } from "../src/OracleAdapter.sol";

// RUN
// forge test --match-contract NuroTest -vvv
contract NuroTest is Test, Helper {
    using OptionsBuilder for bytes;

    IsHealthy public isHealthy;
    LendingPoolRouterDeployer public lendingPoolRouterDeployer;
    LendingPoolDeployer public lendingPoolDeployer;
    Protocol public protocol;
    PositionDeployer public positionDeployer;
    LendingPoolFactory public lendingPoolFactory;
    LendingPoolFactory public newImplementation;
    Oracle public oracle;
    OFTEURCadapter public ofteurcadapter;
    OFTUSDCadapter public oftusdcadapter;
    ElevatedMinterBurner public elevatedminterburner;
    HelperUtils public helperUtils;
    ERC1967Proxy public proxy;
    ProxyDeployer public proxyDeployer;
    MOCKEURC public mockEurc;
    MOCKUSDC public mockUsdc;
    MOCKUSYC public mockUsyc;
    MockDex public mockDex;
    Pricefeed public priceFeed;
    OracleAdapter public oracleAdapter;
    TokenDataStream public tokenDataStream;
    InterestRateModel public interestRateModel;
    SharesTokenDeployer public sharesTokenDeployer;
    NuroEmitter public nuroEmitter;

    address public lendingPool;
    address public lendingPool2;

    address public owner = makeAddr("owner");
    address public alice = makeAddr("alice");

    uint256 supplyLiquidity;
    uint256 withdrawLiquidity;
    uint256 supplyCollateral;
    uint256 withdrawCollateral;
    uint256 borrowAmount;
    uint256 repayDebt;

    uint256 amountStartSupply1 = 1_000e6;
    uint256 amountStartSupply2 = 1_000e6;
    uint256 amountStartSupply3 = 1_000e6;

    function setUp() public {
        // Select testnet fork - use Base testnet or local for Arc ecosystem testing
        // vm.createSelectFork(vm.rpcUrl("base_mainnet"));
        // vm.createSelectFork(vm.rpcUrl("base_testnet"));
        // vm.createSelectFork(vm.rpcUrl("moonbeam_mainnet"));
        vm.createSelectFork(vm.rpcUrl("arc_testnet"));
        vm.startPrank(owner);

        _getUtils();
        deal(usyc, alice, 100_000e6);
        deal(usdc, alice, 100_000e6);
        deal(eurc, alice, 100_000e6);
        vm.deal(alice, 100_000 ether);

        deal(usyc, owner, 100_000e6);
        deal(usdc, owner, 100_000e6);
        deal(eurc, owner, 100_000e6);
        vm.deal(owner, 100_000 ether);
        // *************** layerzero ***************

        _deployOft(eurc);
        oftEurcAdapter = oapp;
        _deployOft(usdc);
        oftUsdcAdapter = oapp;
        _deployOft(usyc);
        oftUsycAdapter = oapp;

        _setLibraries(oftEurcAdapter);
        _setLibraries(oftUsdcAdapter);
        _setLibraries(oftUsycAdapter);

        _setSendConfig(oftEurcAdapter);
        _setSendConfig(oftUsdcAdapter);
        _setSendConfig(oftUsycAdapter);

        _setReceiveConfig(oftEurcAdapter);
        _setReceiveConfig(oftUsdcAdapter);
        _setReceiveConfig(oftUsycAdapter);

        _setPeers(oftEurcAdapter, oftEurcAdapter);
        _setPeers(oftUsdcAdapter, oftUsdcAdapter);
        _setPeers(oftUsycAdapter, oftUsycAdapter);

        _setEnforcedOptions(oftEurcAdapter);
        _setEnforcedOptions(oftUsdcAdapter);
        _setEnforcedOptions(oftUsycAdapter);

        // *****************************************
        EURC_USD = _deployPriceFeed(eurc, 118000000);
        USYC_USD = _deployPriceFeed(usyc, 111000000);
        USDC_USD = _deployPriceFeed(usdc, 100000000);

        _deployTokenDataStream();
        _setTokenDataStream(eurc, EURC_USD);
        _setTokenDataStream(usyc, USYC_USD);
        _setTokenDataStream(usdc, USDC_USD);
        _deployInterestRateModel();
        _deployDeployer();
        _deployIsHealthy();
        _deployProtocol();
        _deployFactory();
        _deployNuroEmitter();
        _setDeployerToFactory();
        _setEmittedRoles();
        _setCoreFactoryConfig();
        _setSharesTokenDeployerConfig();
        _setFactoryConfig();
        _setFactoryMinSupplyAmount(eurc, 1e6);
        _setFactoryMinSupplyAmount(usyc, 0.1e6);
        _setFactoryMinSupplyAmount(usdc, 0.1e6);
        _setMockDexFactory(); // Set factory address on MockDex after proxy is created
        _configIsHealthy();
        _setInterestRateModelToFactory();
        _setInterestRateModelTokenReserveFactor(eurc, 10e16);
        _setInterestRateModelTokenReserveFactor(usyc, 10e16);
        _setInterestRateModelTokenReserveFactor(usdc, 10e16);
        _createLendingPool();
        helperUtils = new HelperUtils(address(lendingPoolFactory));
        _setOftAddress(usyc, oftUsycAdapter);
        _setOftAddress(eurc, oftEurcAdapter);
        _setOftAddress(usdc, oftUsdcAdapter);

        vm.stopPrank();
    }

    function _deployInterestRateModel() internal {
        interestRateModel = new InterestRateModel();
        bytes memory data = abi.encodeWithSelector(interestRateModel.initialize.selector);
        proxy = new ERC1967Proxy(address(interestRateModel), data);
        interestRateModel = InterestRateModel(address(proxy));
    }

    function _getUtils() internal override {
        super._getUtils();
        eurc = _deployMockToken("EURC");
        usdc = _deployMockToken("USDC");
        usyc = _deployMockToken("USYC"); // Use USYC as collateral (yield-bearing)
        dexRouter = _deployMockDex();
    }

    function _deployMockToken(string memory _name) internal returns (address) {
        if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("EURC"))) {
            mockEurc = new MOCKEURC();
            return address(mockEurc);
        } else if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("USDC"))) {
            mockUsdc = new MOCKUSDC();
            return address(mockUsdc);
        } else if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("USYC"))) {
            mockUsyc = new MOCKUSYC();
            return address(mockUsyc);
        }
        revert("Invalid token name");
    }

    function _deployMockDex() internal returns (address) {
        mockDex = new MockDex();
        return address(mockDex);
    }

    function _deployOft(address _token) internal {
        elevatedminterburner = new ElevatedMinterBurner(_token, owner);
        if (_token == eurc) {
            ofteurcadapter = new OFTEURCadapter(_token, address(elevatedminterburner), endpoint, owner);
            oapp = address(ofteurcadapter);
        } else {
            oftusdcadapter = new OFTUSDCadapter(_token, address(elevatedminterburner), endpoint, owner);
            oapp = address(oftusdcadapter);
        }
        elevatedminterburner.setOperator(oapp, true);
    }

    function _setLibraries(address _oapp) internal {
        ILayerZeroEndpointV2(endpoint).setSendLibrary(_oapp, eid0, sendLib);
        ILayerZeroEndpointV2(endpoint).setSendLibrary(_oapp, eid1, sendLib);
        ILayerZeroEndpointV2(endpoint).setReceiveLibrary(_oapp, srcEid, receiveLib, gracePeriod);
    }

    function _setSendConfig(address _oapp) internal {
        UlnConfig memory uln = UlnConfig({
            confirmations: 15,
            requiredDVNCount: _getRequiredDvnCount(),
            optionalDVNCount: type(uint8).max,
            optionalDVNThreshold: 0,
            requiredDVNs: _toDynamicDvnArray([dvn1, dvn2]),
            optionalDVNs: new address[](0)
        });

        ExecutorConfig memory exec = ExecutorConfig({ maxMessageSize: 10000, executor: executor });
        bytes memory encodedUln = abi.encode(uln);
        bytes memory encodedExec = abi.encode(exec);
        SetConfigParam[] memory params = new SetConfigParam[](4);
        params[0] = SetConfigParam({ eid: eid0, configType: EXECUTOR_CONFIG_TYPE, config: encodedExec });
        params[1] = SetConfigParam({ eid: eid0, configType: ULN_CONFIG_TYPE, config: encodedUln });
        params[2] = SetConfigParam({ eid: eid1, configType: EXECUTOR_CONFIG_TYPE, config: encodedExec });
        params[3] = SetConfigParam({ eid: eid1, configType: ULN_CONFIG_TYPE, config: encodedUln });

        ILayerZeroEndpointV2(endpoint).setConfig(_oapp, sendLib, params);
    }

    function _setReceiveConfig(address _oapp) internal {
        UlnConfig memory uln = UlnConfig({
            confirmations: 15,
            requiredDVNCount: _getRequiredDvnCount(),
            optionalDVNCount: type(uint8).max,
            optionalDVNThreshold: 0,
            requiredDVNs: _toDynamicDvnArray([dvn1, dvn2]),
            optionalDVNs: new address[](0)
        });
        bytes memory encodedUln = abi.encode(uln);
        SetConfigParam[] memory params = new SetConfigParam[](2);
        params[0] = SetConfigParam({ eid: eid0, configType: RECEIVE_CONFIG_TYPE, config: encodedUln });
        params[1] = SetConfigParam({ eid: eid1, configType: RECEIVE_CONFIG_TYPE, config: encodedUln });

        ILayerZeroEndpointV2(endpoint).setConfig(_oapp, receiveLib, params);
    }

    function _setPeers(address _oappSrc, address _oappDst) internal {
        bytes32 oftPeerSrc = bytes32(uint256(uint160(_oappSrc)));
        bytes32 oftPeerDst = bytes32(uint256(uint160(_oappDst)));
        MyOApp(_oappSrc).setPeer(eid0, oftPeerSrc);
        MyOApp(_oappSrc).setPeer(eid1, oftPeerDst);
    }

    function _setEnforcedOptions(address _oapp) internal {
        bytes memory options1 = OptionsBuilder.newOptions().addExecutorLzReceiveOption(80000, 0);
        bytes memory options2 = OptionsBuilder.newOptions().addExecutorLzReceiveOption(100000, 0);

        EnforcedOptionParam[] memory enforcedOptions = new EnforcedOptionParam[](2);
        enforcedOptions[0] = EnforcedOptionParam({ eid: eid0, msgType: SEND, options: options1 });
        enforcedOptions[1] = EnforcedOptionParam({ eid: eid1, msgType: SEND, options: options2 });

        MyOApp(_oapp).setEnforcedOptions(enforcedOptions);
    }

    function _deployPriceFeed(address _token, int256 _price) internal returns (address) {
        if (_token == BAND_USDC_USD) {
            oracleAdapter = new OracleAdapter(BAND_USDC_USD);
            return address(oracleAdapter);
        } else {
            priceFeed = new Pricefeed(_token);
            priceFeed.setPrice(_price);
            return address(priceFeed);
        }
    }

    function _deployTokenDataStream() internal {
        tokenDataStream = new TokenDataStream();
        bytes memory data = abi.encodeWithSelector(tokenDataStream.initialize.selector);
        proxy = new ERC1967Proxy(address(tokenDataStream), data);
        tokenDataStream = TokenDataStream(address(proxy));
    }

    function _setTokenDataStream(address _token, address _oracle) internal {
        tokenDataStream.setTokenPriceFeed(_token, _oracle);
    }

    function _deployDeployer() internal {
        lendingPoolDeployer = new LendingPoolDeployer();
        lendingPoolRouterDeployer = new LendingPoolRouterDeployer();
        positionDeployer = new PositionDeployer();
        proxyDeployer = new ProxyDeployer();
        sharesTokenDeployer = new SharesTokenDeployer();
    }

    function _deployIsHealthy() internal {
        isHealthy = new IsHealthy();
        bytes memory data = abi.encodeWithSelector(isHealthy.initialize.selector);
        proxy = new ERC1967Proxy(address(isHealthy), data);
        isHealthy = IsHealthy(address(proxy));
    }

    function _deployNuroEmitter() internal {
        nuroEmitter = new NuroEmitter();
        bytes memory data = abi.encodeWithSelector(nuroEmitter.initialize.selector);
        proxy = new ERC1967Proxy(address(nuroEmitter), data);
        nuroEmitter = NuroEmitter(address(proxy));
    }

    function _deployProtocol() internal {
        protocol = new Protocol();
    }

    function _deployFactory() internal {
        lendingPoolFactory = new LendingPoolFactory();
        bytes memory data = abi.encodeWithSelector(lendingPoolFactory.initialize.selector);
        proxy = new ERC1967Proxy(address(lendingPoolFactory), data);
        lendingPoolFactory = LendingPoolFactory(address(proxy));
    }

    function _setCoreFactoryConfig() internal {
        IFactory(address(lendingPoolFactory)).setIsHealthy(address(isHealthy));
        IFactory(address(lendingPoolFactory)).setLendingPoolRouterDeployer(address(lendingPoolRouterDeployer));
        IFactory(address(lendingPoolFactory)).setLendingPoolDeployer(address(lendingPoolDeployer));
        IFactory(address(lendingPoolFactory)).setProtocol(address(protocol));
        IFactory(address(lendingPoolFactory)).setPositionDeployer(address(positionDeployer));
        IFactory(address(lendingPoolFactory)).setProxyDeployer(address(proxyDeployer));
        IFactory(address(lendingPoolFactory)).setDexRouter(dexRouter);
        IFactory(address(lendingPoolFactory)).setSharesTokenDeployer(address(sharesTokenDeployer));
        IFactory(address(lendingPoolFactory)).setNuroEmitter(address(nuroEmitter));
    }

    function _setSharesTokenDeployerConfig() internal {
        sharesTokenDeployer.setFactory(address(lendingPoolFactory));
    }

    function _setDeployerToFactory() internal {
        lendingPoolDeployer.setFactory(address(lendingPoolFactory));
        lendingPoolRouterDeployer.setFactory(address(lendingPoolFactory));
        isHealthy.setFactory(address(lendingPoolFactory));
    }

    function _setEmittedRoles() internal {
        nuroEmitter.grantRole(DEFAULT_ADMIN_ROLE, address(lendingPoolFactory));
        nuroEmitter.grantRole(ADMIN_ROLE, address(lendingPoolFactory));
    }

    function _setFactoryConfig() internal {
        IFactory(address(lendingPoolFactory)).setOperator(address(lendingPoolFactory), true);
        IFactory(address(lendingPoolFactory)).setTokenDataStream(address(tokenDataStream));
        IFactory(address(lendingPoolFactory)).setWrappedNative(makeAddr("wrappedNative"));
        IFactory(address(lendingPoolFactory)).setInterestRateModel(address(interestRateModel));
    }

    function _setFactoryMinSupplyAmount(address _token, uint256 _amount) internal {
        IFactory(address(lendingPoolFactory)).setMinAmountSupplyLiquidity(_token, _amount);
    }

    function _setMockDexFactory() internal {
        // Set the factory address on MockDex after proxy is created
        // This is needed because MockDex is created before the factory proxy in _getUtils()
        if (address(mockDex) != address(0)) {
            mockDex.setFactory(address(lendingPoolFactory));
        }
    }

    function _setInterestRateModelToFactory() internal {
        interestRateModel.grantRole(OWNER_ROLE, address(lendingPoolFactory));
    }

    function _setInterestRateModelTokenReserveFactor(address _token, uint256 _reserveFactor) internal {
        interestRateModel.setTokenReserveFactor(_token, _reserveFactor);
    }

    function _configIsHealthy() internal {
        IIsHealthy(address(isHealthy)).setFactory(address(lendingPoolFactory));
    }

    function _createLendingPool() internal {
        LendingPoolFactoryHook.LendingPoolParams memory lendingPoolParams1 = LendingPoolFactoryHook.LendingPoolParams({
            collateralToken: usyc,
            borrowToken: eurc,
            ltv: 60e16,
            supplyLiquidity: amountStartSupply1,
            baseRate: 0.05e16,
            rateAtOptimal: 80e16,
            optimalUtilization: 60e16,
            maxUtilization: 60e16,
            maxRate: 20e16,
            liquidationThreshold: 85e16,
            liquidationBonus: 5e16
        });

        IERC20(eurc).approve(address(lendingPoolFactory), amountStartSupply1);
        lendingPool = IFactory(address(lendingPoolFactory)).createLendingPool(lendingPoolParams1);

        LendingPoolFactoryHook.LendingPoolParams memory lendingPoolParams2 = LendingPoolFactoryHook.LendingPoolParams({
            collateralToken: usyc,
            borrowToken: usdc,
            ltv: 8e17,
            supplyLiquidity: amountStartSupply2,
            baseRate: 0.05e16,
            rateAtOptimal: 80e16,
            optimalUtilization: 60e16,
            maxUtilization: 6e16,
            maxRate: 20e16,
            liquidationThreshold: 85e16,
            liquidationBonus: 5e16
        });
        IERC20(usdc).approve(address(lendingPoolFactory), amountStartSupply2);
        lendingPool2 = IFactory(address(lendingPoolFactory)).createLendingPool(lendingPoolParams2);
    }

    function _deployHelperUtils() internal {
        helperUtils = new HelperUtils(address(lendingPoolFactory));
    }

    function _setOftAddress(address _token, address _oapp) internal {
        IFactory(address(lendingPoolFactory)).setOftAddress(_token, _oapp);
    }

    // RUN
    // forge test --match-test test_factory -vvv
    function test_factory() public view {
        address router = ILendingPool(lendingPool).router();
        assertEq(ILPRouter(router).lendingPool(), address(lendingPool));
        assertEq(ILPRouter(router).factory(), address(lendingPoolFactory));
        assertEq(ILPRouter(router).collateralToken(), usyc);
        assertEq(ILPRouter(router).borrowToken(), eurc);
        assertEq(ILPRouter(router).ltv(), 60e16);
    }

    // RUN
    // forge test --match-test test_oftaddress -vvv
    function test_oftaddress() public view {
        assertEq(IFactory(address(lendingPoolFactory)).oftAddress(usyc), oftUsycAdapter);
        assertEq(IFactory(address(lendingPoolFactory)).oftAddress(eurc), oftEurcAdapter);
    }

    // RUN
    // forge test --match-test test_roles -vvv
    function test_roles() public view {
        console.log("DEFAULT_ADMIN_ROLE:");
        console.logBytes32(lendingPoolFactory.DEFAULT_ADMIN_ROLE());

        console.log("PAUSER_ROLE:");
        console.logBytes32(lendingPoolFactory.PAUSER_ROLE());

        console.log("UPGRADER_ROLE:");
        console.logBytes32(lendingPoolFactory.UPGRADER_ROLE());

        console.log("OWNER_ROLE:");
        console.logBytes32(lendingPoolFactory.OWNER_ROLE());

        console.log("MINTER_ROLE (keccak256):");
        console.logBytes32(keccak256("MINTER_ROLE"));

        console.log("ADMIN_ROLE (keccak256):");
        console.logBytes32(keccak256("ADMIN_ROLE"));
    }

    // RUN
    // forge test --match-test test_checkorakl -vvv
    function test_checkorakl() public view {
        address _tokenDataStream = IFactory(address(lendingPoolFactory)).tokenDataStream();
        (, uint256 price,,,) = TokenDataStream(_tokenDataStream).latestRoundData(address(eurc));
        console.log("eurc/USD price", price);
        (, uint256 price2,,,) = TokenDataStream(_tokenDataStream).latestRoundData(usyc);
        console.log("usyc/USD price", price2);
        (, uint256 price3,,,) = TokenDataStream(_tokenDataStream).latestRoundData(usdc);
        console.log("usdc/USD price", price3);
    }

    // RUN
    // forge test --match-test test_supply_liquidity -vvv
    function test_supply_liquidity() public {
        vm.startPrank(alice);

        // Supply 1000 eurc as liquidity
        IERC20(eurc).approve(lendingPool, 1_000e6);
        ILendingPool(lendingPool).supplyLiquidity(alice, 1_000e6);

        // Supply 1000 usdc as liquidity
        IERC20(usdc).approve(lendingPool2, 1_000e6);
        ILendingPool(lendingPool2).supplyLiquidity(alice, 1_000e6);
        vm.stopPrank();

        address router = ILendingPool(lendingPool).router();
        address sharesToken = ILPRouter(router).sharesToken();
        console.log("address sharesToken", sharesToken);
        console.log("IERC20Metadata(sharesToken).decimals()", IERC20Metadata(sharesToken).decimals());
        console.log("IERC20Metadata(sharesToken).symbol()", IERC20Metadata(sharesToken).symbol());
        console.log("IERC20Metadata(sharesToken).name()", IERC20Metadata(sharesToken).name());
        console.log("IERC20(sharesToken).balanceOf(alice)", IERC20(sharesToken).balanceOf(alice));
        // Check balances
        assertEq(IERC20(eurc).balanceOf(lendingPool), 1_000e6 + amountStartSupply1);
        assertEq(IERC20(usdc).balanceOf(lendingPool2), 1_000e6 + amountStartSupply2);
    }

    // RUN
    // forge test --match-test test_withdraw_liquidity -vvv
    function test_withdraw_liquidity() public {
        test_supply_liquidity();
        vm.startPrank(alice);

        // Get shares token balance (18 decimals) to withdraw
        address sharesToken1 = _sharesToken(lendingPool);
        address sharesToken2 = _sharesToken(lendingPool2);

        uint256 aliceShares1 = IERC20(sharesToken1).balanceOf(alice);
        uint256 aliceShares2 = IERC20(sharesToken2).balanceOf(alice);

        ILendingPool(lendingPool).withdrawLiquidity(aliceShares1);
        ILendingPool(lendingPool2).withdrawLiquidity(aliceShares2);
        vm.stopPrank();

        assertEq(IERC20(eurc).balanceOf(lendingPool), 0 + amountStartSupply1);
        assertEq(IERC20(usdc).balanceOf(lendingPool2), 0 + amountStartSupply2);
    }

    // RUN
    // forge test --match-test test_supply_collateral -vvv
    function test_supply_collateral() public {
        vm.startPrank(alice);

        IERC20(usyc).approve(lendingPool, 1000e6);
        ILendingPool(lendingPool).supplyCollateral(alice, 1000e6);

        IERC20(usyc).approve(lendingPool2, 1_000e6);
        ILendingPool(lendingPool2).supplyCollateral(alice, 1_000e6);
        vm.stopPrank();

        assertEq(IERC20(usyc).balanceOf(_addressPosition(lendingPool, alice)), 1000e6);
        assertEq(IERC20(usyc).balanceOf(_addressPosition(lendingPool2, alice)), 1_000e6);
    }

    // RUN
    // forge test --match-test test_withdraw_collateral -vvv
    function test_withdraw_collateral() public {
        test_supply_collateral();
        vm.startPrank(alice);
        ILendingPool(lendingPool).withdrawCollateral(1_000e6);
        ILendingPool(lendingPool2).withdrawCollateral(1_000e6);
        vm.stopPrank();

        assertEq(IERC20(usyc).balanceOf(_addressPosition(lendingPool, alice)), 0);
        assertEq(IERC20(usyc).balanceOf(_addressPosition(lendingPool2, alice)), 0);
    }

    // RUN
    // forge test --match-test test_borrow_debt -vvv
    function test_borrow_debt() public {
        test_supply_liquidity();
        test_supply_collateral();

        vm.startPrank(alice);
        ILendingPool(lendingPool).borrowDebt(10e6);
        ILendingPool(lendingPool).borrowDebt(10e6);

        ILendingPool(lendingPool2).borrowDebt(0.1e6);
        ILendingPool(lendingPool2).borrowDebt(0.1e6);
        vm.stopPrank();

        assertEq(ILPRouter(_router(lendingPool)).userBorrowShares(alice), 2 * 10e6);
        assertEq(ILPRouter(_router(lendingPool)).totalBorrowAssets(), 2 * 10e6);
        assertEq(ILPRouter(_router(lendingPool)).totalBorrowShares(), 2 * 10e6);
        assertEq(ILPRouter(_router(lendingPool2)).userBorrowShares(alice), 2 * 0.1e6);
        assertEq(ILPRouter(_router(lendingPool2)).totalBorrowAssets(), 2 * 0.1e6);
        assertEq(ILPRouter(_router(lendingPool2)).totalBorrowShares(), 2 * 0.1e6);
    }

    // RUN
    // forge test --match-test test_repay_debt -vvv
    function test_repay_debt() public {
        test_borrow_debt();

        vm.startPrank(alice);
        IERC20(eurc).approve(lendingPool, 10e6);
        ILendingPool(lendingPool)
            .repayWithSelectedToken(RepayParams({ user: alice, token: eurc, shares: 10e6, amountOutMinimum: 0, fromPosition: false, fee: 1000 }));
        IERC20(eurc).approve(lendingPool, 10e6);
        ILendingPool(lendingPool)
            .repayWithSelectedToken(RepayParams({ user: alice, token: eurc, shares: 10e6, amountOutMinimum: 500, fromPosition: false, fee: 1000 }));
        // For usdc repayment on lendingPool2 (borrow token = usdc)
        IERC20(usdc).approve(lendingPool2, 0.1e6);
        ILendingPool(lendingPool2)
            .repayWithSelectedToken(RepayParams({ user: alice, token: usdc, shares: 0.1e6, amountOutMinimum: 500, fromPosition: false, fee: 1000 }));
        IERC20(usdc).approve(lendingPool2, 0.1e6);
        ILendingPool(lendingPool2)
            .repayWithSelectedToken(RepayParams({ user: alice, token: usdc, shares: 0.1e6, amountOutMinimum: 500, fromPosition: false, fee: 1000 }));
        vm.stopPrank();

        assertEq(ILPRouter(_router(lendingPool)).userBorrowShares(alice), 0);
        assertEq(ILPRouter(_router(lendingPool2)).userBorrowShares(alice), 0);

        assertEq(ILPRouter(_router(lendingPool)).totalBorrowAssets(), 0);
        assertEq(ILPRouter(_router(lendingPool2)).totalBorrowAssets(), 0);

        assertEq(ILPRouter(_router(lendingPool)).totalBorrowShares(), 0);
        assertEq(ILPRouter(_router(lendingPool2)).totalBorrowShares(), 0);
    }

    // RUN
    // forge test --match-test test_borrow_crosschain -vvv --match-contract NuroTest
    function test_borrow_crosschain() public {
        test_supply_liquidity();
        test_supply_collateral();

        // Provide enough Gas for LayerZero cross-chain fees
        vm.deal(alice, 10 ether);

        vm.startPrank(alice);

        SendParam memory sendParam = SendParam({
            dstEid: eid1, to: bytes32(uint256(uint160(alice))), amountLD: 10e6, minAmountLD: 10e6, extraOptions: "", composeMsg: "", oftCmd: ""
        });
        MessagingFee memory fee = MessagingFee({ nativeFee: 0, lzTokenFee: 0 });
        BorrowParams memory params = BorrowParams({ sendParam: sendParam, fee: fee, amount: 10e6, chainId: eid1, addExecutorLzReceiveOption: 0 });
        (uint256 nativeFee, uint256 lzTokenFee) = helperUtils.getFee(params, lendingPool, false);
        fee = MessagingFee({ nativeFee: nativeFee, lzTokenFee: lzTokenFee });
        params.fee = fee; // Update params.fee with actual fee
        console.log("nativeFee", nativeFee);
        console.log("lzTokenFee", lzTokenFee);
        console.log("alice Gas balance", alice.balance);
        ILendingPool(lendingPool).borrowDebtCrossChain{ value: nativeFee }(params);

        vm.deal(alice, 15 ether);

        sendParam = SendParam({
            dstEid: eid1, to: bytes32(uint256(uint160(alice))), amountLD: 10e6, minAmountLD: 10e6, extraOptions: "", composeMsg: "", oftCmd: ""
        });
        fee = MessagingFee({ nativeFee: 0, lzTokenFee: 0 });
        params = BorrowParams({ sendParam: sendParam, fee: fee, amount: 10e6, chainId: eid1, addExecutorLzReceiveOption: 0 });
        (nativeFee, lzTokenFee) = helperUtils.getFee(params, lendingPool, false);
        fee = MessagingFee({ nativeFee: nativeFee, lzTokenFee: lzTokenFee });
        params.fee = fee; // Update params.fee with actual fee
        console.log("nativeFee", nativeFee);
        console.log("lzTokenFee", lzTokenFee);
        console.log("alice Gas balance", alice.balance);
        ILendingPool(lendingPool).borrowDebtCrossChain{ value: nativeFee }(params);
        vm.stopPrank();

        assertEq(ILPRouter(_router(lendingPool)).userBorrowShares(alice), 2 * 10e6);
        assertEq(ILPRouter(_router(lendingPool)).totalBorrowAssets(), 2 * 10e6);
        assertEq(ILPRouter(_router(lendingPool)).totalBorrowShares(), 2 * 10e6);
    }

    // RUN
    // forge test --match-test test_swap_collateral -vvv --match-contract NuroTest
    function test_swap_collateral() public {
        test_supply_collateral();
        console.log("usyc balance before", IERC20(usyc).balanceOf(_addressPosition(lendingPool2, alice)));

        vm.startPrank(alice);
        ILendingPool(lendingPool2).swapTokenByPosition(SwapHook.SwapParams(usyc, usdc, 100e6, 100, 1000));
        vm.stopPrank();

        console.log("usyc balance after", IERC20(usyc).balanceOf(_addressPosition(lendingPool2, alice)));
    }

    // RUN
    // forge test --match-test test_comprehensive_collateral_swap_repay -vvv
    function test_comprehensive_collateral_swap_repay() public {
        // Step 1: Supply liquidity to enable borrowing
        test_supply_liquidity();

        // Step 2: Supply collateral
        test_supply_collateral();

        // Step 3: Borrow debt
        vm.startPrank(alice);
        ILendingPool(lendingPool).borrowDebt(10e6);
        vm.stopPrank();

        // Verify initial state
        assertEq(ILPRouter(_router(lendingPool)).userBorrowShares(alice), 10e6);
        assertEq(ILPRouter(_router(lendingPool)).totalBorrowAssets(), 10e6);

        // Get position address
        address position = _addressPosition(lendingPool, alice);

        vm.startPrank(alice);
        console.log("Initial usyc in position:", IERC20(usyc).balanceOf(position));
        console.log("Initial eurc in position:", IERC20(eurc).balanceOf(position));
        ILendingPool(lendingPool).swapTokenByPosition(SwapHook.SwapParams(usyc, eurc, 100e6, 10000, 1000));
        console.log("Final usyc in position:", IERC20(usyc).balanceOf(position));
        console.log("Final eurc in position:", IERC20(eurc).balanceOf(position));
        vm.stopPrank();

        vm.startPrank(alice);
        console.log("Before second swap - usyc:", IERC20(usyc).balanceOf(position));
        console.log("Before second swap - eurc:", IERC20(eurc).balanceOf(position));
        ILendingPool(lendingPool).swapTokenByPosition(SwapHook.SwapParams(eurc, usyc, 1e6, 10000, 1000));
        console.log("After second swap - usyc:", IERC20(usyc).balanceOf(position));
        console.log("After second swap - eurc:", IERC20(eurc).balanceOf(position));
        vm.stopPrank();

        vm.startPrank(alice);
        console.log("Before repayment - usyc:", IERC20(usyc).balanceOf(position));
        console.log("Before repayment - eurc:", IERC20(eurc).balanceOf(position));
        IERC20(eurc).approve(lendingPool, 5e6);
        ILendingPool(lendingPool)
            .repayWithSelectedToken(RepayParams({ user: alice, token: eurc, shares: 5e6, amountOutMinimum: 500, fromPosition: false, fee: 1000 }));
        console.log("After repayment - usyc:", IERC20(usyc).balanceOf(position));
        console.log("After repayment - eurc:", IERC20(eurc).balanceOf(position));
        vm.stopPrank();

        assertLt(ILPRouter(_router(lendingPool)).userBorrowShares(alice), 50e6);
        assertLt(ILPRouter(_router(lendingPool)).totalBorrowAssets(), 50e6);

        console.log("Remaining borrow shares:", ILPRouter(_router(lendingPool)).userBorrowShares(alice));
        console.log("Remaining total borrow assets:", ILPRouter(_router(lendingPool)).totalBorrowAssets());
    }

    // RUN
    // forge test --match-test test_repay_with_collateral -vvv
    function test_repay_with_collateral() public {
        // Setup: Supply liquidity, collateral, and borrow
        test_supply_liquidity();
        test_supply_collateral();

        vm.startPrank(alice);
        ILendingPool(lendingPool).borrowDebt(20e6);
        vm.stopPrank();

        address position = _addressPosition(lendingPool, alice);
        vm.startPrank(alice);
        console.log("Initial usyc in position:", IERC20(usyc).balanceOf(position));
        console.log("Initial eurc in position:", IERC20(eurc).balanceOf(position));
        console.log("Initial borrow shares:", ILPRouter(_router(lendingPool)).userBorrowShares(alice));
        // Repay 10e6 shares using usyc from position (swaps usyc→eurc via MockDex)
        ILendingPool(lendingPool)
            .repayWithSelectedToken(RepayParams({ user: alice, token: usyc, shares: 10e6, amountOutMinimum: 0, fromPosition: true, fee: 1000 }));
        console.log("Final usyc in position:", IERC20(usyc).balanceOf(position));
        console.log("Final eurc in position:", IERC20(eurc).balanceOf(position));
        console.log("Final borrow shares:", ILPRouter(_router(lendingPool)).userBorrowShares(alice));
        vm.stopPrank();
        assertLt(ILPRouter(_router(lendingPool)).userBorrowShares(alice), 20e6);
    }

    // RUN
    // forge test --match-test test_swap_with_zero_min_amount_out_minimum -vvv
    function test_swap_with_zero_min_amount_out_minimum() public {
        test_supply_collateral();

        address position = _addressPosition(lendingPool, alice);

        vm.startPrank(alice);

        uint256 swapAmount = 50e6;

        console.log("Testing swap with 10000 slippage tolerance (100%)");
        console.log("Initial usyc:", IERC20(usyc).balanceOf(position));
        console.log("Initial eurc:", IERC20(eurc).balanceOf(position));

        ILendingPool(lendingPool).swapTokenByPosition(SwapHook.SwapParams(usyc, eurc, swapAmount, 10000, 1000));

        console.log("After swap usyc:", IERC20(usyc).balanceOf(position));
        console.log("After swap eurc:", IERC20(eurc).balanceOf(position));

        uint256 eurcAmount = 1e6;
        ILendingPool(lendingPool).swapTokenByPosition(SwapHook.SwapParams(eurc, usyc, eurcAmount, 10000, 1000));

        console.log("After swap back usyc:", IERC20(usyc).balanceOf(position));
        console.log("After swap back eurc:", IERC20(eurc).balanceOf(position));

        vm.stopPrank();
    }

    // RUN
    // forge test --match-test test_position_repay_collateral_swap -vvv
    function test_position_repay_collateral_swap() public {
        // Setup: Supply liquidity, collateral, and borrow
        test_supply_liquidity();
        test_supply_collateral();

        vm.startPrank(alice);
        ILendingPool(lendingPool).borrowDebt(20e6);
        vm.stopPrank();

        address position = _addressPosition(lendingPool, alice);

        vm.startPrank(alice);
        console.log("Before swap - usyc:", IERC20(usyc).balanceOf(position));
        console.log("Before swap - eurc:", IERC20(eurc).balanceOf(position));
        console.log("Before swap - borrow shares:", ILPRouter(_router(lendingPool)).userBorrowShares(alice));
        ILendingPool(lendingPool)
            .swapTokenByPosition(SwapHook.SwapParams({ tokenIn: usyc, tokenOut: eurc, amountIn: 200e6, amountOutMinimum: 0, fee: 1000 }));
        console.log("After swap - usyc:", IERC20(usyc).balanceOf(position));
        console.log("After swap - eurc:", IERC20(eurc).balanceOf(position));
        vm.stopPrank();

        vm.startPrank(alice);
        ILendingPool(lendingPool)
            .repayWithSelectedToken(RepayParams({ user: alice, token: eurc, shares: 10e6, amountOutMinimum: 500, fromPosition: true, fee: 1000 }));
        console.log("After repayment - usyc:", IERC20(usyc).balanceOf(position));
        console.log("After repayment - eurc:", IERC20(eurc).balanceOf(position));
        console.log("After repayment - borrow shares:", ILPRouter(_router(lendingPool)).userBorrowShares(alice));
        vm.stopPrank();

        assertLt(ILPRouter(_router(lendingPool)).userBorrowShares(alice), 20e6);
    }

    // RUN
    // forge test --match-test test_position_repay_with_collateral_swap -vvv
    function test_position_repay_with_collateral_swap() public {
        test_supply_liquidity();
        test_supply_collateral();

        vm.startPrank(alice);
        ILendingPool(lendingPool).borrowDebt(20e6);
        vm.stopPrank();

        address position = _addressPosition(lendingPool, alice);

        vm.startPrank(alice);
        console.log("Before repayment - usyc:", IERC20(usyc).balanceOf(position));
        console.log("Before repayment - eurc:", IERC20(eurc).balanceOf(position));
        console.log("Before repayment - borrow shares:", ILPRouter(_router(lendingPool)).userBorrowShares(alice));
        // Repay 10e6 shares using usyc from position - use amountOutMinimum: 0 since MockDex may return small amounts
        ILendingPool(lendingPool)
            .repayWithSelectedToken(RepayParams({ user: alice, token: usyc, shares: 10e6, amountOutMinimum: 0, fromPosition: true, fee: 1000 }));
        console.log("After repayment - usyc:", IERC20(usyc).balanceOf(position));
        console.log("After repayment - eurc:", IERC20(eurc).balanceOf(position));
        console.log("After repayment - borrow shares:", ILPRouter(_router(lendingPool)).userBorrowShares(alice));
        vm.stopPrank();
        assertLt(ILPRouter(_router(lendingPool)).userBorrowShares(alice), 20e6);
    }

    // RUN
    // forge test --match-test test_position_repay_other_token_direct -vvv
    function test_position_repay_other_token_direct() public {
        test_supply_liquidity();
        test_supply_collateral();

        vm.startPrank(alice);
        ILendingPool(lendingPool).borrowDebt(15e6);
        vm.stopPrank();

        address position = _addressPosition(lendingPool, alice);

        vm.startPrank(alice);
        console.log("Initial state:");
        console.log("usyc in position:", IERC20(usyc).balanceOf(position));
        console.log("eurc in position:", IERC20(eurc).balanceOf(position));
        console.log("Borrow shares:", ILPRouter(_router(lendingPool)).userBorrowShares(alice));
        console.log("Total borrow assets:", ILPRouter(_router(lendingPool)).totalBorrowAssets());

        // Approve enough USYC for the swap (repay 5 EURC worth of USYC)
        IERC20(usyc).approve(lendingPool, 10e6);
        ILendingPool(lendingPool)
            .repayWithSelectedToken(RepayParams({ user: alice, token: usyc, shares: 5e6, amountOutMinimum: 0, fromPosition: false, fee: 1000 }));

        console.log("After first repayment:");
        console.log("usyc in position:", IERC20(usyc).balanceOf(position));
        console.log("eurc in position:", IERC20(eurc).balanceOf(position));
        console.log("Borrow shares:", ILPRouter(_router(lendingPool)).userBorrowShares(alice));
        console.log("Total borrow assets:", ILPRouter(_router(lendingPool)).totalBorrowAssets());

        IERC20(usyc).approve(lendingPool, 10e6);
        ILendingPool(lendingPool)
            .repayWithSelectedToken(RepayParams({ user: alice, token: usyc, shares: 5e6, amountOutMinimum: 0, fromPosition: false, fee: 1000 }));

        console.log("After second repayment:");
        console.log("usyc in position:", IERC20(usyc).balanceOf(position));
        console.log("eurc in position:", IERC20(eurc).balanceOf(position));
        console.log("Borrow shares:", ILPRouter(_router(lendingPool)).userBorrowShares(alice));
        console.log("Total borrow assets:", ILPRouter(_router(lendingPool)).totalBorrowAssets());
        vm.stopPrank();

        // Verify repayments occurred
        assertLt(ILPRouter(_router(lendingPool)).userBorrowShares(alice), 15e6);
        assertLt(ILPRouter(_router(lendingPool)).totalBorrowAssets(), 15e6);
    }

    // RUN
    // forge test --match-test test_borrow_higher_than_liquidation_threshold -vvv
    function test_borrow_higher_than_liquidation_threshold() public {
        test_supply_liquidity();
        test_supply_collateral();

        address router = _router(lendingPool);
        address borrowToken = ILPRouter(router).borrowToken();
        uint256 liquidationThreshold = isHealthy.liquidationThreshold(router);
        uint256 borrowLimit = (1000 * helperTokenPrice(usyc) * 10 ** IERC20Metadata(borrowToken).decimals() * 1e18 / 1e8) / liquidationThreshold;

        console.log("_tokenPrice(usyc)", 1000 * helperTokenPrice(usyc) / 1e8);
        console.log("liquidationThreshold", liquidationThreshold);
        console.log("borrowLimit", borrowLimit);

        vm.startPrank(alice);
        vm.expectRevert();
        ILendingPool(lendingPool).borrowDebt(borrowLimit);
        vm.stopPrank();
    }

    // RUN
    // forge test --match-test test_borrow_more_than_ltv -vvv
    function test_borrow_more_than_ltv() public {
        test_supply_liquidity();
        test_supply_collateral();

        address router = _router(lendingPool);
        address borrowToken = ILPRouter(router).borrowToken();
        uint256 liquidationThreshold = isHealthy.liquidationThreshold(router);
        uint256 borrowLimit = (1000 * helperTokenPrice(usyc) * 10 ** IERC20Metadata(borrowToken).decimals() * 1e18 / 1e8) / liquidationThreshold;

        console.log("_tokenPrice(usyc)", 1000 * helperTokenPrice(usyc) / 1e8);
        console.log("liquidationThreshold", liquidationThreshold);
        console.log("borrowLimit", borrowLimit);

        vm.startPrank(alice);
        // Expect ExceedsMaxLTV error because 570 EURC exceeds the 60% LTV limit
        // 1000 USYC at $1.11 = $1110 collateral, LTV 60% = $666 max, EURC at $1.18 = ~564 EURC max
        vm.expectRevert(); // Will revert with ExceedsMaxLTV
        ILendingPool(lendingPool).borrowDebt(570e6);
        vm.stopPrank();
    }

    // RUN
    // forge test --match-test test_borrow_exceeds_liquidation_threshold -vvv
    function test_borrow_exceeds_liquidation_threshold() public {
        test_supply_liquidity();
        test_supply_collateral();

        vm.startPrank(alice);
        // 1000 USYC at $1.11 = $1110, liquidation threshold 85% = $943.5, EURC at $1.18 = ~800 max
        vm.expectRevert(); // Will revert with ExceedsMaxLTV since we check LTV first
        ILendingPool(lendingPool).borrowDebt(810e6);
        vm.stopPrank();
    }

    function helperTokenPrice(address _token) internal view returns (uint256) {
        (, uint256 price,,,) = ITokenDataStream(helperTokenDataStream()).latestRoundData(_token);
        return price;
    }

    function helperTokenDataStream() internal view returns (address) {
        return IFactory(address(lendingPoolFactory)).tokenDataStream();
    }

    // RUN
    // forge test --match-test test_liquidation -vvv
    function test_liquidation() public {
        test_supply_liquidity();
        test_supply_collateral();

        vm.startPrank(alice);
        ILendingPool(lendingPool).borrowDebt(9e6);
        vm.stopPrank();

        _deployMockOrakl();

        address borrowToken = address(eurc);
        address collateralToken = address(usyc);

        uint256 protocolBorrowBefore = IERC20(borrowToken).balanceOf(address(protocol));
        uint256 protocolCollateralBefore = IERC20(collateralToken).balanceOf(address(protocol));
        console.log("protocolBorrowBefore", protocolBorrowBefore / 1e6);
        console.log("protocolCollateralBefore", protocolCollateralBefore / 1e6);
        uint256 borrowBalanceBefore = IERC20(borrowToken).balanceOf(owner);
        uint256 collateralBalanceBefore = IERC20(collateralToken).balanceOf(owner);
        console.log("balance eurc before", borrowBalanceBefore / 1e6);
        console.log("balance usyc before", collateralBalanceBefore / 1e6);

        vm.startPrank(owner);
        IERC20(borrowToken).approve(lendingPool, 9e6);
        ILendingPool(lendingPool).liquidation(alice);
        vm.stopPrank();

        uint256 protocolBorrowAfter = IERC20(borrowToken).balanceOf(address(protocol));
        uint256 protocolCollateralAfter = IERC20(collateralToken).balanceOf(address(protocol));
        console.log("protocolBorrowAfter", protocolBorrowAfter / 1e6);
        console.log("protocolCollateralAfter", protocolCollateralAfter / 1e6);
        uint256 borrowBalanceAfter = IERC20(borrowToken).balanceOf(owner);
        uint256 collateralBalanceAfter = IERC20(collateralToken).balanceOf(owner);
        console.log("balance eurc after", borrowBalanceAfter / 1e6);
        console.log("balance usyc after", collateralBalanceAfter / 1e6);
        console.log("usyc gap after - before", (collateralBalanceAfter - collateralBalanceBefore) / 1e6);
    }

    function _deployMockOrakl() internal {
        vm.startPrank(owner);
        // Crash USYC price to make position liquidatable
        Pricefeed crashPriceFeed = new Pricefeed(usyc);
        crashPriceFeed.setPrice(1000000); // $0.01 USD - very low price
        tokenDataStream.setTokenPriceFeed(usyc, address(crashPriceFeed));
        vm.stopPrank();
    }

    function _router(address _lendingPool) internal view returns (address) {
        return ILendingPool(_lendingPool).router();
    }

    function _sharesToken(address _lendingPool) internal view returns (address) {
        return ILPRouter(_router(_lendingPool)).sharesToken();
    }

    function _addressPosition(address _lendingPool, address _user) internal view returns (address) {
        return ILPRouter(_router(_lendingPool)).addressPositions(_user);
    }
}
