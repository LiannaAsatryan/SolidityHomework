//SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

contract Shareholders {
   
    constructor(address electionAddress){
        owner = electionAddress;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Shareholders: This operation can do only the owner!");
        _;
    }

     /** @dev receives the money and splits to the shateholders with corresponding percantages*/
    receive() external payable {
        for(uint i = 0; i < shareholders.length; i++) {
            uint amount = (msg.value * addressToPercantage[shareholders[i]]) / 100;
            shareholders[i].transfer(amount);
        }
    }

    address owner;
    mapping(address => uint8) private addressToPercantage;
    address payable[] private shareholders;
    uint8 private sumOfAllPersantages;

    /** @dev adds a new shareholder, the function can call only the owner
        @param _address the address of the new shareholder
        @param _persantage the percantage of the new shareholder*/
    function addShareholder(address payable _address, uint8 _persantage) external onlyOwner{
        require(_persantage <= 100, "Shareholder: Invalid percentage");
        require(addressToPercantage[_address] == 0, "Shareholder: This person is already a shareholder");
        require(sumOfAllPersantages + _persantage < 100, "Shareholder: Something is wrong with percentages");
        addressToPercantage[_address] = _persantage;
        shareholders.push(_address);
        sumOfAllPersantages += _persantage; 
    }
    
    /** @dev removes the shareholder, the function can call only the owner
        @param _address the address of the new shareholder*/
    function removeShareholder(address _address) public onlyOwner {
        require(addressToPercantage[_address] != 0, "Shareholder: This shareholder doesn't exist");
        uint8 percantage = addressToPercantage[_address];
        addressToPercantage[_address] = 0;
        sumOfAllPersantages -= percantage;
    }  
}
