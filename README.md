# GoalCrusher

## What is GoalCrusher?
GoalCrusher is an application that allows you to earn NFT rewards by accomplishing fitness goals. With the use of Chainlink oracles and external adapters, off-chain data is transmitted on-chain in a verifiable and secure way, allowing for accurate and fair computations to be executed. GoalCrusher further incentivizes users in achieving their goals by allowing them to deposit collateral in ETH, risking losing it all if they do not accomplish their goal by the end of the day. 

## How does it work?
Currently, only one goal is allowed to be achieved: Hitting your caloric target for weight loss. This caloric target is determined by your FitBit and was calculated with the use of BMR and activity data.

- If the user met and/or passed their caloric target, they'll be allowed to withdraw their collateral if it exists and the number of goals achieved will increase by one. 
- At any time, the user can check if they have met their caloric goal.
- A specific number of goals must be achieved in order to mint the NFT. 

## How to run it
Remix IDE was used for the creations of all smart contracts (`FitbitConsumer.sol`, `GoalCrusher.sol`, `NFTcontract.sol`). All user interaction will be on `GoalCrusher.sol`, but they will also need the address of a deployed `FitbitConsumer.sol` contract. *ALL ADDRESSES ARE FROM GOERLI TESTNET*

### Deploying FitbitConsumer.sol on Remix
- Load the FitbitConsumer.sol contract on Remix
- 

