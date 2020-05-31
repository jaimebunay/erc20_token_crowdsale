
pragma solidity ^0.5.0;

import "./PuppyCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

contract PuppyCoinSale is Crowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale, MintedCrowdsale {

    constructor(
        uint rate, // rate in TKNbits 
        address payable wallet, // wallet to send Ether to
        PuppyCoin token, //This is the IERC20 token 
        uint cap, // goal to meet
        uint startTime, // start of Crowdsale 
        uint endTime, // end of Crowdsale
        uint goal // minimum amount of funds to be raised in weis
    )
        RefundableCrowdsale(goal)
        TimedCrowdsale(startTime, endTime)
        CappedCrowdsale(cap)
        Crowdsale(rate, wallet, token)
    
        public
    {
        // constructor can stay empty
    }
}

contract PuppyCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;
    // Information to create PuppyCoin Token
    constructor(
       string memory name, // name for my token
       string memory symbol, // symbol for my token 
       address payable wallet, // Account that will recieve the Ether 
       uint cap,
       uint goal
       
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
        // Using 'new' to allow this contract to create a PuppyCoin contract
        PuppyCoin token = new PuppyCoin(name, symbol, 0); // zero initial supply
        token_address = address(token); // Address from the created token

        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        // one token for every four wei
        PuppyCoinSale puppycoin_sale = new PuppyCoinSale(.25e18, wallet, token, cap, now, now + 7 minutes,goal);
        token_sale_address = address(puppycoin_sale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
// Cap: 15000 wei
// Goal: 10000 wei
// buyTokens: 12000 wei
// Deployer: 0x16251B4A0Ac39bC0D1e5B25b98Bdf13F64b689fd
// CoinSale: 0xEdA6fC7e2be652Ad491b4F47C77510D8b820D428
// PuppyCoin: 0xEdA6fC7e2be652Ad491b4F47C77510D8b820D428

