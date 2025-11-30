// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

 
contract FundMe{

    uint minusd = 5 * 1e18;

    address[] private funders;
    mapping (address funder=> uint256 amountFunded) public addressToAmountFunded;
    

    function fund() public payable {
        require(getConversionRate(msg.value) > minusd,"didn't send enough eth");  
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]=addressToAmountFunded[msg.sender]+msg.value;
    }

    address public owner;
    
    constructor(){
        owner=msg.sender;
    }

    function getPrice()public view returns(uint256){
        //Adress - 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,)=priceFeed.latestRoundData();
        //price of eth in usd
        //2500.00000000
        return uint256(price*1e10);
    }
    function getConversionRate(uint256 ethAmount)public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethAmount * ethPrice) / 1e18;
        // Convert the value of Eth to USD
        return ethAmountInUsd;

    }
    function getVersion() public view returns (uint256){
        // ETH/USD price feed address of Sepolia Network.
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function withdraw() public onlyOwner {


        for (uint256 funder=0;funder<funders.length;funder++){
            address funderAddress=funders[funder];
            addressToAmountFunded[funderAddress]=0;
            payable(funderAddress).transfer(address(this).balance);
        }
        funders=new address[](0);

        //Transfer
        payable (msg.sender).transfer(address(this).balance);
    
        //send
        bool sendSuccess= payable (msg.sender).send(address(this).balance);
        require(sendSuccess,"sendFailed");

        //call
        (bool callSuccess,)=payable (msg.sender).call{value:address(this).balance}("");        
        require(callSuccess,"callFailed");
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;

    }

}