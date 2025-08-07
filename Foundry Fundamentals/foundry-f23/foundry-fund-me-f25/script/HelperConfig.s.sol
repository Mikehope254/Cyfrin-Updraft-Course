// SPDX-License-Identifier: MIT

// 1. Deploy a mock contract when we are on a local anvil chain
// 2. Keep track of contract addresses across different chains

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig {
    // if we are on a local anvil, we deploy mocks
    // Otherwise, grab the existing address from the live network

    function getSepoliaEthConfig() public pure {

    } 

    function getAnvil
}
