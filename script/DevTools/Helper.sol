// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title Helper
 * @notice Configuration helper for NuroFi cross-chain deployment on Arc ecosystem
 * @dev Supports Arc (hub), Base, and other EVM chains via LayerZero
 */
contract Helper {
    // Testnet Endpoints
    address public constant BASE_TESTNET_LZ_ENDPOINT = 0x6EDCE65403992e310A62460808c4b910D972f10f;
    address public constant ARC_TESTNET_LZ_ENDPOINT = 0x6C7Ab2202C98C4227C5c46f1417D81144DA716Ff;

    // Testnet Send Libraries
    address public constant BASE_TESTNET_SEND_LIB = 0xC1868e054425D378095A003EcbA3823a5D0135C9;
    address public constant ARC_TESTNET_SEND_LIB = 0xd682ECF100f6F4284138AA925348633B0611Ae21;

    // Testnet Receive Libraries
    address public constant BASE_TESTNET_RECEIVE_LIB = 0x12523de19dc41c91F7d2093E0CFbB76b17012C8d;
    address public constant ARC_TESTNET_RECEIVE_LIB = 0xcF1B0F4106B0324F96fEfcC31bA9498caa80701C;

    // Testnet Endpoint IDs
    uint32 public constant BASE_TESTNET_EID = 40245;
    uint32 public constant ARC_TESTNET_EID = 40434;

    // Testnet DVNs
    address public constant BASE_TESTNET_DVN1 = 0xe1a12515F9AB2764b887bF60B923Ca494EBbB2d6; // LayerZeroLabs
    address public constant BASE_TESTNET_DVN2 = 0xe1a12515F9AB2764b887bF60B923Ca494EBbB2d6; // LayerZeroLabs

    address public constant ARC_TESTNET_DVN1 = 0x88B27057A9e00c5F05DDa29241027afF63f9e6e0; // LayerZeroLabs
    address public constant ARC_TESTNET_DVN2 = 0x88B27057A9e00c5F05DDa29241027afF63f9e6e0; // LayerZeroLabs

    // Testnet Executors
    address public constant BASE_TESTNET_EXECUTOR = 0x8A3D588D9f6AC041476b094f97FF94ec30169d3D;
    address public constant ARC_TESTNET_EXECUTOR = 0x9dB9Ca3305B48F196D18082e91cB64663b13d014;

    // Testnet Chain IDs
    uint256 public constant BASE_TESTNET_CHAIN_ID = 84532;
    uint256 public constant ARC_TESTNET_CHAIN_ID = 5042002;

    // ==================== ORACLE PRICE FEEDS ====================
    // Note: These will need to be updated for Arc mainnet when available

    // Placeholder oracle addresses (to be configured per deployment)
    address public USDC_USD = address(0); // Configure per chain
    address public USYC_USD = address(0); // Configure per chain
    address public EURC_USD = address(0); // Configure per chain

    address public BAND_USDC_USD = 0x8c064bCf7C0DA3B3b090BAbFE8f3323534D84d68; // Configure per chain (BAND Protocol)

    // ==================== ACCESS CONTROL ROLES ====================

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    // ==================== TOKEN ADDRESSES (SET PER DEPLOYMENT) ====================
    // address public constant ARC_TESTNET_MOCK_USDC = 0xdF05e9AbF64dA281B3cBd8aC3581022eC4841FB2; // (BAND PROTOCOL)
    address public constant ARC_TESTNET_MOCK_USDC = 0x8c064bCf7C0DA3B3b090BAbFE8f3323534D84d68; // (BAND Protocol)
    address public constant ARC_TESTNET_MOCK_USYC = 0x04C37dc1b538E00b31e6bc883E16d97cD7937a10; // (custom oracle)
    address public constant ARC_TESTNET_MOCK_EURC = 0x15858A57854BBf0DF60A737811d50e1Ee785f9bc; // (custom oracle)

    address public constant ARC_TESTNET_USDC_ELEVATED_MINTER_BURNER = 0x4Ba8D8083e7F3652CCB084C32652e68566E9Ef23;
    address public constant ARC_TESTNET_USDC_OFT_ADAPTER_IMPLEMENTATION = 0x007F735Fd070DeD4B0B58D430c392Ff0190eC20F;
    address public constant ARC_TESTNET_USDC_OFT_ADAPTER = 0x5C368bd6cE77b2ca47B4ba791fCC1f1645591c84;
    address public constant ARC_TESTNET_USYC_ELEVATED_MINTER_BURNER = 0xC327486Db1417644f201d84414bbeA6C8A948bef;
    address public constant ARC_TESTNET_USYC_OFT_ADAPTER_IMPLEMENTATION = 0xb3B458299864487520d3B0cEDf9F5cfF2629a27B;
    address public constant ARC_TESTNET_USYC_OFT_ADAPTER = 0x39926DA4905f5Edb956F5dB5F2e2FF044E0882B2;
    address public constant ARC_TESTNET_EURC_ELEVATED_MINTER_BURNER = 0xa8e2E14AA272d360235B9444f8214bA5fa2A2888;
    address public constant ARC_TESTNET_EURC_OFT_ADAPTER_IMPLEMENTATION = 0x6Ab9c1AAf4f8172138086AA72be2AB8aA6579dbd;
    address public constant ARC_TESTNET_EURC_OFT_ADAPTER = 0x886ba47579DC4f5DcB53ffd20429089A7788C072;

    address public constant ARC_TESTNET_USDC_PRICE_FEED = 0xBdC661EECb0dcFB940A34008e0190c9103013C41;
    address public constant ARC_TESTNET_USYC_PRICE_FEED = 0x02a66B51Fc24E08535a6Cfe1e11E532D8A089212;
    address public constant ARC_TESTNET_EURC_PRICE_FEED = 0xb516190F8192CCEaF8B1DA7D9Ca1C6C75b9F410c;

    address public constant ARC_TESTNET_MOCK_DEX = 0x5E6AAd48fB0a23E9540A5EAFfb87846E8ef04C42;

    address public constant ARC_TESTNET_TOKEN_DATA_STREAM_IMPLEMENTATION = 0xc3be8ab4CA0cefE3119A765b324bBDF54a16A65b;
    address public constant ARC_TESTNET_TOKEN_DATA_STREAM = 0xE2e025Ff8a8adB2561e3C631B5a03842b9A1Ae88;

    address public constant ARC_TESTNET_INTEREST_RATE_MODEL_IMPLEMENTATION = 0x718b1b67f287571767452CC7d24BCD95c63DbA13;
    address public constant ARC_TESTNET_INTEREST_RATE_MODEL = 0x46dA9F76c20a752132dDaefD2B14870e0A152D71;

    address public constant ARC_TESTNET_LENDING_POOL_DEPLOYER = 0xC72f2eb4A97F19ecD0C10b5201676a10B6D8bB67;
    address public constant ARC_TESTNET_LENDING_POOL_ROUTER_DEPLOYER = 0x46638aD472507482B7D5ba45124E93D16bc97eCE;
    address public constant ARC_TESTNET_POSITION_DEPLOYER = 0xdbbb07E1AE9D0F23Ac6dA9BDDA3Dff96fcA73650;
    address public constant ARC_TESTNET_PROXY_DEPLOYER = 0x3703a1DA99a2BDf2d8ce57802aaCb20fb546Ff12;
    address public constant ARC_TESTNET_SHARES_TOKEN_DEPLOYER = 0x4900409aabeCd5DE4ab22D61cdEc4b7478783806;

    address public constant ARC_TESTNET_IS_HEALTHY_IMPLEMENTATION = 0xB9B3A1baA8CF4C5Cd6b4d132eD7B0cBe05646f6f;
    address public constant ARC_TESTNET_IS_HEALTHY = 0xbd3B8bbE94a301B96c5207F8bE17Ed1cd3236550;

    address public constant ARC_TESTNET_PROTOCOL = 0x394239573079a46e438ea6D118Fd96d37A61f270;

    address public constant ARC_TESTNET_LENDING_POOL_FACTORY_IMPLEMENTATION = 0x54f6Ff27093FC45c5A39083C3Ef0260D25012Be3;
    address public constant ARC_TESTNET_LENDING_POOL_FACTORY = 0xb0FCA55167f94D0f515877C411E0deb904321761;

    address public constant ARC_TESTNET_NURO_EMITTER_IMPLEMENTATION = 0xa971CD2714fbCc9A942b09BC391a724Df9338206;
    address public constant ARC_TESTNET_NURO_EMITTER = 0xec32CC0267002618c339274C18AD48D2Bf2A9c7e;

    address public constant ARC_TESTNET_HELPER_UTILS = 0x6c454d20F4CB5f69e2D66693fA8deE931D7432dF;

    address public constant BASE_TESTNET_NUSDC_IMPLEMENTATION = 0x21483Bcde6E19FDb5acc1375C443eBB17147a69a;
    address public constant BASE_TESTNET_NUSDC = 0xc773715a19aCCbC2C7Fde4416CC59Eb55c009D02;
    address public constant BASE_TESTNET_NUSYC_IMPLEMENTATION = 0x48b3f901D040796f9cDA37469FC5436fcA711366;
    address public constant BASE_TESTNET_NUSYC = 0xE70269A183e244CC90959AE4A8a3230b6519E11D;
    address public constant BASE_TESTNET_NEURC_IMPLEMENTATION = 0xaCBc1cE1908b9434222E60D6cfEd9E011a386220;
    address public constant BASE_TESTNET_NEURC = 0xDB5603AD7D60DAF731ccdC48bC4db66Fb85A3f79;

    address public constant BASE_TESTNET_NUSDC_ELEVATED_MINTER_BURNER = 0xDbcdd37a885201f368D105EBaF1A8962204351a4;
    address public constant BASE_TESTNET_NUSDC_OFT_ADAPTER_IMPLEMENTATION = 0x374427909212B29fcC3Ffe8e7920a190a3031CB8;
    address public constant BASE_TESTNET_NUSDC_OFT_ADAPTER = 0x0c832FeE16d5A8BC99B888E16D3712E6BEf96Fb7;
    address public constant BASE_TESTNET_NUSYC_ELEVATED_MINTER_BURNER = 0x3f4776f560770Fc9B7C4eE15b7Bf4f1cE02Ab64e;
    address public constant BASE_TESTNET_NUSYC_OFT_ADAPTER_IMPLEMENTATION = 0xF8Af5114ad19422e059797CA2515FeBD8Bc06bd1;
    address public constant BASE_TESTNET_NUSYC_OFT_ADAPTER = 0x8f388874B0195CA2F9De3E85D17EE3EfA0058B7c;
    address public constant BASE_TESTNET_NEURC_ELEVATED_MINTER_BURNER = 0x009F50A69cE2Fbc3806824C81c0D9865A4b758f7;
    address public constant BASE_TESTNET_NEURC_OFT_ADAPTER_IMPLEMENTATION = 0x2B3353553FE334BdAeDCC77A3642Fb8CbeD56Fd5;
    address public constant BASE_TESTNET_NEURC_OFT_ADAPTER = 0x427cc6C2359E2a2AbaBF7A45Ce66Ba82Bb77B282;

    address public eurc;
    address public usdc;
    address public usyc;

    // Oracle adapter addresses
    address public eurcUsdAdapter;
    address public usycUsdAdapter;
    address public usdcUsdAdapter;

    // OFT adapter addresses
    address public oftEurcAdapter;
    address public oftUsdcAdapter;
    address public oftUsycAdapter;

    // DEX router
    address public dexRouter;

    // ==================== LAYERZERO CONFIG VARIABLES ====================

    address endpoint;
    address oapp;
    address oapp2;
    address oapp3;
    address sendLib;
    address receiveLib;
    uint32 srcEid;
    uint32 gracePeriod;

    address dvn1;
    address dvn2;
    address executor;

    uint32 eid0;
    uint32 eid1;
    uint32 constant EXECUTOR_CONFIG_TYPE = 1;
    uint16 constant SEND = 1;
    uint32 constant ULN_CONFIG_TYPE = 2;
    uint32 constant RECEIVE_CONFIG_TYPE = 2;

    string public chainName;

    // ==================== CHAIN CONFIGURATION ====================

    function _getUtils() internal virtual {
        if (block.chainid == ARC_TESTNET_CHAIN_ID) {
            chainName = "ARC_TESTNET";
            endpoint = ARC_TESTNET_LZ_ENDPOINT;
            sendLib = ARC_TESTNET_SEND_LIB;
            receiveLib = ARC_TESTNET_RECEIVE_LIB;
            srcEid = ARC_TESTNET_EID;
            gracePeriod = uint32(0);
            dvn1 = ARC_TESTNET_DVN1;
            dvn2 = ARC_TESTNET_DVN2;
            executor = ARC_TESTNET_EXECUTOR;
            eid0 = ARC_TESTNET_EID;
            eid1 = BASE_TESTNET_EID;
        } else if (block.chainid == BASE_TESTNET_CHAIN_ID) {
            chainName = "BASE_TESTNET";
            endpoint = BASE_TESTNET_LZ_ENDPOINT;
            sendLib = BASE_TESTNET_SEND_LIB;
            receiveLib = BASE_TESTNET_RECEIVE_LIB;
            srcEid = BASE_TESTNET_EID;
            gracePeriod = uint32(0);
            dvn1 = BASE_TESTNET_DVN1;
            dvn2 = BASE_TESTNET_DVN2;
            executor = BASE_TESTNET_EXECUTOR;
            eid0 = BASE_TESTNET_EID;
            eid1 = ARC_TESTNET_EID;
        }
    }

    /**
     * @notice Check if current chain requires single DVN configuration
     * @dev Returns true for testnet chains that need only 1 DVN
     * @return bool True if chain requires single DVN
     */
    function _isSingleDvnChain() internal view returns (bool) {
        return block.chainid == ARC_TESTNET_CHAIN_ID || block.chainid == BASE_TESTNET_CHAIN_ID;
    }

    /**
     * @notice Get required DVN count based on current chain
     * @dev Centralized logic for DVN count configuration
     * @return uint8 Number of required DVNs (1 for testnet, 2 for mainnet)
     */
    function _getRequiredDvnCount() internal view returns (uint8) {
        return _isSingleDvnChain() ? 1 : 2;
    }

    /**
     * @notice Convert fixed array to dynamic array based on DVN requirements
     * @dev Used for LayerZero DVN configuration
     * @param fixedArray Fixed size array of 2 DVN addresses
     * @return address[] Dynamic array with 1 or 2 elements based on chain
     */
    function _toDynamicDvnArray(address[2] memory fixedArray) internal view returns (address[] memory) {
        if (_isSingleDvnChain()) {
            address[] memory dynamicArray = new address[](1);
            dynamicArray[0] = fixedArray[0];
            return dynamicArray;
        } else {
            address[] memory dynamicArray = new address[](2);
            dynamicArray[0] = fixedArray[0];
            dynamicArray[1] = fixedArray[1];
            return dynamicArray;
        }
    }
}
