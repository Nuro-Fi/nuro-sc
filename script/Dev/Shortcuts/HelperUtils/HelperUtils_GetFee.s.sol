// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script, console } from "forge-std/Script.sol";
import { HelperUtils } from "@src/HelperUtils.sol";
import { Helper } from "@script/DevTools/Helper.sol";
import { SelectRpc } from "@script/DevTools/SelectRpc.sol";
import { BorrowParams } from "@src/lib/LendingPoolHook.sol";
import { SendParam } from "@layerzerolabs/oft-evm/contracts/interfaces/IOFT.sol";
import { MessagingFee } from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";

/**
 * @title HelperUtils_GetFee
 * @notice Shortcut script to get the LayerZero messaging fee for a cross-chain token transfer
 */
contract HelperUtils_GetFee is Script, Helper, SelectRpc {
    address public owner = vm.envAddress("PUBLIC_KEY");

    // Replace with actual addresses
    address public lendingPool = address(0); // Replace with actual lending pool address
    uint256 public borrowAmount = 1e6; // Amount to borrow
    uint32 public dstEid = BASE_TESTNET_EID; // Destination endpoint ID
    uint128 public gasOption = 200_000; // LayerZero gas option

    function setUp() public {
        selectRpc();
    }

    function run() public view {
        require(lendingPool != address(0), "Lending pool address not set");

        HelperUtils helperUtils = HelperUtils(KAIA_TESTNET_HELPER_UTILS);

        bytes32 toAddress = bytes32(uint256(uint160(owner)));

        // Construct SendParam
        SendParam memory sendParam =
            SendParam({ dstEid: dstEid, to: toAddress, amountLD: borrowAmount, minAmountLD: 0, extraOptions: "", composeMsg: "", oftCmd: "" });

        // Construct MessagingFee (placeholder, will be replaced)
        MessagingFee memory fee = MessagingFee({ nativeFee: 0, lzTokenFee: 0 });

        // Construct BorrowParams
        BorrowParams memory params = BorrowParams({
            sendParam: sendParam, fee: fee, amount: borrowAmount, chainId: BASE_TESTNET_CHAIN_ID, addExecutorLzReceiveOption: gasOption
        });

        (uint256 nativeFee, uint256 lzTokenFee) = helperUtils.getFee(params, lendingPool, false);

        console.log("=== LayerZero Fee ===");
        console.log("Lending Pool:", lendingPool);
        console.log("Borrow Amount:", borrowAmount);
        console.log("Destination EID:", dstEid);
        console.log("Native Fee:", nativeFee);
        console.log("LZ Token Fee:", lzTokenFee);
    }
}

// RUN
// forge script HelperUtils_GetFee -vvv
