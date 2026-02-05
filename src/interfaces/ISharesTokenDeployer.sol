// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { NuroSharesToken } from "../SharesToken/NuroSharesToken.sol";

/**
 * @title ISharesTokenDeployer
 * @notice Interface for the SharesTokenDeployer contract
 * @dev This interface defines the public functions for deploying and managing NuroSharesToken
 */
interface ISharesTokenDeployer {
    // =============================================================
    //                           CONSTANTS
    // =============================================================

    /// @notice Role identifier for accounts that can pause the contract
    function PAUSER_ROLE() external view returns (bytes32);

    /// @notice Role identifier for accounts that can upgrade the contract
    function UPGRADER_ROLE() external view returns (bytes32);

    /// @notice Role identifier for accounts that have owner privileges
    function OWNER_ROLE() external view returns (bytes32);

    // =============================================================
    //                      STATE VARIABLES
    // =============================================================

    /// @notice Factory contract address
    function factory() external view returns (address);

    /// @notice NuroSharesToken contract address
    function nuroSharesToken() external view returns (NuroSharesToken);

    // =============================================================
    //                      EXTERNAL FUNCTIONS
    // =============================================================

    /// @notice Initialize function
    function initialize() external;

    /// @notice Deploy NuroSharesToken function
    function deploySharesToken() external returns (address);

    /// @notice Set factory function
    /// @param _factory The address of the factory contract
    function setFactory(address _factory) external;

    /// @notice Pause function
    function pause() external;

    /// @notice Unpause function
    function unpause() external;
}
