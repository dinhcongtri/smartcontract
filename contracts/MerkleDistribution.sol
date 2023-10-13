// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract MerkleDistribution {
    IERC20 public token;
    bytes32 public root;
    address private owner;
    mapping(address => bool) public claimed;

    event Claim(address indexed receiver, uint amount);

    constructor(address tokenAddress, bytes32 merkleRoot) {
        token = IERC20(tokenAddress);
        root = merkleRoot;
        owner = msg.sender;
    }

    function claim(uint amount, bytes32[] calldata proofs, address claimerAddress) public {
        require(!claimed[claimerAddress], 'You already claimed your tokens.');
        // Verify proofs
        bytes32 node = keccak256(abi.encodePacked(claimerAddress, amount));
        for (uint i = 0; i < proofs.length; i++) {
            node = keccak256(abi.encodePacked(node ^ proofs[i]));
        }
        require(node == root, 'Invalid merkle root.');
        // Send tokens
        claimed[claimerAddress] = true;
        token.transfer(claimerAddress, amount);
        emit Claim(claimerAddress, amount);
    }

    function withdraw() public {
        require(msg.sender == owner, 'Only the owner can withdraw!');
        token.transfer(owner, token.balanceOf(address(this)));
    }
}