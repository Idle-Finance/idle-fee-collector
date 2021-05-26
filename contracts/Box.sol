pragma solidity =0.8.4;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Box is Initializable {
    uint256 public x;

    function initialize(uint256 _x) public initializer {
        x = _x;
    }
}