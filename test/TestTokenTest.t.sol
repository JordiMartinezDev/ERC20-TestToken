//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "../lib/forge-std/src/Test.sol";
import {TestToken} from "../src/TestToken.sol";
import {DeployTestToken} from "../script/DeployToken.s.sol";

contract TestTokenTest{

    TestToken public testToken;
    DeployTestToken public deployer;

    address bob = makeAddr("Bob");
    address alice = makeAddr("Alice");

    function setUp() public{
        deployer = new DeployTestToken();
        testToken = deployer.run();

        vm.prank(address(deployer));

        testToken.transfer(bob, 1 ether);

    }

    
}