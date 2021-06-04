// SPDX-License-Identifier: MIT

pragma solidity=0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "../interfaces/ITokenExchange.sol";
import "./Beneficiaries.sol";
import "./TokenManagable.sol";

abstract contract TokenExchangable is Beneficiaries, TokenManagable {
    using SafeERC20 for IERC20;

    function _swap(ITokenExchange exchange, IERC20 token, uint256 amountIn, uint256 minAmountOut) internal returns (uint256 amountOut) {
        uint256 previousOutBalance = _outToken.balanceOf(address(this));
        exchange.swap(token, amountIn, minAmountOut);
        uint256 futureOutBalance = _outToken.balanceOf(address(this));


        amountOut = futureOutBalance - previousOutBalance;
        require(amountOut >= minAmountOut, "FC: AMOUNT OUT");

        emit TokenSwapped(token, amountIn, minAmountOut, exchange);
    }

    function swap(IERC20 token, uint256 minAmountOut) nonReentrant swapperOnly external override returns (uint256 amountOut) {
        ITokenExchange exchange = getTokenExchange(token);

        amountOut = _swap(exchange, token, token.balanceOf(address(this)), minAmountOut);

        _distributeToBeneficiaries();
    }
    function swapMany(IERC20[] calldata tokens, uint256[] calldata minAmountsOut) nonReentrant swapperOnly external override returns (uint256 amountOut) {
        require(tokens.length == minAmountsOut.length, "FC: INVALID LENGTH");

        for (uint256 i = 0; i < tokens.length; i++) {
            ITokenExchange exchange = getTokenExchange(tokens[i]);

            amountOut += _swap(exchange, tokens[i], tokens[i].balanceOf(address(this)), minAmountsOut[i]);
        }

        _distributeToBeneficiaries();
    }
}
