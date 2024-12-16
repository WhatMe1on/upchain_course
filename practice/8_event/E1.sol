pragma solidity ^0.8.0;

contract EventExample {
    // Deposit
    event Deposit(address indexed, uint256);

    function deposit(uint256 value) public {
        // 触发事件
        emit Deposit(msg.sender, value);
    }
}
