//SPDX-License-Identifier: MIT


//Errors remaining 
// Setting a particular threshold 



pragma solidity ^0.6.6 ;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";
// we need ABI to interact with already deployed contract



contract FundMe{ //accept some type of payment

    // using safemath for int256;
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) public{ 
        //constructor called immediately as conytact is deployed
        owner=msg.sender;
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function fund() public payable{

        //setting $50
        uint256 minimumUSD=50 * 10**18;
        require(msg.value >= minimumUSD, "Yo neeed to spend more ETH"); //transaction reverted if not met this condition
        
        addressToAmountFunded[msg.sender]+=msg.value; //keywords in every contract
        //what is conversion rate of token

        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256){
        // interface type  name as it will give pricefeed    address of pricefeed rinkeby 
        return priceFeed.version();
    }

    function getPrice() public view returns(uint256){
        (,
        int256 answer,
        ,
        ,
        )= priceFeed.latestRoundData();
        //  returns price of 1 etherium in USD, divide by 10000000000 to get actual price of 10eth in USD
        return uint256(answer*10000000000); 
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice=getPrice();
        uint256 ethAmountInUsd=(ethPrice*ethAmount);
        return ethAmountInUsd;
    }
    //13639598601 this has 18 decimals as well so 0.000000013639598601 for 1Gwei

    modifier onlyOwner{
        require(msg.sender==owner);
        _;
    }

    function withdraw() payable onlyOwner public{
        payable(msg.sender).transfer(address(this).balance); //this value for owner as passed in contractor
         //setting all senders to 0
        for(uint256 funderIndex=0; funderIndex< funders.length; funderIndex++){
            address funder=funders[funderIndex];
            addressToAmountFunded[funder]=0;
        }
        funders = new address[](0); //reset the funder array

        // Firstly modifier onlyOwner will run and then after that this function wll learn
        

    }

    function getEntranceFee() public view returns (uint256){
        uint256 minimumUSD = 50 * 10**18; //we need 50 dollars 
        uint256 price = getPrice();
        uint256 precision = 1* 10**18;
        return (minimumUSD * precision) / price;

    }

}