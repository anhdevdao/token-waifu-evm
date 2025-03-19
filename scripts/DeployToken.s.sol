// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Token} from "../src/mock/ERC20.sol";
import {console} from "forge-std/console.sol";

contract DeployToken is Script {
    function run() public returns (Token) {
        // Get deployment parameters from environment variables
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Configuration
        string memory name = "Token Waifu";
        string memory symbol = "TWAI";
        uint256 initialSupply = 1_000_000_000; // 1 billion tokens

        vm.startBroadcast(deployerPrivateKey);

        // Deploy the token
        Token token = new Token(name, symbol, initialSupply);

        vm.stopBroadcast();

        // Log the deployment
        console.log("Token deployed to:", address(token));
        console.log("Name:", token.name());
        console.log("Symbol:", token.symbol());
        console.log(
            "Total Supply:",
            token.totalSupply() / 10 ** token.decimals()
        );

        return token;
    }
}
