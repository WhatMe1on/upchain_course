// https://decert.me/challenge/063c14be-d3e6-41e0-a243-54e35b1dde58
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

interface IBank {
    function s_owner() external returns (address);
    function s_balance() external returns (uint256);
    function s_counter() external returns (uint256);

    function withdraw1() external;
    function withdraw2() external;
    function withdraw3() external;
    function deposit() external payable;
    function changeOwner(address owner) external;

    error IBank__NotOwner();
    error IBank__withdraw2Failed();
    error IBank__withdraw3Failed();
}

contract Bank {
    BalanceSheet[3] public s_balanceSheet;

    address public s_owner;
    uint256 public s_balance;
    uint256 public s_counter;

    struct BalanceSheet {
        address userAddress;
        uint256 balance;
    }

    modifier M_onlyOwner() {
        if (msg.sender != s_owner) {
            revert IBank.IBank__NotOwner();
        }
        _;
    }

    constructor() {
        changeStoredOwner(msg.sender);
        s_counter = 0;
    }

    fallback() external payable {
        s_counter++;
    }

    receive() external payable {}

    function withdraw1() public M_onlyOwner {
        (payable(msg.sender)).transfer(address(this).balance);
        changeBalance();
    }

    function withdraw2() public M_onlyOwner {
        bool success = (payable(msg.sender)).send(address(this).balance);
        if (!success) {
            revert IBank.IBank__withdraw2Failed();
        }
        changeBalance();
    }

    function withdraw3() public M_onlyOwner {
        (bool success,) = (payable(msg.sender)).call{value: address(this).balance}("");
        if (!success) {
            revert IBank.IBank__withdraw3Failed();
        }
        changeBalance();
    }

    function deposit() public payable virtual {
        insertUser(msg.sender, msg.value);
        changeBalance();
    }

    function changeBalance() internal {
        s_balance = address(this).balance;
    }

    function insertUser(address _address, uint256 _balance) internal {
        uint8 minIndex = 0;
        uint256 minBalance = 0xffffffffffffffff;

        for (uint8 index = 0; index < s_balanceSheet.length; index++) {
            uint256 tmp = s_balanceSheet[index].balance;
            address storedAddress = s_balanceSheet[index].userAddress;
            if (storedAddress == _address) {
                s_balanceSheet[index].balance = tmp + _balance;
                return;
            }
            if (minBalance > tmp) {
                minIndex = index;
                minBalance = tmp;
            }
        }

        if (minBalance < _balance) {
            s_balanceSheet[minIndex] = BalanceSheet({userAddress: _address, balance: _balance});
        }
    }

    function changeStoredOwner(address _address) internal {
        s_owner = _address;
    }
}

contract BigBank is Bank {
    uint256 MIN_DEPOSIT = 0.001 ether;

    error BigBank__notSatisfyMinDeposit();

    modifier M_minDeposit() {
        if (msg.value < MIN_DEPOSIT) {
            revert BigBank__notSatisfyMinDeposit();
        }
        _;
    }

    function deposit() public payable override M_minDeposit {
        insertUser(msg.sender, msg.value);
        changeBalance();
    }

    function changeOwner(address newOwnerAddress) public M_onlyOwner {
        changeStoredOwner(newOwnerAddress);
    }
}

contract Admin {
    address public s_owner;

    error Admin__NotOwner();

    constructor() {
        s_owner = msg.sender;
    }

    modifier M_onlyOwner() {
        if (msg.sender != s_owner) {
            revert Admin__NotOwner();
        }
        _;
    }

    function adminWithdraw(IBank bank) public M_onlyOwner {
        bank.withdraw1();
    }

    fallback() external payable {}

    receive() external payable {}
}
