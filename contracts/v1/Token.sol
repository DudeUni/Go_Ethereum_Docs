pragma solidity ^0.8.0;
// SPDX-License-Identifier: UNLICENSED

/**
    @title "Token" contract for a registered business

    Assumptions:
    - every contract and customer Id passed is legitimate

    TODO:
    - return error type for all transactions
    - copyright license choice
    - data type (uint for ids, int for balances)
    - variables / functions accessibility
    - more verification during function calls
    - notification event when balance = 0
*/
contract Token {

    string      private     name;
    string      private     symbol;
    uint        private     numTransaction;
    address     private     businessWalletAddress;

    int constant private customerLimit = 1000;

    mapping(uint => int) public balances;

    /**
        @notice contractor function: deploying a "Token" contract for a business
        @param _name name of business
        @param _symbol symbol of business
        @param _businessWalletAddress wallet address of business
     */
    constructor(string memory _name, string memory _symbol, address _businessWalletAddress)
    {
        require(isContract(msg.sender) == true);
        require(isContract(tx.origin) == false);
        require(_businessWalletAddress == tx.origin);

        name        = _name;
        symbol      = _symbol;

        numTransaction = 0;

        businessWalletAddress = _businessWalletAddress;
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

    /// @notice return name of business
    function getName()         public view returns (string memory) { return name; }
    /// @notice return symbol of business
    function getSymbol()       public view returns (string memory) { return symbol; }
    /// @notice return number of transactions called by business
    function getNumTransact()  public view returns (uint)          { return numTransaction; }
    /// @notice return the address of "TokenMarket" contract that deploys "Token" contract for this business
    function getBusinessAddr() public view returns (address)       { return businessWalletAddress; }

    /**
        @notice return balance of the specified customer
        @param _customerId customer ID
     */
    function getBalanceOf(uint _customerId) public view returns (int)
    {
        // require();
        require(tx.origin == businessWalletAddress);

        return balances[_customerId];
    }

    /**
        @notice Top Up for the specified customer (increase balance)
        @param _customerId customer ID
        @param _amount amount to top up
        @dev if new balance < original balance, top up action fails due to potential integer overflow
        @dev if new balance exceeds limit, top up action fails 
     */
    function topUp(uint _customerId, int _amount) public returns (bool)
    {        
        // require();
        require(tx.origin == businessWalletAddress);
        require(_amount > 0);

        require(balances[_customerId] + _amount >= balances[_customerId]);
        require(balances[_customerId] + _amount <= customerLimit);

        balances[_customerId] += _amount;

        ++numTransaction;

        return true;
    }

    /**
        @notice Pay to shop from customer balance (decrease balance)
        @param _customerId customer ID
        @param _amount amount to pay
        @dev if new balance > original balance, payment action fails due to potential integer overflow
        @dev if new balance is lower than 0, payment action fails due to insufficient balance
     */
    function payToShop(uint _customerId, int _amount) public returns (bool)
    {
        // require();
        require(tx.origin == businessWalletAddress);
        require(_amount > 0);

        require(balances[_customerId] - _amount <= balances[_customerId]);
        require(balances[_customerId] - _amount >= 0);

        balances[_customerId] -= _amount;

        // emit notification if balance == 0

        ++numTransaction;

        return true;
    }
}
