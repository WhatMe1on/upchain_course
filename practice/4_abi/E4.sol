// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataStorage {
    string private data;

    function setData(string memory newData) public {
        data = newData;
    }

    function getData() public view returns (string memory) {
        return data;
    }
}

contract DataConsumer {
    address private dataStorageAddress;

    constructor(address _dataStorageAddress) {
        dataStorageAddress = _dataStorageAddress;
    }

    function getDataByABI() public returns (string memory) {
        // payload
        bytes memory payload = abi.encodeWithSignature("getData()");
        // bytes memory payload = abi.encodeWithSelector(this.getData.selector);
        (bool success, bytes memory data) = dataStorageAddress.call(payload);
        require(success, "call function failed");
        
        // return data
        string memory returnData = abi.decode(data, (string));
        return returnData;
    }

    function setDataByABI1(string calldata newData) public returns (bool) {
        // playload
        bytes memory payload = abi.encodeWithSignature("setData(string)", newData);
        // bytes memory payload = abi.encodeWithSelector(this.getData.selector);
        (bool success, ) = dataStorageAddress.call(payload);

        return success;
    }

    function setDataByABI2(string calldata newData) public returns (bool) {
        // selector
        // playload
        bytes memory payload = abi.encodeWithSelector(DataStorage.setData.selector, newData);
        (bool success, ) = dataStorageAddress.call(payload);

        return success;
    }

    function setDataByABI3(string calldata newData) public returns (bool) {
        // playload
        bytes memory playload = abi.encodeCall(DataStorage.setData, newData);
        (bool success, ) = dataStorageAddress.call(playload);
        return success;
    }
}
