// SPDX-License-Identifier: MIT

// 1. Deploy a mock contract when we are on a local anvil chain
// 2. Keep track of contract addresses across different chains

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig {
    // if we are on a local anvil, we deploy mocks
    // Otherwise, grab the existing address from the live network

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed;  //ETH/USD PriceFeed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else if(block.chainid == 1){
            activeNetworkConfig = getMainnetEthConfig();
        } 
        else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory){
        //price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    } 

function getMainnetEthConfig() public pure returns (NetworkConfig memory){
        //price feed address
        NetworkConfig memory ethConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethConfig;
    }
    function getAnvilConfig() public pure returns (NetworkConfig memory){
        //price feed address
    }
}
