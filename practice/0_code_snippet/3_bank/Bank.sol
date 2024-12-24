// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

contract Bank {
    BalanceSheet[3] public balanceSheet;

    address public s_owner;
    uint256 public balance;
    uint256 public counter;

    error Bank__NotOwner();
    error Bank__withdraw2Failed();
    error Bank__withdraw3Failed();

    struct BalanceSheet {
        address userAddress;
        uint256 balance;
    }

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
        (bool success,) = (payable(msg.sender)).call{value: address(this).balance}("");
        if (!success) {
            revert Bank__withdraw3Failed();
        }
        changeBalance();
    }

    function deposit() public payable {
        insertUser(msg.sender, msg.value);
        changeBalance();
    }

    function changeBalance() private {
        balance = address(this).balance;
    }

    function insertUser(address _address, uint256 _balance) private {
        uint8 minIndex = 0;
        uint256 minBalance = 0xffffffffffffffff;

        for (uint8 index = 0 ; index < balanceSheet.length; index++) {
            uint256 tmp = balanceSheet[index].balance;
            address storedAddress = balanceSheet[index].userAddress;
            if (storedAddress == _address) {
                balanceSheet[index].balance = tmp + _balance;
                return;
            }
            if (minBalance > tmp) {
                minIndex = index;
                minBalance = tmp;
            }
        }

        if (minBalance < _balance) {
            balanceSheet[minIndex] = BalanceSheet({userAddress: _address, balance: _balance});
        }
    }
}
