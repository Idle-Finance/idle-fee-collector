pragma solidity=0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./TokenManagable.sol";

abstract contract TokenExchangable is TokenManagable {
    using SafeERC20 for IERC20;

    function swap(IERC20 token, uint256 minAmountOut) swapperOnly external override {}
    function swapMany(IERC20[] calldata tokens, uint256[] calldata minAmountsOut) swapperOnly external override {}
}