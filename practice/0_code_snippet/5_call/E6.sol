pragma solidity ^0.8.0;

contract Callee {
    uint256 public value;

    function setValue(uint256 _newValue) public {
        value = _newValue;
    }
}

contract Caller {
    uint256 public value;

    function delegateSetValue(address callee, uint256 _newValue) public {
        // delegatecall setValue()
        bytes memory setValueABI = abi.encodeWithSignature(
            "setValue(uint256)",
            _newValue
        );
        (bool success, ) = callee.delegatecall(setValueABI);
        require(success, "delegate call failed");
    }
}
