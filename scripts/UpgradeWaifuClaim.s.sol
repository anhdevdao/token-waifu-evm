// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseScript} from "./Base.s.sol";
import {WaifuClaim} from "../src/WaifuClaim.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {console} from "forge-std/console.sol";

contract UpgradeWaifuClaim is BaseScript {
    function run() external {
        address proxyAddress = vm.envAddress("WAIFU_CLAIM_PROXY");

        vm.startBroadcast(deployerKey);

        // Deploy new implementation
        WaifuClaim newImplementation = new WaifuClaim();

        // Upgrade proxy to new implementation
        UUPSUpgradeable(proxyAddress).upgradeToAndCall(
            address(newImplementation),
            "" // No initialization data needed for upgrade
        );

        vm.stopBroadcast();

        // Log the addresses
        console.log(
            "WaifuClaim New Implementation:",
            address(newImplementation)
        );
        console.log("WaifuClaim Proxy (unchanged):", proxyAddress);
    }
}
