// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';

/**
 * @title FitbitConsumer
 * @dev Store and retrieve off-chain values with Chainlink Oracle using node with external adapter.
 * @custom:note Hackathon Fall 2022
 */

contract FitbitConsumer is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    uint256 internal caloriesSpent;
    uint256 internal caloriesTarget;
    bytes32 private jobId;
    uint256 private fee;

    event RequestVolume(bytes32 indexed requestId, uint256 caloriesSpent, uint256 caloriesTarget);

    //Initializing the link token and target oracle
    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        setChainlinkOracle(0x4e07bDC58A5441cfE3FdEa2f293b4bc721f413D0);
        jobId = '6aaad23b785849b1a22a9da3a88fdc2b';
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }
    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, and then fulfill caloriesSpent and caloriesTarget
     */

    function requestCaloriesData() public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        req.add("date", "today");
        // Sends the request
        return sendOperatorRequest(req, fee);
    }

    /**
     * Receive the response in the form of uint256
     */
    function fulfill(bytes32 _requestId, uint256 _caloriesSpent, uint256 _caloriesTarget) public recordChainlinkFulfillment(_requestId) {
        emit RequestVolume(_requestId, _caloriesSpent, _caloriesTarget);
        caloriesSpent = _caloriesSpent;
        caloriesTarget = _caloriesTarget;
    }

    /**
     * Allow withdraw of Link tokens from the contract
     */
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), 'Unable to transfer');
    }

    function getCaloriesSpent() external view returns(uint256){
        return caloriesSpent;
    }

      function getCaloriesTarget() external view returns(uint256){
        return caloriesTarget;
    }
}
