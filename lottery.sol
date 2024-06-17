// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public participants;

    constructor() {
        manager = msg.sender; //global variable
    }

    receive() external payable {
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint) {
        //require is similiar as if-else
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public  view returns (uint) {
        // Use blockhash and block.number to increase randomness slightly
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, blockhash(block.number - 1), participants.length)));
    }

    function selectwinner() public {
        require(msg.sender == manager);
        require(participants.length>=3);
        uint r = random();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants=new address payable[](0);
    }
}
