// SPDX-License-Identifier: MIT

pragma solidity=0.8.4;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

import "../interfaces/IFeeCollector.sol";

abstract contract Permissioned is IFeeCollector, OwnableUpgradeable, ReentrancyGuardUpgradeable {
    mapping(address => bool) private _canExchange;

    modifier exchangerOnly() {
        require(_canExchange[msg.sender], "FC: NOT EXCHANGER");
        _;
    }

    function addExchanger(address exchanger) external override onlyOwner {
        _canExchange[exchanger] = true;

        emit ExchangerAdded(exchanger);
    }

    function removeExchanger(address exchanger) external override onlyOwner {
        _canExchange[exchanger] = false;

        emit ExchangerRemoved(exchanger);
    }

    function canExchange(address exchanger) external override view returns (bool) {
        return _canExchange[exchanger];
    }
}