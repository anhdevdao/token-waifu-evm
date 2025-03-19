// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin-upgradeable/contracts/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin-upgradeable/contracts/utils/PausableUpgradeable.sol";
import "@openzeppelin-upgradeable/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin-upgradeable/contracts/utils/cryptography/EIP712Upgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract WaifuClaim is
    Initializable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable,
    UUPSUpgradeable,
    EIP712Upgradeable
{
    using ECDSA for bytes32;

    bytes32 private constant CLAIM_TYPEHASH =
        keccak256(
            "Claim(address user,address token,uint256 amount,uint256 nonce)"
        );

    address public operator;
    mapping(address => bool) public allowedTokens;
    mapping(address => mapping(uint256 => bool)) public usedNonces;

    event TokenAdded(address indexed token);
    event TokenRemoved(address indexed token);
    event OperatorUpdated(
        address indexed oldOperator,
        address indexed newOperator
    );
    event TokensClaimed(
        address indexed user,
        address indexed token,
        uint256 amount,
        uint256 nonce
    );

    error InvalidSignature();
    error NonceAlreadyUsed();
    error TokenNotAllowed();
    error InsufficientContractBalance();
    error TransferFailed();

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        address initialOwner,
        address initialOperator
    ) public initializer {
        __Ownable_init(initialOwner);
        __ReentrancyGuard_init();
        __Pausable_init();
        __UUPSUpgradeable_init();
        __EIP712_init("WaifuClaim", "1");

        operator = initialOperator;
    }

    function addAllowedToken(address token) external onlyOwner {
        allowedTokens[token] = true;
        emit TokenAdded(token);
    }

    function removeAllowedToken(address token) external onlyOwner {
        allowedTokens[token] = false;
        emit TokenRemoved(token);
    }

    function setOperator(address newOperator) external onlyOwner {
        address oldOperator = operator;
        operator = newOperator;
        emit OperatorUpdated(oldOperator, newOperator);
    }

    function claimTokens(
        address token,
        uint256 amount,
        uint256 nonce,
        bytes calldata signature
    ) external nonReentrant whenNotPaused {
        if (!allowedTokens[token]) revert TokenNotAllowed();
        if (usedNonces[msg.sender][nonce]) revert NonceAlreadyUsed();

        bytes32 structHash = keccak256(
            abi.encode(CLAIM_TYPEHASH, msg.sender, token, amount, nonce)
        );
        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = ECDSA.recover(hash, signature);

        if (signer != operator) revert InvalidSignature();

        usedNonces[msg.sender][nonce] = true;

        uint256 contractBalance = IERC20(token).balanceOf(address(this));
        if (contractBalance < amount) revert InsufficientContractBalance();

        bool success = IERC20(token).transfer(msg.sender, amount);
        if (!success) revert TransferFailed();

        emit TokensClaimed(msg.sender, token, amount, nonce);
    }

    function isNonceUsed(
        address user,
        uint256 nonce
    ) external view returns (bool) {
        return usedNonces[user][nonce];
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function emergencyWithdraw(
        address token,
        address to,
        uint256 amount
    ) external onlyOwner {
        bool success = IERC20(token).transfer(to, amount);
        if (!success) revert TransferFailed();
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    uint256[50] private __gap;
}
