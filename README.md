# GoalCrusher

## What is GoalCrusher
GoalCrusher is an application that allows you to earn NFT rewards by accomplishing fitness goals. With the use of Chainlink oracles and external adapters, off-chain data is transmitted on-chain in a verifiable and secure way, allowing for accurate and fair computations to be executed. GoalCrusher further incentivizes users in achieving their goals by allowing them to deposit collateral in ETH, risking losing it all if they do not accomplish their goal by the end of the day. 

## How does works
Currently, only one goal is able to be achieved: Hitting your caloric target for weight loss. This caloric target is determined by your FitBit and is calculated with the use of BMR and activity data.

- If the user met and/or passed their caloric target, they'll be allowed to withdraw their collateral if it exists and the number of goals achieved will increase by one. 
- At any time, the user can check if they have met their caloric goal.
- A specific number of goals must be achieved in order to mint the NFT. 

## How to run it

**EVERY SMART CONTRACT HAS BEEN BUILT FOR GOERLI TESTNET ONLY**

Remix IDE was used for the creations of all smart contracts (`FitbitConsumer.sol`, `GoalCrusher.sol`, `NFTcontract.sol`). 
All user interaction will be on `GoalCrusher.sol`, but they will also need the address of a deployed `FitbitConsumer.sol` contract. 

### Deploying FitbitConsumer.sol on Remix
This contract is chainlink's [Mutliword Consumer Contract](https://docs.chain.link/any-api/get-request/examples/multi-variable-responses) from its any API resources. When calling its function `requestCaloriesData()`, it will fetch off-chain data for the two variables: calories spent and caloric goal.
- Load the FitbitConsumer.sol contract on Remix
- Change `setChainlinkToken`, `setChainlinkOracle` and `jobId` if you have your own network, oracle and job id that you want to use. 
```bash
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB); //Goerli LINK
        setChainlinkOracle(0x4e07bDC58A5441cfE3FdEa2f293b4bc721f413D0); // Operator.sol address
        jobId = '6aaad23b785849b1a22a9da3a88fdc2b';// Node job id (external adapter)
```
- Select FitbitConsumer.sol from the contract list and deploy using *injected provider*
- Once deployed, fund the contract with at least 1 goerli LINK token and save its address

### Deploying GoalCrusher.sol

This is the main contract from which users will be interacting with. It is responsible from retrieving caloric data from FitbitConsumer.sol and allowing users to check if they have met their caloric target. 

- Load the contract in Remix
- Select GoalCrusher.sol in contracts list and deploy using *Injected Provider*
  - Deploy with FitbitConsumer.sol address
  - ![alt-text](https://i.ibb.co/51CzBCs/Capture.png)

### Using GoalCrusher.sol

- Once all contracts are deployed, users can send collateral in ETH to the contract using `setCollateral()` function
- The user must call `callFitbitConsumer()` to populate `caloriesExpended` and `caloriesGoal` variables and automatically check if caloriesGoal was surpassed. 
  - Sometimes `callFitbitConsumer()` function will fail to populate the variables on time (leading them to report 0 when the Fitbitconsumer.sol contract already has a non-zero value). Waiting a minute or two and then calling `getCalories()` function will usually fix this problem and populate the calories variables.
- If the caloric goal was met and/or surpassed, users can withdraw their collateral with `withdraw` function
- Once a predetermined amount of goals has been achieved (determined by variable `NFT_GOALS_REQ`), users can use the `mintNFT` function to mint their NFT.
  - Users can check their minted NFTs on [OpenSea Testnet](https://testnets.opensea.io) 
