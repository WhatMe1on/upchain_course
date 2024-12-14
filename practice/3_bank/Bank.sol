// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

contract Bank {
    mapping(address => uint) s_balanceSheep;
    address public s_owner;
    uint public balance;
    uint public counter;

    error Bank__NotOwner();
    error Bank__withdraw2Failed();
    error Bank__withdraw3Failed();

    modifier M_onlyOwner() {
        if (msg.sender != s_owner) {
            revert Bank__NotOwner();
        }
        _;
    }

    constructor() {
        s_owner = msg.sender;
        counter = 0;
    }

    fallback() external payable {
        counter++;
    }

    receive() external payable {}

    function withdraw1() public M_onlyOwner {
        (payable(msg.sender)).transfer(address(this).balance);
        changeBalance();
    }

    function withdraw2() public M_onlyOwner {
        bool success = (payable(msg.sender)).send(address(this).balance);
        if (!success) {
            revert Bank__withdraw2Failed();
        }
        changeBalance();
    }

    function withdraw3() public M_onlyOwner {
        (bool success, ) = (payable(msg.sender)).call{
            value: address(this).balance
        }("");
        if (!success) {
            revert Bank__withdraw3Failed();
        }
        changeBalance();
    }

    function deposit() public payable {
        s_balanceSheep[msg.sender] = msg.value;
        changeBalance();
    }

    function changeBalance() private {
        balance = address(this).balance;
    }
}
