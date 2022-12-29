//SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

interface ShareholdersInterface {
    function addShareholder(address payable _address, uint8 _percentage) external;
}

contract Elections{

    event becameCand(address candidateAddress, uint256 timsestamp);
    mapping(address => bool) isCandidate;
    mapping(address => uint8) addressToVotes;
    mapping(address => bool) hasVoted;
    address payable[] candidates;
    uint8 public sumOfAllVotes;
    uint256 deployDate;
    uint256 timeLimit = 1 minutes;
    address owner;

    modifier onlyOwner{
        require(msg.sender == owner, "Elections: This operation can do only the owner!");
        _;
    }

    /** @dev constructor initializes the {deployDate} right at the moment of the deployment **/ 
    constructor() {
        deployDate = block.timestamp;
        owner = msg.sender;
    }

    receive() external payable{}

    /**@dev receives the money and adds the sender to the list of candidades
    * Requirements: a person can send money to become a candidade only before the time limit is reached
    *               Same person can send mony only once
    **/
    function becomeCandidate() external payable {
        require(block.timestamp < deployDate + 3600, "Elections: Up to date!");
        require(!isCandidate[msg.sender], "Elections: You are already a candidade");
        isCandidate[msg.sender] = true;
        candidates.push(payable(msg.sender));
        emit becameCand(msg.sender, block.timestamp);
    }

    /**@dev function for voting. After voting the number of votes of the candidade who has been voted for(addressToVotes) increments
    *the number af all votes(sumOfAllVotes) also increments
    *@param _addressOfCandidade the address of the candidade who is voted for
    *Requirements: The same person can vote only once
                   A candidant can only be voted 
    **/
    function vote(address _addressOfCandidade) public {
        require(!hasVoted[msg.sender], "Elections: You have already voted");
        require(isCandidate[_addressOfCandidade], "Elections: There is no candidate with this address!");
        addressToVotes[_addressOfCandidade]++;
        sumOfAllVotes++;
        hasVoted[msg.sender] = true;
    }

    /**@dev summerizes the results of the selections. The function splits the money of the contract through the candidades 
    with percantages corresponding with their gotten votes
    *NOTE: I have used one of my deployed contracts - Shareholders.sol, whiches address is given to the {ShareholdersAddress} variable
    **/   
    function summerizeResults(address _shareholdersAdr) public onlyOwner{
        require(block.timestamp >= deployDate + timeLimit, "Elections: Too early to summerize");
        address shareholdersAddress = _shareholdersAdr;
        for(uint i = 0; i < candidates.length; i++) {
            uint8 perc = addressToVotes[candidates[i]] * 100 / sumOfAllVotes ;           
            ShareholdersInterface(shareholdersAddress).addShareholder(candidates[i], perc);
        }
    }
}
