// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import './FitbitConsumer.sol';
import './NFTcontract.sol';

error NotOwner();

/**
 * @title GoalCrusher
 * @dev Store and retrieve off-chain values to check and reward fitness goal achievements.
 * @custom:note Hackathon Fall 2022
 */
contract GoalCrusher {

    FitbitConsumer fitbitConsumer;
    GoalGetter NFTcontract;
    //The amount of completed goals required to mint NFTs. 
    uint256 public NFT_GOALS_REQ = 1;
    uint256 public completedGoals;

    //Collateral for current fitness goal
    uint256 public collateral;
    //Calories expended and goal determined by FitBit API
    uint256 public caloriesExpended;
    uint256 public caloriesGoal;
    
    address immutable owner;
    //Address of smart contract that calls Chainlink operator contract to request off-chain FitBit data
    address fitbitConsumerAddress;

    bool withdrawPermission = false;
    
    constructor(address _fitbitConsumerAddress) {
        owner = msg.sender;
        fitbitConsumerAddress = _fitbitConsumerAddress;
    }

    //Collateral for goal
    function setCollateral() public payable {
        collateral = msg.value;
    }
    //Using a pre-deployed and funded Chainlink API consumer contract connected to node with external adapter
    function callFitbitConsumer() public OnlyOwner {
        fitbitConsumer = FitbitConsumer(fitbitConsumerAddress);
        requestCalories();
    }

    function requestCalories() internal OnlyOwner {
        fitbitConsumer.requestCaloriesData();
        getCalories();
    }

    function getCalories() public OnlyOwner {
        caloriesExpended = fitbitConsumer.getCaloriesSpent();
        caloriesGoal = fitbitConsumer.getCaloriesTarget();
        checkGoal();
    }
    //Checks conditions to see if goal was met
    //Allows for owner to withdraw funds if condition has been met
    //Stores a completed goal
    function checkGoal() internal{
        if(caloriesExpended >= caloriesGoal) {
            withdrawPermission = true;
            completedGoals+=1;
        }
    }

    //Allows owner to mint NFT if the required amount of goals has been achieved.
    function mintNFT() public OnlyOwner{
        require(completedGoals >= NFT_GOALS_REQ, "You have not met the requirement of 2 goals achieved to mint NFT.");
        //predeployed NFT minting contract
        NFTcontract = GoalGetter(0x353aBC91031e61AE9bBB0e4DA4Ce0A876c363E65);
        //"ipfs://.." is uri required to mint token
        NFTcontract.safeMint(msg.sender, "ipfs://Qmdh8yKUo6DN7yhhNdoPesnTV7pPSr7S4XoChbqxofzTNe");

    }
    //Withdraw function only allowed when goal has been completed.
    function withdraw() public OnlyOwner {
        require(withdrawPermission == true);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed.");
        withdrawPermission=false;
        
    }

    modifier OnlyOwner() {
        if(msg.sender != owner){revert NotOwner();}
        _;
    }
}
