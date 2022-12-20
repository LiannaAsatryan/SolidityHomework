//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface BusdInterface {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract Caller {
    address BUSDcontractAddress = 0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee;

    //calls of the functions
    function callTotalSupply() external view returns(uint256) {
        return BusdInterface(BUSDcontractAddress).totalSupply();
    }
    function callDecimals() external view returns(uint8) {
        return BusdInterface(BUSDcontractAddress).decimals();
    }
    function callBalanceOf(address _accountAddress) external view returns(uint256) {
        return BusdInterface(BUSDcontractAddress).balanceOf(_accountAddress);
    }
    function callApprove(address _spenderAddress, uint256 _amount) external returns(bool) {
        return BusdInterface(BUSDcontractAddress).approve(_spenderAddress, _amount);
    }
    function callTransfer(address _recipientAddress, uint256 _amount) external returns(bool) {
        return BusdInterface(BUSDcontractAddress).transfer(_recipientAddress, _amount);
    }
}
