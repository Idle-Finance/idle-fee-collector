// SPDX-License-Identifier: MIT

pragma solidity =0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "../interfaces/ITokenExchange.sol";
import "./Permissioned.sol";

abstract contract TokenManagable is Permissioned {
    using SafeERC20 for IERC20;
    
    mapping(IERC20 => ITokenExchange) private _tokenExchanges;

    modifier tokenExchangable(IERC20 token) {
        require(address(_tokenExchanges[token]) != address(0), "FC: TOKEN NOT EXCHANGABLE");
        _;
    }

    function _addToken(IERC20 token, ITokenExchange tokenExchange) internal {
        _tokenExchanges[token] = tokenExchange;

        emit TokenAdded(token, tokenExchange);
    }

    function addToken(IERC20 token, ITokenExchange tokenExchange) external override onlyOwner {
        require(address(_tokenExchanges[token]) == address(0), "FC: TOKEN IS EXCHANGABLE");

        _addToken(token, tokenExchange);
    }

    function _updateToken(IERC20 token, ITokenExchange tokenExchange) internal {
        _tokenExchanges[token] = tokenExchange;

        emit TokenExchangeUpdated(token, tokenExchange);
    }

    function updateTokenExchange(IERC20 token, ITokenExchange tokenExchange) external override onlyOwner tokenExchangable(token) {
        _updateToken(token, tokenExchange);
    }

    function _removeToken(IERC20 token) internal {
        _tokenExchanges[token] = ITokenExchange(address(0));

        emit TokenRemoved(token);
    }

    function removeToken(IERC20 token) external override onlyOwner tokenExchangable(token) {
        _removeToken(token);
    }

    function getTokenExchange(IERC20 token) public view tokenExchangable(token) returns (ITokenExchange exchange) {
        exchange = _tokenExchanges[token];

        // return exchange
    }
}