//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;


contract TestToken{

    mapping(address => uint) private s_balances;

    function name() public pure returns (string memory){
        return "TestToken";
    }

     function decimals() public pure returns (uint8){
        return 18;
    }

    function totalSupply() public pure returns (uint256){
        return 100 ether;
    }

   
    function balanceOf(address _owner) public view returns (uint256 balance){

        return s_balances[_owner];
    }

    function transfer(address _to, uint256 _value) public{
        uint previousBalances = balanceOf(msg.sender) + balanceOf(_to);

        s_balances[msg.sender] -= _value;
        s_balances[_to] += _value;

        require(balanceOf(msg.sender) + balanceOf(_to) == previousBalances);
    }
}