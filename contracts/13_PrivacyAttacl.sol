// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

  interface IPrivacy{
    function unlock(bytes16 _key) external;
  }
contract Privacy {
    IPrivacy private immutable target;

    constructor(address _target){
        target=IPrivacy(_target);
    }
    function attack(bytes32 ans) public{
        bytes16 final_ans=bytes16(ans);
        target.unlock(final_ans);
    }
   
}