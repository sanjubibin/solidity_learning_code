pragma solidity ^0.8.28;


// common proxy contract template with delegate call
contract Proxy {
    // Storage slot for the address of the current implementation contract
    address internal implementation;

    /**
     * @dev Sets the initial implementation address.
     * @param _implementation The address of the initial implementation contract.
     */
    constructor(address _implementation) {
        implementation = _implementation;
    }

    /**
     * @dev Updates the implementation address, allowing the proxy to be upgraded.
     * @param _newImplementation The address of the new implementation contract.
     */
    function upgradeLogic(address _newImplementation) external{
        require(_newImplementation != address(0), "New implementation address cannot be zero");
        implementation = _newImplementation;
    }

    function getLogicContractAddress() external view  returns(address) {
        return implementation;
    }

    /**
     * @dev Fallback function that delegates calls to the implementation contract.
     * It supports any kind of function calls, returning data if there is any.
     */
    fallback() external payable {
        _delegate(implementation);
    }

    /**
     * @dev Function that handles both receiving and forwarding calls to the implementation contract.
     */
    receive() external payable {
        _delegate(implementation);
    }

    /**
     * @dev Performs a delegatecall to the implementation contract.
     * This function forwards all available gas and reverts on errors.
     * @param _impl Address of the implementation contract to delegate the call to.
     */
    function _delegate(address _impl) public {
        require(_impl != address(0), "Implementation address is not set");

        // Delegate the call to the implementation contract
        assembly {
            // Copy msg.data (input data) into memory
            calldatacopy(0, 0, calldatasize())

            // Call the implementation contract using delegatecall
            let result := delegatecall(gas(), _impl, 0, calldatasize(), 0, 0)

            // Copy the returned data into memory
            returndatacopy(0, 0, returndatasize())

            // If the call succeeded, return the data
            if result {
                return(0, returndatasize())
            }
            // If the call failed, revert with the returned data
            revert(0, returndatasize())
        }
    }