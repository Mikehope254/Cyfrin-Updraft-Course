// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
   
    uint256 public constant  MINIMUM_USD = 5e18;
    //670,925 gas - non-constant 
    //650,627 gas - constant

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;
    //439 immutable 
    //2574 non-immutable
    
    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable{
        require(msg.value.getConversionRate()>= MINIMUM_USD, "didn't send enough ");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        
         /* starting index (initialization), ending index, step amount */
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++ ){
        address funder = funders[funderIndex];
        addressToAmountFunded[funder] = 0;}
        
        //resetting the array
        funders = new address[](0);

        //transfer
        //payable(msg.sender) = payable address
        //payable(msg.sender).transfer(address(this).balance);

        //send
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess, "Send failed");

        //call
        (bool callSuccess, ) = payable(msg.sender).call{value:address(this).balance}("") ;   
        require(callSuccess, "Call Failed");
    }
    
    modifier onlyOwner(){
    	//require(msg.sender == i_owner, "Sender is not owner");
        if(msg.sender != i_owner) {
            revert NotOwner();
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
