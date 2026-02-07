// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title MOCKUSYC
 * @notice Mock US Yield Coin token for testing purposes
 * @dev Extends OpenZeppelin's ERC20 with yield simulation via NAV (Net Asset Value)
 *      USYC is a yield-bearing stablecoin backed by US Treasury securities
 */
contract MOCKUSYC is ERC20 {
    /// @notice Current NAV per token in 18 decimals (starts at 1:1 with USD)
    uint256 public navPerToken = 1e18;

    /// @notice Timestamp of last NAV update
    uint256 public lastUpdateTime;

    /// @notice Annual yield rate in basis points (400 = 4% APY)
    uint256 public constant YIELD_RATE_BPS = 400;

    /// @notice Seconds per year for yield calculation
    uint256 public constant SECONDS_PER_YEAR = 365 days;

    /// @notice Event emitted when NAV is updated
    /// @param oldNav Previous NAV value
    /// @param newNav New NAV value
    /// @param timestamp Time of update
    event NAVUpdated(uint256 oldNav, uint256 newNav, uint256 timestamp);

    /**
     * @notice Constructs a new mock USYC token
     * @dev Initializes with name "US Yield Coin" and symbol "USYC"
     */
    constructor() ERC20("US Yield Coin", "USYC") {
        lastUpdateTime = block.timestamp;
    }

    /**
     * @notice Returns the number of decimals used for the token
     * @return Number of decimal places (18 for USYC on Arc)
     */
    function decimals() public pure override returns (uint8) {
        return 6;
    }

    /**
     * @notice Updates the NAV to simulate yield accrual over time
     * @dev Calculates yield based on time elapsed since last update
     *      ~4% APY = 0.04 / SECONDS_PER_YEAR per second
     */
    function updateNAV() external {
        uint256 timeElapsed = block.timestamp - lastUpdateTime;
        if (timeElapsed == 0) return;

        uint256 oldNav = navPerToken;

        // Calculate yield: navPerToken * (YIELD_RATE_BPS / 10000) * (timeElapsed / SECONDS_PER_YEAR)
        uint256 yieldAmount = (navPerToken * YIELD_RATE_BPS * timeElapsed) / (10000 * SECONDS_PER_YEAR);
        navPerToken += yieldAmount;
        lastUpdateTime = block.timestamp;

        emit NAVUpdated(oldNav, navPerToken, block.timestamp);
    }

    /**
     * @notice Returns the USD value of a given USYC amount based on current NAV
     * @param _usycAmount Amount of USYC tokens
     * @return usdValue The USD value in 18 decimals
     */
    function getUSDValue(uint256 _usycAmount) external view returns (uint256 usdValue) {
        return (_usycAmount * navPerToken) / 1e6;
    }

    /**
     * @notice Returns the USYC amount for a given USD value based on current NAV
     * @param _usdAmount Amount in USD (18 decimals)
     * @return usycAmount The USYC token amount
     */
    function getUSYCAmount(uint256 _usdAmount) external view returns (uint256 usycAmount) {
        return (_usdAmount * 1e6) / navPerToken;
    }

    /**
     * @notice Mints tokens to a specified address
     * @param _to Address to receive the minted tokens
     * @param _amount Amount of tokens to mint
     * @dev Public function for testing - no access control
     */
    function mint(address _to, uint256 _amount) public {
        _mint(_to, _amount);
    }

    /**
     * @notice Burns tokens from a specified address
     * @param _from Address to burn tokens from
     * @param _amount Amount of tokens to burn
     * @dev Public function for testing - no access control
     */
    function burn(address _from, uint256 _amount) public {
        _burn(_from, _amount);
    }

    /**
     * @notice Manually set NAV for testing purposes
     * @param _newNav New NAV value in 18 decimals
     * @dev Only for testing - should be removed in production
     */
    function setNAV(uint256 _newNav) external {
        uint256 oldNav = navPerToken;
        navPerToken = _newNav;
        lastUpdateTime = block.timestamp;
        emit NAVUpdated(oldNav, _newNav, block.timestamp);
    }
}
