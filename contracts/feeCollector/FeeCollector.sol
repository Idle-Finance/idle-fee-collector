// SPDX-License-Identifier: MIT

pragma solidity=0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./TokenExchangable.sol";

contract FeeCollector is TokenExchangable {
    using SafeERC20 for IERC20;

    function initialize(IERC20 outToken) public initializer {
        OwnableUpgradeable.__Ownable_init();
        Beneficiaries.__Beneficiaries_init(outToken);
    }

    function withdrawERC20(IERC20 token, address destination, uint256 amount) external override onlyOwner {
        token.safeTransfer(destination, amount);
    }
}
