pragma solidity ^0.8.0;
// SPDX-License-Identifier: UNLICENSED

import "./Token.sol";

/**
    @title "TokenMarket" contract for managing contracts of all businesses

    Assumptions:
    - every customer Id and business wallet address passed is legitimate
    - each business is identified by wallet address

    TODO:
    - return error type for all transactions
    - copyright license choice
    - data type (uint for ids, int for balances)
    - variables / functions accessibility
    - more verification during function calls
    - notification event when balance = 0
    - functions for getting contract details (properties, `Token` contract address)
    - functions for gross information of all deployed contracts
 */
contract TokenMarket {

    address private superUserAddress;

    address[] private businessWalletAddresses;
    mapping(address => Token) private contracts;

    /**
        @notice contractor function: deploying a "TokenMarket" contract
     */
    constructor()
    {
        require (isContract(msg.sender) == false);
        superUserAddress = msg.sender;
    }

    /**
        @notice return if an address represents a contract or not
        @param _addr target address to check
     */
    function isContract(address _addr) private view returns (bool)
    {
        uint size;
        assembly { size := extcodesize(_addr)}
        return size > 0;
    }

    /**
        @notice return if the current wallet is the super user of this contract
     */ 
    function isSuperUser() public view returns (bool) { return msg.sender == superUserAddress; }

    /**
        @notice return if an ID is representing the deployed contract of a business
        @param _walletAddress wallet address of business
     */
    function isDeployed(address _walletAddress) public view returns (bool)
    {
        for (uint i = 0; i < businessWalletAddresses.length; ++i)
            if (businessWalletAddresses[i] == _walletAddress) return true;
        return false;
    }

    /**
        @notice deploy a "Token" contract for a business
        @param _name name of business
        @param _symbol symbol of business
        @param _walletAddress wallet address business (to recognize the contract)
        @dev deployment fails if the calling wallet has deployed a contract before
     */
    function deployNewToken(string memory _name, string memory _symbol, address _walletAddress) public returns (bool)
    {
        require(isDeployed(_walletAddress) == false);

        businessWalletAddresses.push(_walletAddress);
        contracts[_walletAddress] = new Token(_name, _symbol, _walletAddress);

        return true;
    }

    /**
        @notice return balance of the specified customer in the specified business contract
        @param _walletAddress wallet address of business
        @param _customerId customer ID
     */
    function getBalanceOf(address _walletAddress, uint _customerId) public view returns (int) 
    {
        // require();
        require(tx.origin == contracts[_walletAddress].getBusinessAddr());
        require(isDeployed(_walletAddress) == true);

        return contracts[_walletAddress].getBalanceOf(_customerId);
    }

    /**
        @notice Top Up for the specified customer in the specified business contract (increase balance)
        @param _walletAddress wallet address of business
        @param _customerId customer ID
        @param _amount amount to top up
        @dev if top up inputs are problematic, top up action fails
     */
    function topUp(address _walletAddress, uint _customerId, int _amount) public returns (bool)
    {
        // require();
        require(tx.origin == contracts[_walletAddress].getBusinessAddr());
        require(_amount > 0);
        require(isDeployed(_walletAddress) == true);

        bool success = contracts[_walletAddress].topUp(_customerId, _amount);
        return success;
    }

    /**
        @notice Pay to shop from customer balance in the specified business contract (decrease balance)
        @param _walletAddress wallet address of business
        @param _customerId customer ID
        @param _amount amount to pay
        @dev if payment inputs are problematic, payment action fails
     */
    function payToShop(address _walletAddress, uint _customerId, int _amount) public returns (bool)
    {
        // require();
        require(tx.origin == contracts[_walletAddress].getBusinessAddr());
        require(_amount > 0);
        require(isDeployed(_walletAddress) == true);

        bool success = contracts[_walletAddress].payToShop(_customerId, _amount);
        return success;
    }
}
