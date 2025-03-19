// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

abstract contract BaseScript is Script {
    // Default values - can be overridden via environment variables
    address public deployer;
    uint256 public deployerKey;

    constructor() {
        deployerKey = vm.envUint("PRIVATE_KEY");
        deployer = vm.addr(deployerKey);
    }

    modifier broadcast() {
        vm.startBroadcast(deployerKey);
        _;
        vm.stopBroadcast();
    }

    function deployUUPSProxy(
        address implementation,
        bytes memory initData
    ) internal returns (address) {
        ERC1967Proxy proxy = new ERC1967Proxy(implementation, initData);
        return address(proxy);
    }
}
