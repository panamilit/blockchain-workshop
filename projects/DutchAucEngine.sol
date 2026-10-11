// SPDX-License-Identifier: MIT

pragma solidity ^0.8.34;


contract DutchAucEngine {
    address public owner;
    uint constant DURATION = 1 days; // by default
    uint constant FEE = 5;

    struct Auction {
        address payable seller;
        uint startingPrice;
        uint finalPrice;
        uint startAt;
        uint endsAt;
        uint discountRate;
        string item;
        bool stopped;
    }


    Auction[] public auctions;


    constructor() {
        owner = msg.sender;
    }
    

    function createAuction(uint _startingPrice, uint _discountRate, string calldata _item, uint _duration) external {

    }

        


}