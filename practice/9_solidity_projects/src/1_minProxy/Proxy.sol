// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

contract Proxy {
    using Clones for address;

    address s_implementsAddress;

    constructor(address _implementAddress) {
        s_implementsAddress = _implementAddress;
    }

    fallback() external payable {
        address _implementation = s_implementsAddress;
    }
}
