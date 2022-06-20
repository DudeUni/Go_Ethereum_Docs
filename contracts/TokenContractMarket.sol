pragma solidity ^0.5.16;

import './BrandedToken.sol';

contract TokenContractMarket {

    // self-defined data types
    struct tokenInMarket {
        BrandedToken token;
        bool isRegistered;
    }
    struct tokenListing {
        string tokenBrand;
        uint id;
    }

    // information about the contract market
    uint public numTokenBrands = 0;
    
    // private data
    mapping(string => tokenInMarket) tokenContractMarket;
    tokenListing[] registeredTokenBrands;

    // register a shop when it applies for issuing coins in the market
    function registerNewToken(string memory _tokenBrand, string memory _description, string memory _symbol, uint _initBalance) public {
        // check if that token has been registered to exist in this market
        if (tokenContractMarket[_tokenBrand].isRegistered == false) {
            tokenContractMarket[_tokenBrand].token = new BrandedToken(_tokenBrand, _description, _symbol, _initBalance, numTokenBrands);
            tokenContractMarket[_tokenBrand].isRegistered = true;
            registeredTokenBrands.push(tokenListing(_tokenBrand, numTokenBrands));
            numTokenBrands += 1;
        }
    }
    
    // increase the balance of a kind of coin (provide additional coins to the requesting shop)
    function addShopBalance(string memory _tokenBrand, uint _amount) public {
        if (tokenContractMarket[_tokenBrand].isRegistered == true) {
            tokenContractMarket[_tokenBrand].token.addShopBalance(_amount);
        }
    }
    
    function mintToken(string memory _tokenBrand, address _owner, uint _amount) public {
        // check if that token has been registered to exist in this market and whether requester == owner
        if (tx.origin == _owner && tokenContractMarket[_tokenBrand].isRegistered == true) {
            tokenContractMarket[_tokenBrand].token.mint(_owner, _amount);
        }
    }

    function payToShopOfBrand(string memory _tokenBrand, address _owner, uint _amount) public {
        // check if that token has been registered to exist in this market and whether requester == owner
        if (tx.origin == _owner && tokenContractMarket[_tokenBrand].isRegistered == true) {
            tokenContractMarket[_tokenBrand].token.payToShop(_owner, _amount);
        }
    }
    
    // function transferTokens(string memory _tokenBrand, address _sender, address _recipient, uint _amount) public {
    //     // check if that token has been registered to exist in this market and whether requester == owner
    //     if (tx.origin == _sender && tokenContractMarket[_tokenBrand].isRegistered == true) {
    //         tokenContractMarket[_tokenBrand].token.transfer(_sender, _recipient, _amount);
    //     }       
    // }

    event LogTokenBrand(uint _id, string _tokenBrand);

    function getTokenDetail(string memory _tokenBrand) view public returns (string memory) {
        // check if that token has been registered to exist in this market
        if (tokenContractMarket[_tokenBrand].isRegistered == true) {
            return tokenContractMarket[_tokenBrand].token.getTokenDetail();
        }
    }

    function listAllRegisteredTokens() public {
        for (uint i = 0; i < numTokenBrands; ++i) {
            emit LogTokenBrand(registeredTokenBrands[i].id, registeredTokenBrands[i].tokenBrand);
        }
    }

    function showBalance(string memory _tokenBrand, address _owner) view public returns (uint bal) {
        // check if that token has been registered to exist in this market and whether requester == owner
        if (tx.origin == _owner && tokenContractMarket[_tokenBrand].isRegistered == true) {
            return tokenContractMarket[_tokenBrand].token.getBalance(_owner);
        }
    }

}
