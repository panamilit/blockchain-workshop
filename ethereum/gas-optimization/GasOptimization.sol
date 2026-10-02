// SPDX-License-Identifier: MIT

pragma solidity ^0.8.34;


contract OptimizedExample {

    // Storage packing

    uint128 public a = 1;
    uint128 public b = 1;
    uint256 public c = 1;


    // Precomputed value

    bytes32 public constant HASH = 0x9c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664fb9a3cb658;


    // Avoid unnecessary intermediate variables

    mapping(address => uint256) public payments;

    function pay() external payable {
        require(msg.sender != address(0), "Zero address");
        payments[msg.sender] = msg.value;
    }


    // Keep simple calculations together

    uint256 public multiplier = 5;
    uint256 public calculationResult;

    function calculate() external {
        uint256 first = 1 * multiplier;
        uint256 second = 2 * multiplier;

        calculationResult = first + second;
    }


    // Reduce repeated storage writes

    uint256 public result = 1;

    function doWork(uint256[] memory data) external {
        uint256 temp = 1;

        for (uint256 i = 0; i < data.length; i++) {
            temp *= data[i];
        }

        result = temp;
    }
}




contract UnoptimizedExample {


    // Storage packing

    uint128 public a = 1;
    uint256 public c = 1;
    uint128 public b = 1;


    // Runtime calculation of a known value

    bytes32 public hash = keccak256(
        abi.encodePacked("test")
    );


    // Unnecessary intermediate variable

    mapping(address => uint256) public payments;

    function pay() external payable {
        address from = msg.sender;

        require(from != address(0), "Zero address");
        payments[from] = msg.value;
    }


    // Split simple calculation into multiple functions

    uint256 public multiplier = 5;
    uint256 public calculationResult;

    function calculate() external {
        uint256 first = 1 * multiplier;
        uint256 second = 2 * multiplier;

        combine(first, second);
    }

    function combine(uint256 first, uint256 second) private {
        calculationResult = first + second;
    }


    // Repeated storage writes inside a loop

    uint256 public result = 1;

    function doWork(uint256[] memory data) external {
        result = 1;

        for (uint256 i = 0; i < data.length; i++) {
            result *= data[i];
        }
    }
}





