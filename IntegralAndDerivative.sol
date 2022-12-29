//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract IntegralAndDerivative{

    /** @dev calculating integral
        @param _lowerValue is integral's lower limit 
        @param _upperValue is integral's upper limit
        @param _polynom is polynomial function*/
    function integrate(uint256 _lowerValue, uint256 _upperValue, uint256[] memory _polynom) external pure returns(uint256) {
        uint256 upperPart;
        uint256 lowerPart;
        for(uint i = 0; i < _polynom.length; i++) {
           upperPart += _upperValue ** (i+1) * _polynom[i] / (i+1);
           lowerPart += _lowerValue ** (i+1) * _polynom[i] / (i+1);
        }
        return upperPart - lowerPart;
    }

    /** @dev calculating derivative of polynomial function at fixed point
        @param _fixPoint is fixed point  
        @param _polynom is polynomial function*/
    function derivative(uint256 _fixPoint, uint256[] memory _polynom) external pure returns(uint256) {
        uint256 result;
        for(uint i = 0; i < _polynom.length; i++) {
            result += i * _polynom[i] * _fixPoint ** (i-1);
        }
        return result;
    }
}
