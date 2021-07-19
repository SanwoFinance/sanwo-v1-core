pragma solidity >=0.6.0 <=0.8.0;
import './IChi.sol';


interface IGasDiscountExtension {
    function calculateGas(uint256 gasUsed, uint256 flags, uint256 calldataLength) external view returns (IChi, uint256);
}
