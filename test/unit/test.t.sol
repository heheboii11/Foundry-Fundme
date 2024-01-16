// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {console} from "forge-std/console.sol";
import {DeployFundme} from "../../script/DeployFundme.s.sol";

contract FundmeTest is Test {
    FundMe fundme;
    address user = makeAddr("user");
    uint256 constant send_value = 10 ether;
    uint256 constant starting_value = 10 ether;

    function setUp() external {
        DeployFundme deployfundme = new DeployFundme();
        fundme = deployfundme.run();
        vm.deal(user, starting_value);
    }

    modifier funded() {
        vm.startPrank(user);
        fundme.fund{value: send_value}();
        vm.stopPrank();
        _;
    }

    function testFundme() public {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testowner() public {
        console.log(address(this));
        console.log(fundme.getOwner());
        assertEq(fundme.getOwner(), msg.sender);
    }

    function testversion() public {
        uint256 version = fundme.getVersion();

        console.log(version);

        assertEq(version, 4);
    }

    function testamountfunded() public funded {
        console.log(address(this));
        assertEq(fundme.getaddressfundamount(user), send_value);
    }

    function testaddressfunded() public funded {
        assertEq(fundme.getaddressfunded(0), user);
    }

    function testwithdrawnotownerfailure() public {
        console.log(address(this));
        vm.startPrank(user);
        vm.expectRevert();
        fundme.withdraw();
        vm.stopPrank();
    }

    function testSingleWithdraw() public {
        uint256 initialfundmebalance = address(fundme).balance;
        uint256 initialownerbalance = fundme.getOwner().balance;
        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();
        uint256 endingfundmebalance = address(fundme).balance;
        uint256 endingownerbalance = fundme.getOwner().balance;
        assertEq(endingfundmebalance, 0);
        assertEq(
            initialfundmebalance + initialownerbalance,
            endingownerbalance
        );
    }

    // function testmultiplefunderswithdraw() public funded {
    //     uint160 funders = 10;
    //     uint160 index = 2;
    //     for (uint160 i = index; i < index + funders; i++) {
    //         hoax(address(i), starting_value);
    //         fundme.fund{value: send_value};
    //     }
    //     uint256 initialfundmebalance = address(fundme).balance;
    //     uint256 initialownerbalance = fundme.getOwner().balance;
    //     vm.startPrank(fundme.getOwner());
    //     fundme.withdraw();
    //     vm.stopPrank();

    //     // uint256 endingfundmebalance = address(fundme).balance;
    //     // uint256 endingownerbalance = fundme.getOwner().balance;
    //     assert(initialfundmebalance == 0);
    //     assert(
    //         initialfundmebalance + initialownerbalance ==
    //             fundme.getOwner().balance
    //     );
    // }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;
        for (
            uint160 i = startingFunderIndex;
            i < numberOfFunders + startingFunderIndex;
            i++
        ) {
            // we get hoax from stdcheats
            // prank + deal
            hoax(address(i), starting_value);
            fundme.fund{value: send_value}();
        }

        uint256 startingFundMeBalance = address(fundme).balance;
        uint256 startingOwnerBalance = fundme.getOwner().balance;

        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();

        assert(address(fundme).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundme.getOwner().balance
        );
        assert(
            (numberOfFunders + 1) * send_value ==
                fundme.getOwner().balance - startingOwnerBalance
        );
    }
}
