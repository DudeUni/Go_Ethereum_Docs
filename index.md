# This serves as a reminder of the current state of the prototype. 



**Checklist**
=====================
<!-- add to do list here  -->

## The App(Customer) should have/be able to ...
- [ ] Create Account
- [ ] Verify account (Log in/out)
- [ ] View Account information
- [ ] View Token, and its Metadata
- [ ] Buy Token with Cash/E-payment
- [ ] QR code support
- [ ] Social Networks (Add Other Accounts)


## A Business owner should be able to ...
- [ ] Publish a Token
- [ ] Set the metadata of the Token
- [ ] Receive Sales money

## Server should realize ...
- [ ] Proof-of-Authority (?)
- [ ] Store Token Metadata 
- [ ] Digital Payments: Credit Cards/Octopus/Alipay...
- [ ] Portal: News/Sales Information
- [ ] Admin function (?)
- [ ] Social Networks
- [ ] Generate statistics

## Contracts 
- [ ] Create Token
- [ ] View Balance
- [ ] Transfer Token
  



**Q&A**
=====================================================



## Security & Networks

- Who has the access to the server/ How to access the server?
    
    >The server is running on `localhost:<port 0>` of the workstation. Anyone who has accounts on the workstation can access the server. This is also forwarded to `<port1>` of `Office Computer A`. 

- How can/cannot the server be found by other Ethereum nodes?

    >**[Not Answered Yet]** This might be found in this [official document](https://geth.ethereum.org/docs/interface/private-network).

- What is the consensus mechanism?
    
    >Currently, it is PoW with only 1 node.


## App
- How can the App connect to the blockchain?
  > By accessing `<ip of A>:<port1>`.

## Customer/Business
- How can we create Token for Business Owners?
   > Currently, we can create token by manually editing/creating smart contracts on the Node.
- What service we are going to provide to a business owner?
    > We can Mint Token-Coupons for the business owner. The Token is not just a digitized coupon: it can come with sales/discounts/promotions. Then the token is traded to the customer. It is also allowed that customer can trade/exchange between each other.

- How customers can use our App? 
   > They can buy/sell/ coupons published in our platforms. They can also trade/exchange between each other.
