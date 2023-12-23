//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "../lib/forge-std/src/Test.sol";
import {TestToken} from "../src/TestToken.sol";
import {DeployTestToken} from "../script/DeployTestToken.s.sol";

contract TestTokenTest is Test{

    TestToken public testToken;
    DeployTestToken public deployer;

    uint public constant STARTING_BALANCE = 1 ether;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    function setUp() public{
        deployer = new DeployTestToken();
        testToken = deployer.run();

        vm.prank(msg.sender);

        testToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, testToken.balanceOf(bob));
    }

    function testAllowances() public {

        
    }


}