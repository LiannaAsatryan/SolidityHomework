//SPDX-License-Identifier: MIT
import "@ganache/console.log/console.sol";
pragma solidity 0.8.15;

contract Game {
    /*this function generates a random number in range [0, 9999]*/
    function randomNumber() private view returns(uint) {
        uint randNonce = 0;
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % 10;
        return random;
    }

    /*this function calls the randomNumber function, checks the condition for winning
    and returns the appropriate message as a string.
    Note: the generated random number can only be seen when the play function is called. It will be seen in console*/
    function play(uint _numberGotten) public view returns(string memory) {
        uint rand = randomNumber();
        console.log("the random number is ", rand);
        if((rand >= _numberGotten && rand - _numberGotten == uint(5)) || (rand <= _numberGotten && _numberGotten - rand == uint(5))) {
            return "Congratulations! You won";
        }
        return "Oops:( you didn't win, thank you for participating";
    }
}
