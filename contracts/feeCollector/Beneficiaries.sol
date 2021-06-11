// SPDX-License-Identifier: MIT

pragma solidity =0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./Permissioned.sol";

abstract contract Beneficiaries is Permissioned {
    using SafeERC20 for IERC20;

    uint256 constant MAXIMUM_BENEFICIARIES = 20;
    
    IERC20 internal _distributionToken;

    address[] private _beneficiaries;
    uint256[] private _beneficiariesDenormWeight;
    uint256 private _totalWeight;
    
    mapping(address => uint256) private _beneficiariesBalance;
    uint256 _feeToDistribute;

    function __Beneficiaries_init(IERC20 outToken) internal initializer {
        _distributionToken = outToken;
    }

    function getBeneficiaries() external view returns (address[] memory) {
        return _beneficiaries;
    }

    function _addBeneficiary(address beneficiary, uint256 denormWeight) internal {
        _totalWeight += denormWeight;

        _beneficiaries.push(beneficiary);
        _beneficiariesDenormWeight.push(denormWeight);

        emit BeneficiaryAdded(beneficiary, denormWeight, _totalWeight);
    }

    function addBeneficiary(address beneficiary, uint256 denormWeight) external override onlyOwner {
        require(_beneficiaries.length < MAXIMUM_BENEFICIARIES, "FC: MAXIMUM BENEFICIARIES");
        _addBeneficiary(beneficiary, denormWeight);
    }

    function _indexOfBeneficiary(address beneficiary) internal view returns (uint256 index) {
        for (index = 0; index < _beneficiaries.length; index++) {
            if (_beneficiaries[index] == beneficiary) {
                return index;
            }
        }
        return type(uint256).max;
    }

    function _updateBeneficiary(uint256 index, uint256 denormWeight) internal {
        _totalWeight = _totalWeight -_beneficiariesDenormWeight[index] + denormWeight;
        
        _beneficiariesDenormWeight[index] = denormWeight;

        emit BeneficiaryUpdated(_beneficiaries[index], denormWeight, _totalWeight);
    }

    function updateBeneficiary(address beneficiary, uint256 denormWeight) external override onlyOwner {
        uint256 beneficiaryIndex = _indexOfBeneficiary(beneficiary);
        require(beneficiaryIndex != type(uint256).max, "FC: BENEFICIARY NOT FOUND");

        _updateBeneficiary(beneficiaryIndex, denormWeight);
    }

    function updateBeneficiaryAt(uint256 index, uint256 denormWeight) external override onlyOwner {
        require(index < _beneficiaries.length, "FC: INVALID BENEFICIARY INDEX");

        _updateBeneficiary(index, denormWeight);
    }

    function _removeBeneficiaryAt(uint256 index) internal {
        _totalWeight -= _beneficiariesDenormWeight[index];
        address beneficiary = _beneficiaries[index];

        for (uint i = index; i < _beneficiaries.length - 1; i++) {
            _beneficiaries[i] = _beneficiaries[i + 1];
            _beneficiariesDenormWeight[i] = _beneficiariesDenormWeight[i + 1];
        }
        _beneficiaries.pop();
        _beneficiariesDenormWeight.pop();

        emit BeneficiaryRemoved(beneficiary, _totalWeight);
    }

    function removeBeneficiary(address beneficiary) external override onlyOwner {
        uint256 beneficiaryIndex = _indexOfBeneficiary(beneficiary);
        require(beneficiaryIndex != type(uint256).max, "FC: BENEFICIARY NOT FOUND");

        _removeBeneficiaryAt(beneficiaryIndex);
    }

    function removeBeneficiaryAt(uint256 index) external override onlyOwner {
        require(index < _beneficiaries.length, "FC: INVALID BENEFICIARY INDEX");

        _removeBeneficiaryAt(index);
    }

    function _distributeToBeneficiaries() internal {
        require(_totalWeight > 0, "FC: NO BENEFICIARIES");

        uint256 tokenBalance = _distributionToken.balanceOf(address(this));

        if (tokenBalance > _feeToDistribute) {
            uint256 toDistribute = tokenBalance - _feeToDistribute;
            uint256 distributed = 0;
            uint256 forBeneficiary;
            
            for (uint256 i = 0; i < _beneficiaries.length; i++) {
                address beneficiary = _beneficiaries[i];

                if (i == _beneficiaries.length - 1) {
                    _beneficiariesBalance[beneficiary] += toDistribute - distributed;
                } else {
                    forBeneficiary = (toDistribute * _beneficiariesDenormWeight[i]) / _totalWeight;
                    distributed += forBeneficiary;
                    _beneficiariesBalance[beneficiary] = forBeneficiary;
                }
            }

            emit FeeCollected(toDistribute);
        }
    }

    function distributeToBeneficiaries() external override {
        _distributeToBeneficiaries();
    }

    function _withdraw(address beneficiary) internal {
        uint256 amount = _beneficiariesBalance[beneficiary];

        require(amount != 0, "FC: BALANCE=0");

        _beneficiariesBalance[beneficiary] = 0;
        _feeToDistribute -= amount;

        _distributionToken.safeTransfer(beneficiary, amount);

        emit FeeClaimed(beneficiary, amount);
    }

    function withdraw() external override nonReentrant {
        _withdraw(msg.sender);
    }
    function withdrawFor(address beneficiary) external override nonReentrant {
        _withdraw(beneficiary);
    }
    
    function distributionToken() external override view returns (IERC20) {
        return _distributionToken;
    }
}
