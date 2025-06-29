// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable{
        require(msg.value.getConversionRate()>= minimumUsd, "didn't send enough ");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withdraw() public {
         /* starting index (initialization), ending index, step amount */
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++ ){
        address funder = funders[funderIndex];
        addressToAmountFunded[funder] = 0;}
    }
    
    
}
