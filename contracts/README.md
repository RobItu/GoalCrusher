# Contracts
Each Contract was made and hosted on Remix IDE. 

- `FitbitConsumer.sol`: a modified Chainlink [Mutliword Consumer Contract](https://docs.chain.link/any-api/get-request/examples/multi-variable-responses). It fetches multiple responses from the Chainlink oracle that has been connected to a specific [external adapter](https://github.com/RobItu/GoalCrusher/tree/main/external-adapter) to retrieve caloric data from FitBit.
- `GoalCrusher.sol`: Main contract that users interacts with. It fetches data from Fitbitconsumer.sol contract and determines if caloric goal was met. It also allows for user to fund the contract with collateral and to mint NFTs when certain conditions have been met.
- `NFTcontract.sol`: This is the specific NFT minting contract I created using OpenZeppelin's Contract Wizard. Its address is hard-coded into `GoalCrusher.sol`. Any NFT contract can be used as long as the address and minting function is configured. 
