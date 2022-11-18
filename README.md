# GoalCrusher

## What is GoalCrusher?
GoalCrusher is an application that allows you to earn NFT rewards by accomplishing fitness goals. With the use of Chainlink oracles and external adapters, off-chain data is transmitted on-chain in a verifiable and secure way, allowing for accurate and fair computations to be executed. GoalCrusher further incentivizes users in achieving their goals by allowing them to deposit collateral in ETH, risking losing it all if they do not accomplish their goal by the end of the day. 

## How does it work?
Currently, only one goal is able to be achieved: Hitting your caloric target for weight loss. This caloric target is determined by your FitBit and is calculated with the use of BMR and activity data.

- If the user met and/or passed their caloric target, they'll be allowed to withdraw their collateral if it exists and the number of goals achieved will increase by one. 
- At any time, the user can check if they have met their caloric goal.
- A specific number of goals must be achieved in order to mint the NFT. 

## How to run it
Remix IDE was used for the creations of all smart contracts (`FitbitConsumer.sol`, `GoalCrusher.sol`, `NFTcontract.sol`). 
All user interaction will be on `GoalCrusher.sol`, but they will also need the address of a deployed `FitbitConsumer.sol` contract. 

**EVERY SMART CONTRACT HAS BEEN BUILT FOR GOERLI TESTNET ONLY**

### Deploying FitbitConsumer.sol on Remix
- Load the FitbitConsumer.sol contract on Remix
- Change `setChainlinkToken`, `setChainlinkOracle` and `jobId` if you have your own network, oracle and job id that you want to use. 
```bash
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB); //Goerli LINK
        setChainlinkOracle(0x4e07bDC58A5441cfE3FdEa2f293b4bc721f413D0); // Operator.sol address
        jobId = '6aaad23b785849b1a22a9da3a88fdc2b';// Node job id for external adapter
```
- Select FitbitConsumer.sol from the contract list and deploy using *injected provider*
- Once deployed, fund the contract with at least 1 goerli LINK token and save its address
- 

