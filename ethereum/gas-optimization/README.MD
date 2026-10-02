# Solidity Gas Optimization

This example compares several Solidity patterns that can affect gas usage.

The goal is to understand how storage layout, repeated storage access, unnecessary variables, and runtime calculations can influence contract deployment and execution costs.

## Examples Included

### 1. Storage Packing

Solidity storage is divided into 32-byte slots.

Smaller variables can share the same storage slot when they are placed next to each other and their combined size fits within 32 bytes.

Optimized:

```solidity
uint128 public a = 1;
uint128 public b = 1;
uint256 public c = 1;
```

Here, `a` and `b` can share one storage slot.

Less optimized:

```solidity
uint128 public a = 1;
uint256 public c = 1;
uint128 public b = 1;
```

The `uint256` variable between `a` and `b` prevents them from being packed together.

---

### 2. Precomputed Values

If a value is known in advance, it may be unnecessary to calculate it during contract deployment.

Example:

```solidity
bytes32 public constant HASH = 0x9c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664fb9a3cb658;
```

Instead of:

```solidity
bytes32 public hash = keccak256(
    abi.encodePacked("test")
);
```

This avoids performing the hash calculation during initialization.

---

### 3. Avoiding Unnecessary Intermediate Variables

Creating a local variable is not always necessary when the value can be used directly.

Instead of:

```solidity
address from = msg.sender;

require(from != address(0), "Zero address");
payments[from] = msg.value;
```

the value can be accessed directly:

```solidity
require(msg.sender != address(0), "Zero address");
payments[msg.sender] = msg.value;
```

Local variables are not inherently bad, however. They can be useful when they reduce repeated expensive operations, especially storage access.

---

### 4. Avoiding Unnecessary Function Calls

Simple calculations do not always need to be split across multiple internal or private functions.

For small operations, keeping the calculation together can reduce unnecessary execution overhead and make the flow easier to follow.

However, readability and maintainability should not be sacrificed for minor gas savings.

---

### 5. Reducing Storage Writes

Storage operations are among the most expensive operations in Solidity.

Updating a state variable on every loop iteration can be significantly more expensive than performing the calculation using a local variable.

Less optimized:

```solidity
for (uint256 i = 0; i < data.length; i++) {
    result *= data[i];
}
```

Here, `result` is a state variable stored in contract storage.

A better approach:

```solidity
uint256 temp = 1;

for (uint256 i = 0; i < data.length; i++) {
    temp *= data[i];
}

result = temp;
```

The calculation is performed locally, and storage is updated only once after the loop finishes.

---

## Additional Notes

Some other useful gas-related principles include:

- State variables already have default values, so explicitly assigning values such as `0` or `false` may be unnecessary.
- Smaller integer types such as `uint8` or `uint128` are most useful for gas optimization when they allow multiple values to be packed into the same storage slot.
- Smaller integer types are not automatically cheaper in every situation.
- Dynamic arrays and large amounts of on-chain data can be expensive.
- Long revert strings increase contract bytecode size.
- Large datasets should generally not be stored directly on-chain.
- Gas optimization should come after correctness, security, and clear contract design.
