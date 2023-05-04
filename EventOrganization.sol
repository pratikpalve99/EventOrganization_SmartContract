// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Event_organization {
    struct Event {
        address organizer;
        string name;
        uint date;
        uint prize;
        uint ticketCount;
        uint ticketRemaining;
    }

    mapping(uint => Event) public events;
    mapping(address => mapping(uint => uint)) public tickets;
    uint public nextId;

    function createEvent(
        string memory name,
        uint date,
        uint price,
        uint ticketCount
    ) external {
        require(date > block.timestamp, "Enter appropriate date");
        require(ticketCount > 0, "Number of ticket should be more than zero");
        events[nextId] = Event(
            msg.sender,
            name,
            date,
            price,
            ticketCount,
            ticketCount
        );
    }

    function buyTicket(uint id, uint quantity) external payable {
        require(events[id].date != 0, "Event does not exist");
        require(events[id].date > block.timestamp, "Event already occured");
        Event storage _event = events[id];
        require(msg.sender == (_event.prize * quantity), "Ether is not enough");
        require(_event.ticketRemaining >= quantity, "Not enough tickets");
        _event.ticketRemaining -= quantity;
        tickets[msg.sender][id] += quantity;
    }

    function transferTicket(uint id, uint quantity, address to) external {
        require(events[id].date != 0, "Event does not exist");
        require(events[id].date > block.timestamp, "Event already occured");
        require(
            tickets[msg.sender][id] > quantity,
            "You do not have enough tickets"
        );
        tickets[msg.sender][id] -= quantity;
        tickets[to][id] += quantity;
    }
}
