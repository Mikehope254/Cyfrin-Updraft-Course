// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

//inheritance in Solidity 
contract AddFiveStorage is SimpleStorage { 
    //+5
    //override keywords: override and virtual
    function store(uint256 _newNumber) public override  {
    myFavoriteNumber = _newNumber + 5;
    }
}