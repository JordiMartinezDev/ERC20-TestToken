//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "../lib/forge-std/src/Script.sol";
import {TestToken} from "../src/TestToken.sol";


contract DeployToken is Script{

        uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns(TestToken){


        vm.startBroadcast();

        TestToken tt = new TestToken(INITIAL_SUPPLY);
        return tt;
        vm.stopBroadcast();

    }

}