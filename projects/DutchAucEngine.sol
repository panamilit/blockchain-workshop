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

    event AuctionCreated(uint indexed index, string itemDescription, uint indexed startingPrice, uint duration);

    constructor() {
        owner = msg.sender;
    }
    

    function createAuction(uint _startingPrice, uint _discountRate, string calldata _item, uint _duration) external {

        uint duration;

        if (_duration == 0) {
            duration = DURATION;
        } else {
            duration = _duration;
        }

        require(_startingPrice >= _discountRate * duration, "Incorrect starting price");

        Auction memory newAuction = Auction(
            {
                seller: payable(msg.sender),
                startingPrice: _startingPrice,
                finalPrice: _startingPrice,
                discountRate: _discountRate,
                startAt: block.timestamp, // now
                endsAt: block.timestamp + duration,
                item: _item,
                stopped: false

            }
        );

        auctions.push(newAuction);

        emit AuctionCreated(auctions.length - 1, _item, _startingPrice, duration);

    }

    function getPriceFor(uint index) public view returns(uint) {
        Auction memory currentAuction = auctions[index];

        require(!currentAuction.stopped, "Auction is stopped");

        uint elapsed = block.timestamp - currentAuction.startAt;
        uint discount = currentAuction.discountRate * elapsed;

        return currentAuction.startingPrice - discount;

    }


}