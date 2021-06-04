pragma solidity =0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../interfaces/ITokenExchange.sol";
import "./Permissioned.sol";

abstract contract TokenManagable is Permissioned {
    using SafeERC20 for IERC20;
    
    mapping(IERC20 => ITokenExchange) private _tokenExchanges;

    modifier tokenIsExchangable(IERC20 token) {
        require(address(_tokenExchanges[token]) != address(0));
        _;
    }

    function addToken(IERC20 token, ITokenExchange tokenExchange) onlyOwner external override {
        _tokenExchanges[token] = tokenExchange;

        emit TokenAdded(token, tokenExchange);
    }

    function updateTokenExchange(IERC20 token, ITokenExchange tokenExchange) onlyOwner external override {
        _tokenExchanges[token] = tokenExchange;

        emit TokenExchangeUpdated(token, tokenExchange);
    }

    function removeToken(IERC20 token) onlyOwner external override {
        _tokenExchanges[token] = ITokenExchange(address(0)); 
    }
}