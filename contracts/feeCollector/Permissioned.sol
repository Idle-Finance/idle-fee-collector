pragma solidity=0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

import "../interfaces/IFeeCollector.sol";

abstract contract Permissioned is IFeeCollector, Ownable, Initializable {
    mapping(address => bool) private _canSwap;

    modifier swapperOnly() {
        require(_canSwap[msg.sender], "FC: NOT SWAPPER");
        _;
    }

    function addSwapper(address swapper) external override onlyOwner {
        _canSwap[swapper] = true;

        emit SwapperAdded(swapper);
    }

    function removeSwapper(address swapper) external override onlyOwner {
        _canSwap[swapper] = false;

        emit SwapperRemoved(swapper);
    }

    function canSwap(address swapper) external override view returns (bool) {
        return _canSwap[swapper];
    }
}