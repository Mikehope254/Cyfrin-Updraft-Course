// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;
   
    uint256 public constant  MINIMUM_USD = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable{
        require(msg.value.getConversionRate(s_priceFeed)>= MINIMUM_USD, "didn't send enough");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }
    
    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function withdraw() public onlyOwner {
        /* starting index (initialization), ending index, step amount */
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++ ){
        address funder = funders[funderIndex];
        addressToAmountFunded[funder] = 0;}
        
        //resetting the array
        funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{value:address(this).balance}("") ;   
        require(callSuccess, "Call Failed");
    }
    
    modifier onlyOwner(){
        if(msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
    	_;
    }
       
       receive() external payable {
        fund();
    }
    
    fallback() external payable {
        fund();
    }
}