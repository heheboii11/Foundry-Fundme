// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "../forge-std/Script.sol";
import {FundMe} from "../src/fundme.sol";
import {Helperconfig} from "./HelperConfig.s.sol";

contract DeployFundme is Script {
    FundMe fundme;

    function run() external returns (FundMe) {
        Helperconfig helperconfig = new Helperconfig();
        address ethusdaddress = helperconfig.activeNetworkConfig();
        vm.startBroadcast();
        fundme = new FundMe(ethusdaddress);
        vm.stopBroadcast();
        return fundme;
    }
}
