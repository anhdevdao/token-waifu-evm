// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/WaifuClaim.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract TestToken is ERC20 {
    constructor() ERC20("Test Token", "TEST") {
        _mint(msg.sender, 1_000_000 * 10 ** 18);
    }
}

contract WaifuClaimTest is Test {
    WaifuClaim public implementation;
    WaifuClaim public claimContract;
    ERC1967Proxy public proxy;
    TestToken public token;

    address public owner = address(1);
    address public user = address(3);
    uint256 public operatorPrivateKey = 0xA11CE;
    address public operator;

    bytes32 private constant CLAIM_TYPEHASH =
        keccak256(
            "Claim(address user,address token,uint256 amount,uint256 nonce)"
        );

    bytes32 private constant EIP712DOMAIN_TYPEHASH =
        keccak256(
            "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
        );

    function setUp() public {
        // Set operator's address based on private key
        operator = vm.addr(operatorPrivateKey);

        vm.startPrank(owner);

        implementation = new WaifuClaim();

        bytes memory initData = abi.encodeWithSelector(
            WaifuClaim.initialize.selector,
            owner,
            operator
        );

        proxy = new ERC1967Proxy(address(implementation), initData);

        claimContract = WaifuClaim(address(proxy));
        token = new TestToken();

        claimContract.addAllowedToken(address(token));
        token.transfer(address(claimContract), 100_000 * 10 ** 18);

        vm.stopPrank();
    }

    function testInitialization() public view {
        assertEq(claimContract.owner(), owner);
        assertEq(claimContract.operator(), operator);
        assertTrue(claimContract.allowedTokens(address(token)));
    }

    function testAddRemoveAllowedToken() public {
        address newToken = address(0x123);

        vm.startPrank(owner);
        claimContract.addAllowedToken(newToken);
        assertTrue(claimContract.allowedTokens(newToken));

        claimContract.removeAllowedToken(newToken);
        assertFalse(claimContract.allowedTokens(newToken));
        vm.stopPrank();
    }

    function testSetOperator() public {
        address newOperator = address(0x456);

        vm.startPrank(owner);
        claimContract.setOperator(newOperator);
        assertEq(claimContract.operator(), newOperator);
        vm.stopPrank();
    }

    function testClaimTokens() public {
        uint256 amount = 1000 * 10 ** 18;
        uint256 nonce = 1;

        bytes32 digest = _getDigest(user, address(token), amount, nonce);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(operatorPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        uint256 initialBalance = token.balanceOf(user);

        vm.prank(user);
        claimContract.claimTokens(address(token), amount, nonce, signature);

        assertEq(token.balanceOf(user), initialBalance + amount);
        assertTrue(claimContract.isNonceUsed(user, nonce));
    }

    function testPreventReplayAttack() public {
        uint256 amount = 1000 * 10 ** 18;
        uint256 nonce = 1;

        bytes32 digest = _getDigest(user, address(token), amount, nonce);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(operatorPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        vm.prank(user);
        claimContract.claimTokens(address(token), amount, nonce, signature);

        vm.expectRevert();
        vm.prank(user);
        claimContract.claimTokens(address(token), amount, nonce, signature);
    }

    function testPauseUnpause() public {
        vm.startPrank(owner);
        claimContract.pause();
        assertTrue(claimContract.paused());

        claimContract.unpause();
        assertFalse(claimContract.paused());
        vm.stopPrank();
    }

    function testCannotClaimWhenPaused() public {
        uint256 amount = 1000 * 10 ** 18;
        uint256 nonce = 1;

        bytes32 digest = _getDigest(user, address(token), amount, nonce);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(operatorPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        vm.prank(owner);
        claimContract.pause();

        vm.expectRevert();
        vm.prank(user);
        claimContract.claimTokens(address(token), amount, nonce, signature);
    }

    function _getDigest(
        address userAddress,
        address tokenAddress,
        uint256 amount,
        uint256 nonce
    ) internal view returns (bytes32) {
        bytes32 structHash = keccak256(
            abi.encode(CLAIM_TYPEHASH, userAddress, tokenAddress, amount, nonce)
        );

        bytes32 domainSeparator = keccak256(
            abi.encode(
                EIP712DOMAIN_TYPEHASH,
                keccak256(bytes("WaifuClaim")),
                keccak256(bytes("1")),
                block.chainid,
                address(claimContract)
            )
        );

        return
            keccak256(
                abi.encodePacked("\x19\x01", domainSeparator, structHash)
            );
    }
}
