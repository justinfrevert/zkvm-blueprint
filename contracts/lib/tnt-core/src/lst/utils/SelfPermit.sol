// SPDX-License-Identifier: MIT

import { ERC20 } from "solmate/tokens/ERC20.sol";

pragma solidity >=0.8.19;

/// @title Self Permit
/// @notice Functionality to call permit on any EIP-2612-compliant token for use in the route
interface ISelfPermit {
    /// @notice Permits this contract to spend a given token from `msg.sender`
    /// @dev The `owner` is always msg.sender and the `spender` is always address(this).
    /// @param _token The address of the token spent
    /// @param _value The amount that can be spent of token
    /// @param _deadline A timestamp, the current blocktime must be less than or equal to this timestamp
    /// @param _v Must produce valid secp256k1 signature from the holder along with `r` and `s`
    /// @param _r Must produce valid secp256k1 signature from the holder along with `v` and `s`
    /// @param _s Must produce valid secp256k1 signature from the holder along with `r` and `v`
    function selfPermit(address _token, uint256 _value, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) external payable;

    /// @notice Permits this contract to spend a given token from `msg.sender`
    /// @dev The `owner` is always msg.sender and the `spender` is always address(this).
    /// Can be used instead of #selfPermit to prevent calls from failing due to a frontrun of a call to #selfPermit
    /// @param _token The address of the token spent
    /// @param _value The amount that can be spent of token
    /// @param _deadline A timestamp, the current blocktime must be less than or equal to this timestamp
    /// @param _v Must produce valid secp256k1 signature from the holder along with `r` and `s`
    /// @param _r Must produce valid secp256k1 signature from the holder along with `v` and `s`
    /// @param _s Must produce valid secp256k1 signature from the holder along with `r` and `v`
    function selfPermitIfNecessary(
        address _token,
        uint256 _value,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    )
        external
        payable;
}

abstract contract SelfPermit is ISelfPermit {
    /// @inheritdoc ISelfPermit
    function selfPermit(
        address _token,
        uint256 _value,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    )
        public
        payable
        override
    {
        ERC20(_token).permit(msg.sender, address(this), _value, _deadline, _v, _r, _s);
    }

    /// @inheritdoc ISelfPermit
    function selfPermitIfNecessary(
        address _token,
        uint256 _value,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    )
        external
        payable
        override
    {
        uint256 allowance = ERC20(_token).allowance(msg.sender, address(this));
        if (allowance < _value) selfPermit(_token, _value - allowance, _deadline, _v, _r, _s);
    }
}
