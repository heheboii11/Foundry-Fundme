//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/fundme.sol";

contract fund is Script {
    uint256 send_value = 0.1 ether;

    function fundfundme(address mostrecentdeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostrecentdeployed)).fund{value: send_value}();
        vm.stopBroadcast();
        console.log("your address have been funded and deployed");
    }

    function run() external {
        address mostrecentdeployed = DevOpsTools.get_most_recent_deployment(
            "Fundme",
            block.chainid
        );
        fundfundme(mostrecentdeployed);
    }
}

contract withdraw is Script {
    function withdrawfundme(address mostrecentdeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostrecentdeployed)).withdraw();
        vm.stopBroadcast();

        console.log("your address have been funded and deployed");
    }

    function run() external {
        address mostrecentdeployed = DevOpsTools.get_most_recent_deployment(
            "Fundme",
            block.chainid
        );

        withdrawfundme(mostrecentdeployed);
    }
}
