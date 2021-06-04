pragma solidity=0.8.4;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./TokenExchangable.sol";
import "./Beneficiaries.sol";

contract FeeCollector is TokenExchangable, Beneficiaries, Initializable {
    using SafeERC20 for IERC20;

    function initialize() public initializer {}

    function withdrawERC20(IERC20 token, address destination, uint256 amount) onlyOwner tokenIsNotExchangable(token) override external {
        token.safeTransfer(destination, amount);
    }
}