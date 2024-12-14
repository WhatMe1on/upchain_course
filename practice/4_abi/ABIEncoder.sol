pragma solidity ^0.8.0;

contract ABIEncoder {
    function encodeUint(uint256 value) public pure returns (bytes memory) {
        return
            abi.encodeWithSelector(this.encodeUint.selector, abi.encode(value));
    }

    function encodeMultiple(
        uint num,
        string memory text
    ) public pure returns (bytes memory) {
        return
            abi.encodeWithSelector(
                this.encodeMultiple.selector,
                abi.encode(num),
                abi.encode(text)
            );
    }
}

contract ABIDecoder {
    function decodeUint(bytes memory data) public pure returns (uint) {
        return abi.decode(data, (uint256));
    }

    function decodeMultiple(
        bytes memory data
    ) public pure returns (uint, string memory) {
        return abi.decode(data, (uint, string));
    }
}
