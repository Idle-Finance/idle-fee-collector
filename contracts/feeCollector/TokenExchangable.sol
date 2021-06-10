// SPDX-License-Identifier: MIT

pragma solidity=0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "../interfaces/ITokenExchange.sol";
import "./Beneficiaries.sol";
import "./TokenManagable.sol";

abstract contract TokenExchangable is Beneficiaries, TokenManagable {
    using SafeERC20 for IERC20;

    function _exchange(ITokenExchange tokenExchange, IERC20 token, uint256 amountIn, uint256 minAmountOut) internal returns (uint256 amountOut) {
        uint256 previousOutBalance = Beneficiaries._distributionToken.balanceOf(address(this));
        tokenExchange.exchange(token, amountIn, minAmountOut);
        uint256 futureOutBalance = Beneficiaries._distributionToken.balanceOf(address(this));


        amountOut = futureOutBalance - previousOutBalance;
        require(amountOut >= minAmountOut, "FC: AMOUNT OUT");

        emit TokenExchanged(token, amountIn, minAmountOut, tokenExchange);
    }

    function exchange(IERC20 token, uint256 minAmountOut) external override nonReentrant swapperOnly returns (uint256 amountOut) {
        ITokenExchange tokenExchange = getTokenExchange(token);

        amountOut = _exchange(tokenExchange, token, token.balanceOf(address(this)), minAmountOut);

        _distributeToBeneficiaries();
    }
    function exchangeMany(IERC20[] calldata tokens, uint256[] calldata minAmountsOut) external override nonReentrant swapperOnly returns (uint256 amountOut) {
        require(tokens.length == minAmountsOut.length, "FC: INVALID LENGTH");

        for (uint256 i = 0; i < tokens.length; i++) {
            ITokenExchange tokenExchange = getTokenExchange(tokens[i]);

            amountOut += _exchange(tokenExchange, tokens[i], tokens[i].balanceOf(address(this)), minAmountsOut[i]);
        }

        _distributeToBeneficiaries();
    }
}
