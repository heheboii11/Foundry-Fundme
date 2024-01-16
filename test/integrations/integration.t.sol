//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {console} from "forge-std/console.sol";
import {DeployFundme} from "../../script/DeployFundme.s.sol";
import {fund, withdraw} from "../../script/interact.s.sol";
import {Helperconfig} from "../../script/HelperConfig.s.sol";

contract Fundmetestintegration is Test {
    FundMe fundme;
    address user = address(1);
    uint256 public constant send_value = 0.1 ether;
    uint256 public constant starting_value = 100 ether;

    function setUp() external {
        DeployFundme deploy = new DeployFundme();
        fundme = deploy.run();
        vm.deal(user, starting_value);
    }

    function testusercanfund() public {
        fund Fundfundme = new fund();

        Fundfundme.fundfundme(address(fundme));
        withdraw Withdraw = new withdraw();
        Withdraw.withdrawfundme(address(fundme));

        //assert(fundme.getaddressfunded(0) == user);
        assert(address(fundme).balance == 0);
    }
}
