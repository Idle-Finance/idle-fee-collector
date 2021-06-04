// SPDX-License-Identifier: MIT

pragma solidity =0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ITokenExchange.sol";

interface IFeeCollector {
    event TokenAdded(IERC20 token, ITokenExchange tokenExchange);
    event TokenExchangeUpdated(IERC20 token, ITokenExchange tokenExchange);
    event TokenRemoved(IERC20 token);

    function addToken(IERC20 token, ITokenExchange tokenExchange) external;
    function updateTokenExchange(IERC20 token, ITokenExchange tokenExchange) external;
    function removeToken(IERC20 token) external;

    event TokenSwapped(IERC20 indexed token, uint256 amountIn, uint256 amountOut, ITokenExchange exchange);

    function swap(IERC20 token, uint256 minAmountOut) external returns (uint256);
    function swapMany(IERC20[] calldata tokens, uint256[] calldata minAmountsOut) external returns (uint256);

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

    event FeeCollected(uint256 feeAmount);

    function distributeToBeneficiaries() external;

    event SwapperAdded(address swapper);
    event SwapperRemoved(address swapper);

    function addSwapper(address swapper) external;
    function removeSwapper(address swapper) external;
    function canSwap(address swapper) external returns (bool);

    function withdrawERC20(IERC20 token, address destination, uint256 amount) external;
}