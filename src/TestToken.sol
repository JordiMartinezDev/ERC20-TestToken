//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20{
    
    constructor(uint initialSupply) ERC20("TestToken","TT"){
        
    }
}