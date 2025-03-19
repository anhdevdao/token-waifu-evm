// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseScript} from "./Base.s.sol";
import {WaifuCollection} from "../src/WaifuCollection.sol";
import {console} from "forge-std/console.sol";

contract DeployWaifuCollection is BaseScript {
    function run() external {
        vm.startBroadcast(deployerKey);

        // Deploy WaifuCollection with constructor parameters
        WaifuCollection collection = new WaifuCollection(
            "", // baseURI (can be set later)
            deployer // initialOwner
        );

        vm.stopBroadcast();

        // Log the address
        console.log("WaifuCollection deployed at:", address(collection));
    }
}
