// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// ======================= LIB =======================
import { Script, console } from "forge-std/Script.sol";
import { SelectRpc } from "../DevTools/SelectRpc.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import { IERC20Metadata } from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
// ======================= Core Source =======================
import { LendingPoolFactory } from "@src/LendingPoolFactory.sol";
import { IsHealthy } from "@src/IsHealthy.sol";
import { LendingPoolDeployer } from "@src/LendingPoolDeployer.sol";
import { Protocol } from "@src/Protocol.sol";
import { Oracle } from "@src/Oracle.sol";
import { OFTadapterUpgradeable } from "@src/layerzero/OFTadapterUpgradeable.sol";
import { OFTUSDCadapter } from "@src/layerzero/OFTUSDCAdapter.sol";
import { OFTEURCadapter } from "@src/layerzero/OFTEURCAdapter.sol";
import { ElevatedMinterBurner } from "@src/layerzero/ElevatedMinterBurner.sol";
import { HelperUtils } from "@src/HelperUtils.sol";
import { PositionDeployer } from "@src/PositionDeployer.sol";
import { LendingPoolRouterDeployer } from "@src/LendingPoolRouterDeployer.sol";
import { TokenDataStream } from "@src/TokenDataStream.sol";
import { Pricefeed } from "@src/Pricefeed.sol";
import { InterestRateModel } from "@src/InterestRateModel.sol";
import { ProxyDeployer } from "@src/ProxyDeployer.sol";
import { SharesTokenDeployer } from "@src/SharesTokenDeployer.sol";
import { NuroEmitter } from "@src/NuroEmitter.sol";
import { OracleAdapter } from "@src/OracleAdapter.sol";
// ======================= Helper =======================
import { Helper } from "../DevTools/Helper.sol";
// ======================= MockDex =======================
import { MockDex } from "@src/MockDex/MockDex.sol";
// ======================= MockToken =======================
import { MOCKEURC } from "@src/MockToken/MOCKEURC.sol";
import { MOCKUSDC } from "@src/MockToken/MOCKUSDC.sol";
import { MOCKUSYC } from "@src/MockToken/MOCKUSYC.sol";
// ======================= LayerZero =======================
import { MyOApp } from "@src/layerzero/MyOApp.sol";
import { ILayerZeroEndpointV2 } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroEndpointV2.sol";
import { SetConfigParam } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/IMessageLibManager.sol";
import { UlnConfig } from "@layerzerolabs/lz-evm-messagelib-v2/contracts/uln/UlnBase.sol";
import { ExecutorConfig } from "@layerzerolabs/lz-evm-messagelib-v2/contracts/SendLibBase.sol";
import { EnforcedOptionParam } from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OAppOptionsType3.sol";
import { OptionsBuilder } from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";
// ======================= Interfaces =======================
import { IFactory } from "@src/interfaces/IFactory.sol";
import { IIsHealthy } from "@src/interfaces/IIsHealthy.sol";
import { Orakl } from "@src/MockOrakl/Orakl.sol";

contract DeployCoreNuro is Script, SelectRpc, Helper {
    using OptionsBuilder for bytes;

    IsHealthy public isHealthy;
    LendingPoolRouterDeployer public lendingPoolRouterDeployer;
    LendingPoolDeployer public lendingPoolDeployer;
    Protocol public protocol;
    PositionDeployer public positionDeployer;
    LendingPoolFactory public lendingPoolFactory;
    Oracle public oracle;
    OFTadapterUpgradeable public oftadapter;
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
    Orakl public mockOrakl;
    TokenDataStream public tokenDataStream;
    InterestRateModel public interestRateModel;
    SharesTokenDeployer public sharesTokenDeployer;
    Pricefeed public priceFeed;
    OracleAdapter public oracleAdapter;
    NuroEmitter public nuroEmitter;

    address public owner = vm.envAddress("PUBLIC_KEY");
    uint256 public privateKey = vm.envUint("PRIVATE_KEY");

    function setUp() public {
        selectRpc();
    }

    function run() public virtual {
        vm.startPrank(owner);

        _getUtils();
        // *************** layerzero ***************
        _deployOft(address(0));
        _setLibraries(address(0));
        _setSendConfig(address(0));
        _setReceiveConfig(address(0));
        _setPeers(address(0), address(0));
        _setEnforcedOptions(address(0));

        // *****************************************

        _deployPriceFeed(address(0), 0);
        _deployTokenDataStream();
        _setTokenDataStream(address(0), address(0));
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
        _setMockDexFactory();
        _configIsHealthy();
        _setInterestRateModelToFactory();
        _setInterestRateModelTokenReserveFactor(address(0), 0);
        _deployHelperUtils();
        _setOftAddress(address(0), address(0));

        vm.stopPrank();
    }

    function _getUtils() internal override {
        super._getUtils();

        if (block.chainid == 5042002) {
            mockDex = MockDex(ARC_TESTNET_MOCK_DEX);
            tokenDataStream = TokenDataStream(ARC_TESTNET_TOKEN_DATA_STREAM);
            interestRateModel = InterestRateModel(ARC_TESTNET_INTEREST_RATE_MODEL);
            lendingPoolDeployer = LendingPoolDeployer(ARC_TESTNET_LENDING_POOL_DEPLOYER);
            lendingPoolRouterDeployer = LendingPoolRouterDeployer(ARC_TESTNET_LENDING_POOL_ROUTER_DEPLOYER);
            positionDeployer = PositionDeployer(ARC_TESTNET_POSITION_DEPLOYER);
            proxyDeployer = ProxyDeployer(ARC_TESTNET_PROXY_DEPLOYER);
            sharesTokenDeployer = SharesTokenDeployer(ARC_TESTNET_SHARES_TOKEN_DEPLOYER);
            isHealthy = IsHealthy(ARC_TESTNET_IS_HEALTHY);
            protocol = Protocol(payable(ARC_TESTNET_PROTOCOL));
            lendingPoolFactory = LendingPoolFactory(ARC_TESTNET_LENDING_POOL_FACTORY);
            nuroEmitter = NuroEmitter(ARC_TESTNET_NURO_EMITTER);
        } else if (block.chainid == 84532) {
            mockDex;
            tokenDataStream;
            interestRateModel;
            lendingPoolDeployer;
            lendingPoolRouterDeployer;
            positionDeployer;
            proxyDeployer;
            sharesTokenDeployer;
            isHealthy;
            protocol;
            lendingPoolFactory;
            nuroEmitter;
        } else {
            revert("Invalid chainid");
        }
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

    function _deployMockDex() internal virtual returns (address) {
        mockDex = new MockDex();
        console.log("address public constant %s_MOCK_DEX = %s;", chainName, address(mockDex));
        return address(mockDex);
    }

    function _deployPriceFeed(address _token, int256 _price) internal virtual returns (address) {
        if (_token == BAND_USDC_USD) {
            oracleAdapter = new OracleAdapter(BAND_USDC_USD);
            string memory tokenTicker = IERC20Metadata(_token).symbol();
            console.log("address public constant %s_%s_PRICE_FEED = %s;", chainName, tokenTicker, address(priceFeed));
            return address(oracleAdapter);
        } else {
            priceFeed = new Pricefeed(_token);
            priceFeed.setPrice(_price);
            string memory tokenTicker = IERC20Metadata(_token).symbol();
            console.log("address public constant %s_%s_PRICE_FEED = %s;", chainName, tokenTicker, address(priceFeed));
            return address(priceFeed);
        }
    }

    function _deployOft(address _token) internal virtual {
        if (_token == address(0)) revert("address can't be zero");
        elevatedminterburner = new ElevatedMinterBurner(_token, owner);
        string memory tokenTicker = IERC20Metadata(_token).symbol();
        console.log("address public constant %s_%s_ELEVATED_MINTER_BURNER = %s;", chainName, tokenTicker, address(elevatedminterburner));
        OFTadapterUpgradeable oftadapterImpl = new OFTadapterUpgradeable(_token, endpoint);
        console.log("address public constant %s_%s_OFT_ADAPTER_IMPLEMENTATION = %s;", chainName, tokenTicker, address(oftadapterImpl));
        bytes memory data = abi.encodeWithSelector(oftadapterImpl.initialize.selector, owner, address(elevatedminterburner));
        proxy = new ERC1967Proxy(address(oftadapterImpl), data);
        oftadapter = OFTadapterUpgradeable(address(proxy));
        console.log("address public constant %s_%s_OFT_ADAPTER = %s;", chainName, tokenTicker, address(oftadapter));
        oapp = address(oftadapter);
        elevatedminterburner.setOperator(oapp, true);
    }

    function _setLibraries(address _oapp) internal virtual {
        ILayerZeroEndpointV2(endpoint).setSendLibrary(_oapp, eid0, sendLib);
        ILayerZeroEndpointV2(endpoint).setSendLibrary(_oapp, eid1, sendLib);
        ILayerZeroEndpointV2(endpoint).setReceiveLibrary(_oapp, srcEid, receiveLib, gracePeriod);
    }

    function _setSendConfig(address _oapp) internal virtual {
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

    function _setReceiveConfig(address _oapp) internal virtual {
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

    function _setPeers(address _oappSrc, address _oappDst) internal virtual {
        bytes32 oftPeerSrc = bytes32(uint256(uint160(address(_oappSrc)))); // oappSrc
        bytes32 oftPeerDst = bytes32(uint256(uint160(address(_oappDst)))); // oappDst

        OFTadapterUpgradeable(_oappSrc).setPeer(eid0, oftPeerSrc);
        OFTadapterUpgradeable(_oappSrc).setPeer(eid1, oftPeerDst);
    }

    function _setEnforcedOptions(address _oapp) internal virtual {
        bytes memory options1 = OptionsBuilder.newOptions().addExecutorLzReceiveOption(80000, 0);
        bytes memory options2 = OptionsBuilder.newOptions().addExecutorLzReceiveOption(100000, 0);

        EnforcedOptionParam[] memory enforcedOptions = new EnforcedOptionParam[](2);
        enforcedOptions[0] = EnforcedOptionParam({ eid: eid0, msgType: SEND, options: options1 });
        enforcedOptions[1] = EnforcedOptionParam({ eid: eid1, msgType: SEND, options: options2 });

        MyOApp(_oapp).setEnforcedOptions(enforcedOptions);
    }

    function _deployTokenDataStream() internal virtual {
        tokenDataStream = new TokenDataStream();
        console.log("address public constant %s_TOKEN_DATA_STREAM_IMPLEMENTATION = %s;", chainName, address(tokenDataStream));
        bytes memory data = abi.encodeWithSelector(tokenDataStream.initialize.selector);
        proxy = new ERC1967Proxy(address(tokenDataStream), data);
        tokenDataStream = TokenDataStream(address(proxy));
        console.log("address public constant %s_TOKEN_DATA_STREAM = %s;", chainName, address(tokenDataStream));
    }

    function _setTokenDataStream(address _token, address _oracle) internal virtual {
        if (address(tokenDataStream) == address(0)) revert("TokenDataStream not deployed");
        if (_token == address(0)) revert("Token address cannot be zero");
        if (_oracle == address(0)) revert("Oracle address cannot be zero");
        tokenDataStream.setTokenPriceFeed(_token, _oracle);
    }

    function _deployInterestRateModel() internal virtual {
        interestRateModel = new InterestRateModel();
        console.log("address public constant %s_INTEREST_RATE_MODEL_IMPLEMENTATION = %s;", chainName, address(interestRateModel));
        bytes memory data = abi.encodeWithSelector(interestRateModel.initialize.selector);
        proxy = new ERC1967Proxy(address(interestRateModel), data);
        interestRateModel = InterestRateModel(address(proxy));
        console.log("address public constant %s_INTEREST_RATE_MODEL = %s;", chainName, address(interestRateModel));
    }

    function _deployDeployer() internal virtual {
        lendingPoolDeployer = new LendingPoolDeployer();
        console.log("address public constant %s_LENDING_POOL_DEPLOYER = %s;", chainName, address(lendingPoolDeployer));
        lendingPoolRouterDeployer = new LendingPoolRouterDeployer();
        console.log("address public constant %s_LENDING_POOL_ROUTER_DEPLOYER = %s;", chainName, address(lendingPoolRouterDeployer));
        positionDeployer = new PositionDeployer();
        console.log("address public constant %s_POSITION_DEPLOYER = %s;", chainName, address(positionDeployer));
        proxyDeployer = new ProxyDeployer();
        console.log("address public constant %s_PROXY_DEPLOYER = %s;", chainName, address(proxyDeployer));
        sharesTokenDeployer = new SharesTokenDeployer();
        console.log("address public constant %s_SHARES_TOKEN_DEPLOYER = %s;", chainName, address(sharesTokenDeployer));
    }

    function _deployIsHealthy() internal virtual {
        isHealthy = new IsHealthy();
        console.log("address public constant %s_IS_HEALTHY_IMPLEMENTATION = %s;", chainName, address(isHealthy));
        bytes memory data = abi.encodeWithSelector(isHealthy.initialize.selector);
        proxy = new ERC1967Proxy(address(isHealthy), data);
        isHealthy = IsHealthy(address(proxy));
        console.log("address public constant %s_IS_HEALTHY = %s;", chainName, address(isHealthy));
    }

    function _deployProtocol() internal virtual {
        protocol = new Protocol();
        console.log("address public constant %s_PROTOCOL = %s;", chainName, address(protocol));
    }

    function _deployFactory() internal virtual {
        lendingPoolFactory = new LendingPoolFactory();
        console.log("address public constant %s_LENDING_POOL_FACTORY_IMPLEMENTATION = %s;", chainName, address(lendingPoolFactory));
        bytes memory data = abi.encodeWithSelector(lendingPoolFactory.initialize.selector);
        proxy = new ERC1967Proxy(address(lendingPoolFactory), data);
        lendingPoolFactory = LendingPoolFactory(address(proxy));
        console.log("address public constant %s_LENDING_POOL_FACTORY = %s;", chainName, address(lendingPoolFactory));
    }

    function _deployNuroEmitter() internal {
        nuroEmitter = new NuroEmitter();
        console.log("address public constant %s_NURO_EMITTER_IMPLEMENTATION = %s;", chainName, address(nuroEmitter));
        bytes memory data = abi.encodeWithSelector(nuroEmitter.initialize.selector);
        proxy = new ERC1967Proxy(address(nuroEmitter), data);
        nuroEmitter = NuroEmitter(address(proxy));
        console.log("address public constant %s_NURO_EMITTER = %s;", chainName, address(nuroEmitter));
    }

    function _setCoreFactoryConfig() internal virtual {
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

    function _setFactoryChainIdToEid(uint256 _chainId, uint32 _chainIdToEid) internal virtual {
        IFactory(address(lendingPoolFactory)).setChainIdToEid(_chainId, _chainIdToEid);
    }

    function _setEmittedRoles() internal {
        nuroEmitter.grantRole(DEFAULT_ADMIN_ROLE, address(lendingPoolFactory));
        nuroEmitter.grantRole(ADMIN_ROLE, address(lendingPoolFactory));
    }

    function _setSharesTokenDeployerConfig() internal {
        sharesTokenDeployer.setFactory(address(lendingPoolFactory));
    }

    function _setDeployerToFactory() internal virtual {
        lendingPoolDeployer.setFactory(address(lendingPoolFactory));
        lendingPoolRouterDeployer.setFactory(address(lendingPoolFactory));
        isHealthy.setFactory(address(lendingPoolFactory));
    }

    function _setFactoryConfig() internal virtual {
        IFactory(address(lendingPoolFactory)).setOperator(address(lendingPoolFactory), true);
        IFactory(address(lendingPoolFactory)).setTokenDataStream(address(tokenDataStream));
        IFactory(address(lendingPoolFactory)).setInterestRateModel(address(interestRateModel));
    }

    function _setFactoryMinSupplyAmount(address _token, uint256 _amount) internal virtual {
        IFactory(address(lendingPoolFactory)).setMinAmountSupplyLiquidity(_token, _amount);
    }

    function _setMockDexFactory() internal virtual {
        // Set factory on MockDex for testnet chains
        if (address(mockDex) != address(0)) {
            mockDex.setFactory(address(lendingPoolFactory));
        }
    }

    function _setInterestRateModelToFactory() internal virtual {
        interestRateModel.grantRole(OWNER_ROLE, address(lendingPoolFactory));
    }

    function _setInterestRateModelTokenReserveFactor(address _token, uint256 _reserveFactor) internal virtual {
        interestRateModel.setTokenReserveFactor(_token, _reserveFactor);
    }

    function _configIsHealthy() internal virtual {
        IIsHealthy(address(isHealthy)).setFactory(address(lendingPoolFactory));
    }

    function _deployHelperUtils() internal virtual {
        helperUtils = new HelperUtils(address(lendingPoolFactory));
        console.log("address public constant %s_HELPER_UTILS = %s;", chainName, address(helperUtils));
    }

    function _setOftAddress(address _token, address _oapp) internal virtual {
        IFactory(address(lendingPoolFactory)).setOftAddress(_token, _oapp);
    }

    function _tokenDecimals(address _token) internal view virtual returns (uint8) {
        return IERC20Metadata(_token).decimals();
    }
}
