// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "../lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test/mocks/mock.sol";

contract Helperconfig is Script {
    NetworkConfig public activeNetworkConfig;
    struct NetworkConfig {
        address pricefeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaConfig();
        } else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory pricefeedsepolia = NetworkConfig(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        return pricefeedsepolia;
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.pricefeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockpricefeed = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();
        NetworkConfig memory AnvilConfig = NetworkConfig(
            address(mockpricefeed)
        );
        return AnvilConfig;
    }
}
