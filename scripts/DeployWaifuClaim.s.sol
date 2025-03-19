// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseScript} from "./Base.s.sol";
import {WaifuClaim} from "../src/WaifuClaim.sol";
import {console} from "forge-std/console.sol";

contract DeployWaifuClaim is BaseScript {
    function run() external {
        // Deploy implementation
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        address deployer = vm.addr(deployerPrivateKey);
        uint256 operatorPrivateKey = vm.envUint("OPERATOR_PRIVATE_KEY");
        address operator = vm.addr(operatorPrivateKey);

        WaifuClaim implementation = new WaifuClaim();

        // Initialize proxy with implementation
        bytes memory initData = abi.encodeWithSelector(
            WaifuClaim.initialize.selector,
            deployer, // owner,
            operator // operator
        );

        address proxy = deployUUPSProxy(address(implementation), initData);

        vm.stopBroadcast();

        // Log the addresses
        console.log("WaifuClaim Implementation:", address(implementation));
        console.log("WaifuClaim Proxy:", proxy);
    }
}
