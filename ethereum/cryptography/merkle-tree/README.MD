# Merkle Tree

A simple Solidity implementation of a Merkle tree with transaction hashing and Merkle proof verification.

## Overview

The contract builds a Merkle tree from a fixed set of example transactions. Each transaction is hashed using `keccak256`, and the resulting hashes are combined in pairs until a single Merkle root is produced.

The contract also includes a `verify` function that can verify whether a transaction belongs to a Merkle tree using a Merkle proof.

## Tree Structure

For four transactions, the tree has the following structure:

                    Root
                   /    \
                H1-2    H3-4
                /  \    /  \
              H1   H2  H3   H4
              |    |   |    |
             TX1  TX2 TX3  TX4

Changing any transaction changes its hash and consequently changes the Merkle root.

## Features

- Hashes transactions using `keccak256`
- Encodes data using `abi.encodePacked`
- Builds a Merkle tree from transaction hashes
- Stores each level of the tree in a dynamic `bytes32` array
- Verifies transactions using Merkle proofs
- Determines hash order using the transaction index

## Verification

The `verify` function takes:

- `transaction` - transaction data to verify
- `index` - position of the transaction in the tree
- `root` - expected Merkle root
- `proof` - hashes required to reconstruct the path to the root

The transaction is hashed first. Each proof element is then combined with the current hash.

The transaction index determines the order:

- Even index → `hash(currentHash, proofElement)`
- Odd index → `hash(proofElement, currentHash)`

After each level, the index is divided by two.

If the final calculated hash matches the supplied root, the proof is valid.

## Concepts Practiced

- Merkle trees
- Merkle roots
- Merkle proofs
- `keccak256`
- `abi.encodePacked`
- `bytes` and `bytes32`
- Dynamic arrays
- `for` and `while` loops
- `pure` functions

## Notes

This contract is a learning implementation designed to demonstrate how Merkle trees and Merkle proofs work in Solidity.

