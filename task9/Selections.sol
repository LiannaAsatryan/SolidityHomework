//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;
import "@ganache/console.log/console.sol";


interface SharegholdersInterface {
    function addShareholder(address payable _address, uint8 _persantage) external;
}


contract Selections{
    mapping(address => bool) isCandidade;
    mapping(address => uint8) addressToVotes;
    mapping(address => bool) hasVoted;
    address payable[] candidades;
    uint8 sumOfAllVotes;
    uint deployDate;
    uint timeLimit = 1 minutes;
    address owner;

    /** @dev constructor initializes the {deployDate} right at the moment of the deployment **/ 
    constructor() {
        deployDate = block.timestamp;
        owner = msg.sender;
    }

    /**@dev receives the money and adds the sender to the list of candidades
    * Requirements: a person can send money to become a candidade only before the time limit is reached
    *               Same person can send mony only once
    **/
    receive() external payable{
        require(block.timestamp < deployDate + timeLimit, "Up to date!");
        require(!isCandidade[msg.sender], "You are already a candidade");
        isCandidade[msg.sender] = true;
        candidades.push(payable(msg.sender));
        console.log("Congratulations!  Now you are a candidade");
    }

    /**@dev function for voting. After voting the number of votes of the candidade who has been voted for(addressToVotes) increments
    *the number af all votes(sumOfAllVotes) also increments
    *@param _addressOfCandidade the address of the candidade who is voted for
    *Requirements: The same person can vote only once
                   A candidant can only be voted 
    **/
    function vote(address _addressOfCandidade) public {
        require(!hasVoted[msg.sender], "You have already voted");
        require(isCandidade[_addressOfCandidade], "The address you want to vote for is NOT a candidade");
        addressToVotes[_addressOfCandidade]++;
        sumOfAllVotes++;
        hasVoted[msg.sender] = true;
    }

    /**@dev summerizes the results of the selections. The function splits the money of the contract through the candidades 
    with percantages corresponding with their gotten votes
    *NOTE: I have used one of my deployed contracts - Shareholders.sol, whiches address is given to the {ShareholdersAddress} variable
    **/   
    function summerizeResults() public onlyOwner{
        require(block.timestamp >= deployDate + timeLimit, "Too early to summerize");
        address ShareholdersAddress = 0x34b0FBBcc344ae81Fc3EFDa8A714aC4F5979bB4B;
        for(uint i = 0; i < candidades.length; i++) {
            uint8 perc = addressToVotes[candidades[i]] * 100 / sumOfAllVotes ;
            //console.log(perc, '\n');           
            SharegholdersInterface(ShareholdersAddress).addShareholder(candidades[i], perc);
        }
    }

    modifier onlyOwner{
        require(msg.sender == owner, "This operation can do only the owner!");
        _;
    }
}
