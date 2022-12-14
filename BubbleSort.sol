//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;
import "@ganache/console.log/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract BubbleSort{
    /** @dev prints the given array in console
        @param _array the given array */
    function printArray(int[] memory _array) private view{
        for(uint i = 0; i < _array.length; i++) {
            string memory a = Strings.toString(uint(_array[i]));
            console.log(a);
        }
    }

    /** @dev sorts the given array by acsending order with bubble sorting algorithm and and finds the largests(with given quantity) of them
      * @param _array the given array
      * @param _number the quantity of the required largest elements
      * @return the result array */
    function sortAndGetTheLargests(int[] memory _array, uint _number) public pure returns(int[] memory) {
        require(_number <= _array.length, "The entered number is out of range");
        //sorting
        for(uint i = 0; i < _array.length; i++) {
            for(uint j = i + 1; j < _array.length; j++) {
                if(_array[j] < _array[i]) {
                    (_array[i], _array[j]) =  (_array[j], _array[i]);
                }    
            }
        }
        //prints the sorted array
        /*console.log("The sorted array");
        printArray(_array);*/

        int[] memory newArr = new int[](_number);
        uint index = 0;
        for(uint i = _array.length - _number; i < _array.length; i++) {
            newArr[index] = _array[i];
            index++;
        }
        //prints the result
        /*console.log("The result array");
        printArray(newArr);*/
        return newArr;
    }
}
