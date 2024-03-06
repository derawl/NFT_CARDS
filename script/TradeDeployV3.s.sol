// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Factory1155} from "../src/Factory1155.sol";
import {TradeV3} from "../src/TradeV3.sol";
import {TransferProxy} from "../src/TransferProxy.sol";
import {ITransferProxy} from "../src/interface/ITransferProxy.sol";

contract Deploy is Script {
    function run() public {

        address wethToken = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // ITransferProxy _proxy
        TransferProxy transferProxy = new TransferProxy(0xE8B29Dcf38450E2b6e0E486f124A9DC9EE67c9AE);


        TradeV3 trade = new TradeV3(
            5e16, //2.5%
            5e15, //0.5%
            25e16, //5%
            25e16, //0.2%
            0xE8B29Dcf38450E2b6e0E486f124A9DC9EE67c9AE,
            0x1191db828b0241df99E982c0207B1Ab3e3eF7a86,
            ITransferProxy(transferProxy)
        );

        trade.setSupportedToken(wethToken);
        trade.grantRole(trade.DEFAULT_ADMIN_ROLE(), 0xE8B29Dcf38450E2b6e0E486f124A9DC9EE67c9AE);
        
        transferProxy.changeOperator(address(trade));
        vm.stopBroadcast();
    }
}

// new Trade Script 0xed680A0D1eB5373674FeEA6b1cbc6dC83b185a2b
// forge script script/TradeDeployV3.s.sol --rpc-url https://ethereum-sepolia.publicnode.com --broadcast --etherscan-api-key I26HJBWR9SJYQW9HX65F8H2KM6HFNSFP1N --verify


// forge script script/TradeDeployV3.s.sol --rpc-url https://rpc.ankr.com/eth --broadcast --etherscan-api-key I26HJBWR9SJYQW9HX65F8H2KM6HFNSFP1N --verify
