pragma solidity =0.8.4;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "./TokenExchangable.sol";

abstract contract Beneficiaries is TokenExchangable {
    uint256 constant MAXIMUM_BENEFICIARIES = 20;

    address[] private _beneficiaries;
    uint256[] private _beneficiariesDenormWeight;
    uint256 private _totalWeight;
    
    mapping(address => uint256) _beneficiariesBalance;

    function getBeneficiaries() external view returns (address[] memory) {
        return _beneficiaries;
    }

    function _addBeneficiary(address beneficiary, uint256 denormWeight) internal {
        _totalWeight += denormWeight;

        _beneficiaries.push(beneficiary);
        _beneficiariesDenormWeight.push(denormWeight);

        emit BeneficiaryAdded(beneficiary, denormWeight, _totalWeight);
    }

    function addBeneficiary(address beneficiary, uint256 denormWeight) onlyOwner external override {
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

    function updateBeneficiary(address beneficiary, uint256 denormWeight) onlyOwner external override {
        uint256 beneficiaryIndex = _indexOfBeneficiary(beneficiary);
        require(beneficiaryIndex != type(uint256).max, "FC: BENEFICIARY NOT FOUND");

        _updateBeneficiary(beneficiaryIndex, denormWeight);
    }

    function updateBeneficiaryAt(uint256 index, uint256 denormWeight) onlyOwner external override {
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

    function removeBeneficiary(address beneficiary) onlyOwner external override {
        uint256 beneficiaryIndex = _indexOfBeneficiary(beneficiary);
        require(beneficiaryIndex != type(uint256).max, "FC: BENEFICIARY NOT FOUND");

        _removeBeneficiaryAt(beneficiaryIndex);
    }

    function removeBeneficiaryAt(uint256 index) onlyOwner external override {
        require(index < _beneficiaries.length, "FC: INVALID BENEFICIARY INDEX");

        _removeBeneficiaryAt(index);
    }

    function updateBalances() external override {}

    function withdraw() external override {}
    function withdrawFor(address beneficiary) external override {}
}
