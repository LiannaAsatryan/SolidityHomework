//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Shareholders {
    address payable public owner;

    constructor(){
        owner = payable(msg.sender);
    }

    modifier onlyOwner{
        require(msg.sender == owner, "This operation can do only the owner!");
        _;
    }

    struct Shareholder {
        address payable shAddress;
        uint8 persantage; //0-100%
    }
    //array of shareholders
    Shareholder[] shareholders;

    int sumOfAllPersantages;

    /** @dev checks whether everything is okay with the parsantages of the shareholders*/
    function checkPersantages() private view {
       require(sumOfAllPersantages > 0 && sumOfAllPersantages <= 100, "something is wrong with the persantages!");
    }

    /** @dev checks whether the given array contains the given address
        @param _array the given array
        @param _address the given address
        @return a tuple value - bool(contains or not), int(the index of the element if contains. It's -1 if doesnt contain) */
    function contains(Shareholder[] memory _array, address _address) private pure returns(bool, int) {
        for(uint i = 0; i < _array.length; i++) {
            if(_array[i].shAddress == _address) {
                return (true, int(i));
            }
        }
        return (false, -1);
    }
    
    /** @dev adds a new shareholder, the function can call only the owner
        @param _address the address of the new shareholder
        @param _persantage the percantage of the new shareholder*/
    function addShareholder(address payable _address, uint8 _persantage) public onlyOwner {
        require(_persantage <= 100, "Invalid persantage");
        bool contain;
        (contain,) = contains(shareholders, _address);
        require(!contain, "This person is already a shareholder");
        Shareholder memory newShareholder = Shareholder(_address, _persantage);
        shareholders.push(newShareholder);
        sumOfAllPersantages += int8(_persantage); 
        checkPersantages();
    }
    
     /** @dev removes the shareholder, the function can call only the owner
        @param _address the address of the new shareholder*/
    function removeShareholder(address _address) public onlyOwner {
        bool contain;
        int index;
        (contain, index) = contains(shareholders, _address);
        require(contain, "This shareholder doesn't exist");
        uint8 percantage = shareholders[uint(index)].persantage;
        Shareholder memory temp = shareholders[uint(index)];
        shareholders[uint(index)] = shareholders[shareholders.length - 1];
        shareholders[shareholders.length - 1] = temp;
        shareholders.pop();
        sumOfAllPersantages -= int8(percantage);
        checkPersantages();
    }  

    
   /** @dev receives the money and splits to the shateholders with corresponding percantages*/
    receive() external payable {
        for(uint i = 0; i < shareholders.length; i++) {
            uint amount = (msg.value * uint(shareholders[i].persantage)) / 100;
            shareholders[i].shAddress.transfer(amount);
        }
    }

}
