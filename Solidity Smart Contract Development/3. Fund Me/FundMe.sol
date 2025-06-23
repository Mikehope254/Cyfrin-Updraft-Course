// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
  
contract FundMe{
    uint256 public myValue = 1;
    function fund() public payable  {
        //Allow users to send $
        // Have a minimum $ sent
        myValue = myValue + 2;
        require(msg.value > 1e18, "Didn't send enough eth");
    }

   // function withdraw() public {}


}
