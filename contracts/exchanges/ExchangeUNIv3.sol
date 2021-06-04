pragma solidity =0.8.4;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

import "../interfaces/ITokenExchange.sol";

contract ExchangeUNIv3 is ITokenExchange, ReentrancyGuard {
    using SafeERC20 for IERC20;
    
    ISwapRouter _router;
    IERC20 _tokenOut;

    uint24 constant FEE = 3000; // 0.3%

    constructor (ISwapRouter router, IERC20 tokenOut) ReentrancyGuard() {
        _router = router;
        _tokenOut = tokenOut;
    }

    function swap(IERC20 tokenIn, uint256 amountIn, uint256 amountOut) nonReentrant external override {
        tokenIn.safeTransferFrom(msg.sender, address(this), amountIn);
        tokenIn.safeIncreaseAllowance(address(_router), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams(
            address(tokenIn), // tokenIn
            address(_tokenOut), // tokenOut
            FEE, // fee
            msg.sender, // recipient
            block.timestamp, // deadline
            amountIn, // amountIn
            amountOut, // amountOutMinimum
            0 // sqrtPriceLimitX96. Ignore pool price limits
        );
        _router.exactInputSingle(params);
    }
}