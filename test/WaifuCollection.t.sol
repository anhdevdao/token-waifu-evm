// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/WaifuCollection.sol";

contract WaifuCollectionTest is Test {
    WaifuCollection public nft;
    address public owner = address(1);
    address public user = address(2);

    function setUp() public {
        vm.startPrank(owner);
        nft = new WaifuCollection("https://waifu.collection/metadata/", owner);
        vm.stopPrank();
    }

    function testInitialState() public view {
        assertEq(nft.name(), "WaifuCollection");
        assertEq(nft.symbol(), "WAIFU");
        assertEq(nft.getCurrentTokenId(), 0);
        assertEq(nft.owner(), owner);
    }

    function testMint() public {
        vm.startPrank(owner);
        uint256 tokenId = nft.mint(user);
        vm.stopPrank();

        assertEq(tokenId, 0);
        assertEq(nft.ownerOf(0), user);
        assertEq(nft.getCurrentTokenId(), 1);
    }

    function testBatchMint() public {
        vm.startPrank(owner);
        uint256 startTokenId = nft.batchMint(user, 5);
        vm.stopPrank();

        assertEq(startTokenId, 0);
        assertEq(nft.balanceOf(user), 5);

        for (uint256 i = 0; i < 5; i++) {
            assertEq(nft.ownerOf(i), user);
        }

        assertEq(nft.getCurrentTokenId(), 5);
    }

    function testSetBaseURI() public {
        vm.startPrank(owner);
        nft.setBaseURI("https://new.waifu.collection/metadata/");
        uint256 tokenId = nft.mint(user);
        vm.stopPrank();

        assertEq(
            nft.tokenURI(tokenId),
            "https://new.waifu.collection/metadata/0"
        );
    }

    function testOnlyOwnerCanMint() public {
        vm.startPrank(user);
        vm.expectRevert();
        nft.mint(user);
        vm.stopPrank();
    }

    function testOnlyOwnerCanBatchMint() public {
        vm.startPrank(user);
        vm.expectRevert();
        nft.batchMint(user, 5);
        vm.stopPrank();
    }

    function testOnlyOwnerCanSetBaseURI() public {
        vm.startPrank(user);
        vm.expectRevert();
        nft.setBaseURI("https://hacked.com/metadata/");
        vm.stopPrank();
    }

    function testFuzz_BatchMint(uint256 amount) public {
        vm.assume(amount > 0 && amount <= 100);

        vm.startPrank(owner);
        uint256 startTokenId = nft.batchMint(user, amount);
        vm.stopPrank();

        assertEq(startTokenId, 0);
        assertEq(nft.balanceOf(user), amount);
        assertEq(nft.getCurrentTokenId(), amount);
    }
}
