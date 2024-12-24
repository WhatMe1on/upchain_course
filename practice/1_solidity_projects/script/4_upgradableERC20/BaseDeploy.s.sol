// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Script.sol";

contract BaseDeploy is Script {
    function run() external {
        // 读取环境变量
        string memory envValue = vm.envString("ENV_VAR_NAME");

        // 开始广播交易
        vm.startBroadcast();

        // 部署合约并传入环境变量参数
        // MyContract myContract = new MyContract(envValue);

        // 结束广播交易
        vm.stopBroadcast();

        console.log("Contract deployed at:", address(myContract));
    }
}
