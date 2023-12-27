// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "../lib/forge-std/src/Test.sol";
import {TestToken} from "../src/TestToken.sol";
import {DeployTestToken} from "../script/DeployTestToken.s.sol";

// Malicious contract for reentrancy attack simulation
contract MaliciousContract {
    TestToken public token;

    constructor(address _token) {
        token = TestToken(_token);
    }

    function attack() external {
        token.transferFrom(msg.sender, address(this), token.balanceOf(msg.sender));
    }
}

contract TestTokenTest is Test {

    TestToken public testToken;
    DeployTestToken public deployer;

    uint public constant STARTING_BALANCE = 100 ether;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    address charlie = makeAddr("charlie");

    function setUp() public {
        deployer = new DeployTestToken();
        testToken = deployer.run();

        vm.prank(msg.sender);

        testToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, testToken.balanceOf(bob));
    }

    function testAllowances() public {
        uint intAllowance = 1000;
        vm.prank(bob);

        // Test approval and transferFrom
        testToken.approve(alice, intAllowance);
        uint transferAmount = 1;

        vm.prank(alice);
        testToken.transferFrom(bob, alice, transferAmount);

        assertEq(testToken.balanceOf(alice), transferAmount);
        assertEq(testToken.balanceOf(bob), STARTING_BALANCE - transferAmount);

        // Test decreasing allowance
        uint newAllowance = intAllowance - transferAmount;
        assertEq(testToken.allowance(bob, alice), newAllowance, "Allowance not decreased properly");

        // Test multiple transfers with allowances
        uint transferAmount2 = 2;
        vm.prank(alice);
        testToken.transferFrom(bob, alice, transferAmount2);

        assertEq(testToken.balanceOf(alice), transferAmount + transferAmount2, "Incorrect balance after multiple transfers");
        assertEq(testToken.balanceOf(bob), STARTING_BALANCE - transferAmount - transferAmount2, "Incorrect balance for sender");
        assertEq(testToken.allowance(bob, alice), newAllowance - transferAmount2, "Allowance not decreased properly after multiple transfers");
    }

    function testTransfer() public {
        // Test basic transfer
        uint transferAmount = 10;
        vm.prank(bob);
        testToken.transfer(alice, transferAmount);

        assertEq(testToken.balanceOf(alice), transferAmount, "Incorrect balance after transfer");
        assertEq(testToken.balanceOf(bob), STARTING_BALANCE - transferAmount, "Incorrect balance for sender");
    }

    function testTransfer2() public {
        
        // Test basic transfer
        uint transferAmount = 10;
        vm.prank(bob);
        testToken.transfer(alice, transferAmount);

        assertEq(testToken.balanceOf(alice), transferAmount, "Incorrect balance after transfer");
        assertEq(testToken.balanceOf(bob), STARTING_BALANCE - transferAmount, "Incorrect balance for sender");

        // Test transferring to self
        vm.prank(bob);
        testToken.transfer(bob, transferAmount);
        assertEq(testToken.balanceOf(bob), STARTING_BALANCE - transferAmount, "Balance should not change when transferring to self");

        // Test transferring to another account
        uint transferAmount2 = 5;
        vm.prank(alice);
        testToken.transfer(charlie, transferAmount2);
        assertEq(testToken.balanceOf(charlie), transferAmount2, "Incorrect balance for receiver");
    
    }

    function testDecimals() public {
    // Test the number of decimals in the token
    assertEq(testToken.decimals(), 18, "Incorrect number of decimals");
    }

    function testSymbol() public {
    // Test the token symbol
    assertEq(testToken.symbol(), "TT", "Incorrect token symbol");
    }
    
    function testName() public {
    // Test the token name
    assertEq(testToken.name(), "TestToken", "Incorrect token name");
    }
    function testTotalSupply() public {
    // Test the total supply of the token
    assertEq(testToken.totalSupply(), 1000 ether, "Incorrect total supply");
    }
    function testReentrancyAttack() public {
        // Reentrancy attack test
        MaliciousContract attacker = new MaliciousContract(address(testToken));
        testToken.approve(address(attacker), STARTING_BALANCE);

        // Trigger reentrancy attack
        vm.prank(address(attacker));
        attacker.attack();

        // Ensure the attack did not compromise the token balance
        assertEq(testToken.balanceOf(bob), STARTING_BALANCE, "Reentrancy attack compromised token balance");
    }
}
