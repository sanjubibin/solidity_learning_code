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
        Value = msg.value; // value will be non-zero for native "Ether" transaction only
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

        // Check for errors and revert if necessary
        if (!success) {
            // Handle the error, e.g., by reverting with the error data
            return "failed!!!";
        } else {
            return "success!!!";
        }
    }
}