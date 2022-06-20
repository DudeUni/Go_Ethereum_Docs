pragma solidity ^0.5.16;

contract BrandedToken {

    // information about token    
    string public tokenBrand;
    string public description;
    string public symbol;
    uint public brandId;

    // private data
    uint shopBalance;
    uint numIssuedTokens;
    uint numCustomers;
    mapping(address => uint) balances;
    mapping(uint => address) customers;

    // constructor function: deploy a smart contract after the brand / shop registered
    constructor (string memory _tokenBrand, string memory _description, string memory _symbol, uint _initBalance, uint _brandId) public {
        tokenBrand = _tokenBrand;
        description = _description;
        symbol = _symbol;
        shopBalance = _initBalance;
        numIssuedTokens = _initBalance;
        brandId = _brandId;
    }

    // add the balance when the shop requests for adding more coins
    function addShopBalance(uint _numToken) public {
        shopBalance += _numToken;
        numIssuedTokens += _numToken;
    }

    // create coins for specified wallet owner (transfer from shop balance to customer balance)
    function mint(address _owner, uint _numToken) public {
        // need validation (requester == owner address)
        if (tx.origin == _owner && shopBalance >= _numToken) {
            balances[_owner] += _numToken;
            shopBalance -= _numToken;
        }
    }

    // specified wallet owner pays to the shop (transfer from customer balance to shop balance)
    function payToShop(address _owner, uint _numToken) public {
        // need validation (requester == owner address)
        if (tx.origin == _owner && balances[_owner] >= _numToken) {
            balances[_owner] -= _numToken;
            shopBalance += _numToken;
        }
    }

    // function transfer(address _sender, address _recipient, uint _numToken) public {
    //     // need validation (requester == owner address)
    //     if (tx.origin == _sender && balances[_sender] >= _numToken) {
    //         balances[_sender] -= _numToken;
    //         balances[_recipient] += _numToken;
    //     }
    // }

    // get information about the token of this shop (brand name)
    function getTokenDetail() view public returns (string memory) {
        string memory detail = tokenBrand;
        return detail;
    }

    // get balance of the specified owner
    function getBalance(address _owner) view public returns (uint) {
        // need validation (requester == owner address)
        if (tx.origin == _owner){
            return balances[_owner];        
        }
        return 0;
    }

    // validate whether the balances in this contract are valid (error detection: whether total balance == sum of balance of the shop & all customers)
    function isBalanceValid() view public returns (bool) {
        uint tempSum = shopBalance;
        for (uint i = 0; i < numCustomers; ++i) {
            tempSum += balances[customers[i]];
        }
        return ((tempSum == numIssuedTokens)? true: false);
    }

}
