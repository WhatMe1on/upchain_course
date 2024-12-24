// https://decert.me/challenge/8867a83b-c3ba-43e2-afa7-324a7d5dcdc6
pragma solidity ^0.8.0;

library Math {
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}

contract LibraryExample {
    // 使用库
    using Math for uint256;

    function max(uint256 x, uint256 y) public pure returns (uint256) {
        //
        return x.max(y);
    }

    function min(uint256 x, uint256 y) public pure returns (uint256) {
        //
        return x.min(y);
    }
}
