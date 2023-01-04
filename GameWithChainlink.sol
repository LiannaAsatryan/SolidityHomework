// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract GameWithChainlink is VRFConsumerBase {
    address public owner;
    bytes32 internal keyHash; // identifies which Chainlink oracle to use
    uint internal fee;        // fee to get random number
    uint public randomResult;

    constructor()
    VRFConsumerBase(
        0x2bce784e69d2Ff36c71edcB9F88358dB0DfB55b4, // VRF coordinator
        0x326C977E6efc84E512bB9C30f76E30c160eD06FB  // LINK token address
    ) {
        keyHash = 0x0476f9a745b61ea5c0ab224d3a6e4c99f0b02fce4da01143a4f70aa80ae76e8a;
        fee = 0.1 * 10 ** 18;    // 0.1 LINK

    }

    function getRandomUint() external view returns(uint256) {
        return randomResult;
    }

    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK in contract");
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint randomness) internal override {
        randomResult = randomness;
    }

    function play(uint _number) public view returns(string memory) {
        uint256 rand = randomResult % 100;
        if((rand >= _number && rand - _number <= 5) || (rand <= _number && _number - rand <= 5)) {
            return "Congratulations! You won";
        }
        return "Oops:( you didn't win, thank you for participating";
    }

}
