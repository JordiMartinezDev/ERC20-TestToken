//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20{
    
    constructor(uint initialSupply) ERC20("TestToken","TT"){
        _mint(msg.sender, initialSupply);
    }
}