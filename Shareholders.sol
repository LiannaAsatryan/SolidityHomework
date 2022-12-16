//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Shareholders {
   
    constructor(){
        owner = payable(msg.sender);
    }

     /** @dev receives the money and splits to the shateholders with corresponding percantages*/
    receive() external payable {
        for(uint i = 0; i < shareholders.length; i++) {
            uint amount = (msg.value * addressToPercantage[shareholders[i]]) / 100;
            shareholders[i].transfer(amount);
        }
    }

    address payable owner;
    mapping(address => uint8) addressToPercantage;
    address payable[] shareholders;
    uint8 sumOfAllPersantages;

    /** @dev adds a new shareholder, the function can call only the owner
        @param _address the address of the new shareholder
        @param _persantage the percantage of the new shareholder*/
    function addShareholder(address payable _address, uint8 _persantage) public onlyOwner {
        require(_persantage <= 100, "Invalid persantage");
        require(addressToPercantage[_address] == 0, "This person is already a shareholder");
        require(sumOfAllPersantages + _persantage <= 100, "somethng is wrong with percantages");
        addressToPercantage[_address] = _persantage;
        shareholders.push(_address);
        sumOfAllPersantages += _persantage;
    }
    
    /** @dev removes the shareholder, the function can call only the owner
        @param _address the address of the new shareholder*/
    function removeShareholder(address _address) public onlyOwner {
        require(addressToPercantage[_address] != 0, "This shareholder doesn't exist");
        uint8 percantage = addressToPercantage[_address];
        addressToPercantage[_address] = 0;
        sumOfAllPersantages -= percantage;
    }  

    modifier onlyOwner{
        require(msg.sender == owner, "This operation can do only the owner!");
        _;
    }
}
