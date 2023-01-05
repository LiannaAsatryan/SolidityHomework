//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IYVN{
    function transfer(address to, uint256 amount) external;
}

contract Staking{
    uint256 totalStake;
    struct User{
        address userAddress;
        uint256 userStakeAmount;
        uint256 unclaimedReward;    
    }
    mapping(address => bool) isUser;
    User[] users;
    uint256 tokenCount = 100; //the number of tokens a staker will receive in a second as reward
    uint256 startTime;        //the time of first deposit
    uint256 ts;                 
    bool hasStarted;
    address tokenAddress; //the address of deployed MyERC20Token contract 

    /** @dev constructor gets the YVN token address as a parameter and initializes the tokenAddress variable with it**/
    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }

    modifier onlyStaker{
        require(isUser[msg.sender], "Staking: You are not a staker!");
        _;
    }

    /** @dev deposit function receives ethers from the accounts,
            adds the staked ethers to the userStakeAmount if the account is already a user,
            otherwise, turnes that account into a user with appropriate data**/
    function deposit() external payable {
        if(!hasStarted) {
            startTime = block.timestamp;
            hasStarted = true;
        }
        totalStake += msg.value;
        if(isUser[msg.sender]) {
            for(uint i = 0; i < users.length; i++) {
                if(users[i].userAddress == msg.sender) {
                    users[i].userStakeAmount += msg.value;
                    break;
                }
            }
        } else {
            User memory newUser = User(msg.sender, msg.value, 0);
            users.push(newUser);
            isUser[msg.sender] = true;
        }
        updateRewards();
    }

    /** @dev the claim function gives the user the rewards(YVN tokens)
      *Requirements: only stakers can call this function, and they must have some rewards to receive**/
    function claim() public onlyStaker{
        updateRewards();
        for(uint i = 0; i < users.length; i++) {
            if(users[i].userAddress == msg.sender) {
               require(users[i].unclaimedReward > 0, "Staking: You have no rewards!");
               IYVN(tokenAddress).transfer(msg.sender, users[i].unclaimedReward);
               users[i].unclaimedReward = 0;
               break;
            }
        }
    }

    /** @dev the claim function gives the user staked ethers and it also calls the claim function
      *Requirements: only stakers can call this function, and they must have some ethers to receive**/
    function withdraw() public onlyStaker{
        updateRewards();
        for(uint i = 0; i < users.length; i++) {
            if(users[i].userAddress == msg.sender) {
               require(users[i].userStakeAmount > 0, "Staking: No ether to withdraw!");
               payable(msg.sender).transfer(users[i].userStakeAmount); 
               isUser[msg.sender] = false;
               totalStake -= users[i].userStakeAmount;
               claim();
               break;
            }
        }
    }    

     /** @dev traverses the list of users and updates the unclaimedReward of each user
       *this function is called when some user calls deposit, withdraw and claim functions**/
    function updateRewards() private {
        for(uint i = 0; i < users.length; i++) {
            if(isUser[users[i].userAddress]) {
               ts = block.timestamp;
               users[i].unclaimedReward += ((ts - startTime) * tokenCount * users[i].userStakeAmount / totalStake);
               startTime = block.timestamp;
            }
        }
    }
}     
