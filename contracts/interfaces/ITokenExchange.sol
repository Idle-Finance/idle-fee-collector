// SPDX-License-Identifier: MIT

pragma solidity =0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ITokenExchange {
    function swap(IERC20 token, uint256 amountIn, uint256 amountOut) external;
}