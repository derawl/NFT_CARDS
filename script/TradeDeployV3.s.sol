// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import { Factory1155 } from "../src/Factory1155.sol";
import {TradeV3} from "../src/TradeV3.sol";
import { TransferProxy } from "../src/TransferProxy.sol";
import {ITransferProxy} from "../src/interface/ITransferProxy.sol";

contract Deploy is Script {

    function run() public {
        uint256 defaulMintFee = 0.001 ether;
        address defaultFeeReceiver = 0x8478F8c1d693aB4C054d3BBC0aBff4178b8F1b0B;

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address proxy = 0x26C84BA2de2e1C79A48B17ed6c6e0e2D3340b97c;
        vm.startBroadcast(deployerPrivateKey);
        // uint8 _buyerFee,
        // uint8 _sellerFee,
        // uint8 _partnerFee,
        // address _admin1,
        // address _admin2,

        // ITransferProxy _proxy
        TransferProxy transferProxy = TransferProxy(0x8508E135064bf43CdD85000D8389a5b8D03bF266);

        TradeV3 trade = new TradeV3(
            25, //2.5%
            25, //2.5%
            50, //5%
            2, //0.2%
            0x75F47Db90e40Ae1D79C54959548A6b1950eF1673,
            defaultFeeReceiver,
            ITransferProxy(transferProxy)
        );

        transferProxy.changeOperator(address(trade));

        vm.stopBroadcast();
    }
}

// new Trade Script 0xed680A0D1eB5373674FeEA6b1cbc6dC83b185a2b
// forge script script/TradeDeploy.s.sol --rpc-url https://ethereum-sepolia.publicnode.com --broadcast --etherscan-api-key I26HJBWR9SJYQW9HX65F8H2KM6HFNSFP1N --verify

//Course of action

// - Change necessary fees
// - Change admin addresses
// - Change proxy address
// - create sale order
// execute sale order
// check that correct accounting is executed
// check that correct fees are collected
// create bid
// approve bid check that correct accounting is executed


//remeber to chage admin