// https://decert.me/challenge/10c11aa7-2ccd-4bcc-8ccd-56b51f0c12b8
pragma solidity ^0.8.0;

contract ABIEncoder {
    function encodeUint(uint256 value) public pure returns (bytes memory) {
        return abi.encode(value);
    }

    function encodeMultiple(
        uint num,
        string memory text
    ) public pure returns (bytes memory) {
        return abi.encode(num, text);
    }
}

contract ABIDecoder {
    function decodeUint(bytes memory data) public pure returns (uint) {
        uint256 value = abi.decode(data, (uint256));
        return value;
    }

    function decodeMultiple(
        bytes memory data
    ) public pure returns (uint, string memory) {
        (uint256 x, string memory y) = abi.decode(data, (uint256, string));
        return (x, y);
    }
}
