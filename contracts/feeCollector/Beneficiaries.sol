pragma solidity =0.8.4;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "./Permissioned.sol";

abstract contract Beneficiaries is Permissioned {
    uint256 constant MAXIMUM_BENEFICIARIES = 20;

    address[] private _beneficiaries;
    mapping(address => uint256) _beneficiariesBalance;

    function getBeneficiaries() external view returns (address[] memory) {
        return _beneficiaries;
    }

    function addBeneficiary(address beneficiary, uint256 denormWeight) onlyOwner external override {}
    function updateBeneficiary(address beneficiary, uint256 denormWeight) onlyOwner external override {}
    function removeBeneficiary(address beneficiary) onlyOwner external override {}

    function withdraw() external override {}
    function withdrawFor(address beneficiary) external override {}
}