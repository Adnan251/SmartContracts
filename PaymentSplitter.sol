//SPDX-License-Identifier: MIT
pragma solidity^0.8.7;

contract Paymentsplitter{
    address[] private recipiants;
    address private owner;
    uint256 private amount;

    constructor(){
        owner = msg.sender;
        amount = 0;
    }

    modifier isOwner{
        require(msg.sender == owner, "You are NOT the owner");
        _;
    }

    function addAcount(address payable _add) public isOwner {
        for(uint256 i = 0; i < recipiants.length; i++){
            if(_add == recipiants[i]){
                revert("The Address ia already added");
            }
        }      
        recipiants.push(_add);
    }

    function getArrSize()external view returns(uint){
        return recipiants.length;
    }

    function getAmount() payable external{
        amount = msg.value;
    }

    function splitAmount() private view returns(uint256){
        return amount / recipiants.length;
    }

    function sendMoneyToAcc() payable public{
        for(uint256 i = 0; i < recipiants.length; i++){
            (bool sent,) = recipiants[i].call{value: splitAmount()}("");
            require(sent, "Failed to send Ether");
        }
    }
}
