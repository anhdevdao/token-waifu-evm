// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {ERC20} from "../src/mock/ERC20.sol";

contract DeployToken is Script {
    function run() public returns (ERC20) {
        // Get deployment parameters from environment variables
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Configuration
        string memory name = "Token Waifu";
        string memory symbol = "TWAI";
        uint256 initialSupply = 1_000_000_000; // 1 billion tokens

        vm.startBroadcast(deployerPrivateKey);

        // Deploy the token
        ERC20 token = new ERC20(name, symbol, initialSupply);

        vm.stopBroadcast();

        // Log the deployment
        console2.log("Token deployed to:", address(token));
        console2.log("Name:", token.name());
        console2.log("Symbol:", token.symbol());
        console2.log(
            "Total Supply:",
            token.totalSupply() / 10 ** token.decimals()
        );

        return token;
    }
}
