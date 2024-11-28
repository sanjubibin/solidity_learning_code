// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// This contarct explain about them storage bridge between implementation and proxy contracts

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

// proxy contract's
// delegate call 
// with same storage variable with same name as in the proxy contract 
contract delegate1LogicV1 {
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

// with different storage variable name but same varibale type as it is in implemenation
contract delegate2LogicV1 {
    uint public check1;
    address public check2;
    uint public check3;

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

// with different storage variable name but same varibale type as it is in implemenation
contract delegate3LogicV1 {
    bool public check1; // changes: changed the variable type to bool and it will work fine with true for non '0' integers and false for '0'
    address public check2;
    uint public check3;

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