// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import { Factory1155 } from "../src/Factory1155.sol";
import { TradeV3 } from "../src/TradeV3.sol";
import { TransferProxy } from "../src/TransferProxy.sol";


contract Deploy is Script {

    function run() public {
        uint256 defaulMintFee = 0.0001 ether;
        address defaultFeeReceiver = 0x8478F8c1d693aB4C054d3BBC0aBff4178b8F1b0B;

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Factory1155 factory = new Factory1155(defaultFeeReceiver, 0x75F47Db90e40Ae1D79C54959548A6b1950eF1673);
        factory.setMintFee(defaulMintFee);        
        vm.stopBroadcast();
    }
}

//forge script script/TradeDeploy.s.sol --rpc-url https://ethereum-sepolia.publicnode.com --broadcast --etherscan-api-key I26HJBWR9SJYQW9HX65F8H2KM6HFNSFP1N --verify