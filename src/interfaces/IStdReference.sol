// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

interface IStdReference {
    struct ReferenceData {
        uint256 rate; // price * 1e18
        uint256 lastUpdatedBase; // UNIX timestamp
        uint256 lastUpdatedQuote; // UNIX timestamp
    }

    function getReferenceData(string memory _base, string memory _quote) external view returns (ReferenceData memory);

    function getReferenceDataBulk(string[] memory _bases, string[] memory _quotes) external view returns (ReferenceData[] memory);
}
