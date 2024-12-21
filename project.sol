// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TutorialRewards {

    address public owner;
    uint public rewardPerTutorial = 2 ether; // Reward given for each uploaded tutorial
    mapping(address => uint) public userRewards; // Mapping of user rewards
    mapping(address => uint) public tutorialCount; // Mapping to count tutorials uploaded by each user
    mapping(address => bool) public hasUploadedTutorial; // Ensures each user uploads tutorial only once

    event TutorialUploaded(address indexed user, uint reward);
    event RewardsClaimed(address indexed user, uint reward);

    constructor() {
        owner = msg.sender;
    }

    // Modifier to ensure only the owner can call certain functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Function for the user to upload a tutorial and earn rewards
    function uploadTutorial() public {
        require(!hasUploadedTutorial[msg.sender], "You have already uploaded a tutorial.");
        
        // Mark the user as having uploaded a tutorial
        hasUploadedTutorial[msg.sender] = true;
        
        // Increase the tutorial count for the user
        tutorialCount[msg.sender] += 1;
        
        // Add reward to the user's balance
        userRewards[msg.sender] += rewardPerTutorial;
        
        emit TutorialUploaded(msg.sender, rewardPerTutorial);
    }

    // Function for the user to claim their rewards
    function claimRewards() public {
        uint reward = userRewards[msg.sender];
        require(reward > 0, "No rewards available to claim.");

        userRewards[msg.sender] = 0; // Reset the user's rewards before transferring

        // Transfer the reward to the user
        payable(msg.sender).transfer(reward);

        emit RewardsClaimed(msg.sender, reward);
    }

    // Function for the owner to set the reward rate per tutorial
    function setRewardPerTutorial(uint newReward) public onlyOwner {
        rewardPerTutorial = newReward;
    }

    // Function for the owner to fund the contract with Ether
    function fundContract() public payable onlyOwner {}

    // Fallback function to accept ether sent to the contract
    receive() external payable {}
}
