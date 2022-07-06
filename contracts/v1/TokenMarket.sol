pragma solidity ^0.8.0;
// SPDX-License-Identifier: UNLICENSED

import "./Token.sol";

/**
    @title "TokenMarket" contract for managing contracts of all businesses

    Assumptions:
    - every contract and customer Id passed is legitimate

    TODO:
    - return error type for all transactions
    - functions for getting contract details (properties, `Token` contract address)
    - functions for gross information of all deployed contracts
    - copyright license choice
    - data type (uint for ids, int for balances)
    - variables / functions accessibility
 */
contract TokenMarket {

    uint[] public contractIds;
    mapping(uint => Token) private contracts;

    /**
        @notice return if an ID is representing the deployed contract of a business
        @param _contractId contract ID of business
     */
    function isDeployed(uint _contractId) public view returns (bool)
    {
        for (uint i = 0; i < contractIds.length; ++i)
            if (contractIds[i] == _contractId) return true;
        return false;
    }

    /**
        @notice deploy a "Token" contract for a business
        @param _name        name of business
        @param _symbol      symbol of business
        @param _contractId  ID for business (to recognize the contract)
        @dev deployment fails if the contract ID has be used for deployment
     */
    function deployNewToken(string memory _name, string memory _symbol, uint _contractId) public returns (bool)
    {
        require(isDeployed(_contractId) == false);

        contractIds.push(_contractId);
        contracts[_contractId] = new Token(_name, _symbol, _contractId);

        return true;
    }

    /**
        @notice return balance of the specified customer in the specified business contract
        @param _contractId contract ID
        @param _customerId customer ID
     */
    function getBalanceOf(uint _contractId, uint _customerId) public view returns (int) 
    {
        // require();
        require(isDeployed(_contractId) == true);

        return contracts[_contractId].getBalanceOf(_customerId);
    }

    /**
        @notice Top Up for the specified customer in the specified business contract (increase balance)
        @param _contractId contract ID
        @param _customerId customer ID
        @param _amount amount to top up
        @dev if top up inputs are problematic, top up action fails
     */
    function topUp(uint _contractId, uint _customerId, int _amount) public returns (bool)
    {
        // require();
        require(_amount > 0);
        require(isDeployed(_contractId) == true);

        bool success = contracts[_contractId].topUp(_customerId, _amount);
        return success;
    }

    /**
        @notice Pay to shop from customer balance in the specified business contract (decrease balance)
        @param _contractId contract ID
        @param _customerId customer ID
        @param _amount amount to pay
        @dev if payment inputs are problematic, payment action fails
     */
    function payToShop(uint _contractId, uint _customerId, int _amount) public returns (bool)
    {
        // require();
        require(_amount > 0);
        require(isDeployed(_contractId) == true);

        bool success = contracts[_contractId].payToShop(_customerId, _amount);
        return success;
    }
}
