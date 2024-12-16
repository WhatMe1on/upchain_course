// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

interface ICounter {
    function count() external view returns (uint256);
    function increment() external;
}

contract Counter {
    uint256 public count;

    function increment() external {
        count++;
    }
}

contract Mycount {
    function incrementA(address _counter) external {
        ICounter(_counter).increment();
    }

    function count(address _counter) external {
        ICounter(_counter).count();
    }
}
