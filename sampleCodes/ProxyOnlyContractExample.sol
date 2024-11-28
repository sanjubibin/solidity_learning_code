// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// implementation contract 
contract logicV1 {
    uint public addOn;
    address public Address;
    uint public Value;

    function setValues(uint _no) public payable {
        addOn = _no;
        Address = msg.sender; // address of the interactor
        Value = msg.value; // value will be zero for native "non Ether" transaction
    }
}
// proxy contract 
contract delegateLogicV1 {
    uint public addOn;
    address public Address;
    uint public Value;

    function setValues(address _implementation, uint _valueToAdd) public payable returns(bytes memory){
        (bool success, ) = _implementation.delegatecall(
            // this "delegatecall" calls the implemenation contract funtions and execute inside the this proxy contract
            // -> that means even the storage is inside the proxy.
            abi.encodeWithSignature("setValues(uint256)", _valueToAdd)
        );

        // returns string msg indicating success or failure
        if (!success) {
            return "failed!!!";
        } else {
            return "success!!!";
        }
    }
}