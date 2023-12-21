//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SecondaryToken is ERC20{
    
    constructor(uint initialSupply) ERC20("SecondaryToken","ST"){
        _mint(msg.sender, initialSupply);
    }
}