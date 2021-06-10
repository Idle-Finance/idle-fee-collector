// SPDX-License-Identifier: MIT

pragma solidity =0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ITokenExchange.sol";

/**
  @title IFeeCollector
  @author Asaf Silman
  @notice Defines the functions and events required to implement a FeeCollector
  */

interface IFeeCollector {
    /**
      @notice Emitted when a token added to the fee collector
      @dev Used in TokenManagable.sol
      @param token The ERC20 token which is added
      @param tokenExchange The intermediate token exchange contract
      */
    event TokenAdded(IERC20 token, ITokenExchange tokenExchange);
    /**
      @notice Emitted when a token exchange is updated
      @dev Used in TokenManagable.sol
      @param token The ERC20 token which is updated
      @param tokenExchange The intermediate token exchange contract
     */
    event TokenExchangeUpdated(IERC20 token, ITokenExchange tokenExchange);
    /**
      @notice Emitted when a token is removed from the feeCollector
      @dev Used in TokenManagable.sol
      @param token The ERC20 token which is removed
     */
    event TokenRemoved(IERC20 token);

    function addToken(IERC20 token, ITokenExchange tokenExchange) external;
    function updateTokenExchange(IERC20 token, ITokenExchange tokenExchange) external;
    function removeToken(IERC20 token) external;

    event TokenExchanged(IERC20 indexed token, uint256 amountIn, uint256 amountOut, ITokenExchange exchange);

    function exchange(IERC20 token, uint256 minAmountOut) external returns (uint256);
    function exchangeMany(IERC20[] calldata tokens, uint256[] calldata minAmountsOut) external returns (uint256);

    event FeeClaimed(address indexed beneficiary, uint256 amount);

    function withdraw() external;
    function withdrawFor(address beneficiary) external;

    event BeneficiaryAdded(address beneficiary, uint256 denormWeight, uint256 totalWeight);
    event BeneficiaryUpdated(address beneficiary, uint256 denormWeight, uint256 totalWeight);
    event BeneficiaryRemoved(address beneficiary, uint256 totalWeight);
    
    function addBeneficiary(address beneficiary, uint256 denormWeight) external;
    function updateBeneficiary(address beneficiary, uint256 denormWeight) external;
    function updateBeneficiaryAt(uint256 index, uint256 denormWeight) external;
    function removeBeneficiary(address beneficiary) external;
    function removeBeneficiaryAt(uint256 index) external;

    function distributionToken() external returns (IERC20);

    event FeeCollected(uint256 feeAmount);

    function distributeToBeneficiaries() external;

    event ExchangerAdded(address exchanger);
    event ExchangerRemoved(address exchanger);

    function addExchanger(address exchanger) external;
    function removeExchanger(address exchanger) external;
    function canExchange(address exchanger) external returns (bool);

    function withdrawERC20(IERC20 token, address destination, uint256 amount) external;
}