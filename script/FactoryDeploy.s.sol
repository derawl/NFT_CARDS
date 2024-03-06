// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import { Factory1155 } from "../src/Factory1155.sol";



contract Deploy is Script {

    function run() public {
        uint256 defaultMintFee = 0.16 ether;
        address defaultFeeReceiver = 0x1191db828b0241df99E982c0207B1Ab3e3eF7a86;
        address defaultAdmin = 0xE8B29Dcf38450E2b6e0E486f124A9DC9EE67c9AE;
        address deployer = 0x28411f770fbf5997C4F5736DFb05B1884fe9158B;

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Factory1155 factory = new Factory1155(deployer, defaultFeeReceiver);
        factory.setMintFee(defaultMintFee); 
        factory.grantRole(factory.DEFAULT_ADMIN_ROLE(), defaultAdmin);
        vm.stopBroadcast();
    }
}


//forge script script/TradeDeploy.s.sol --rpc-url https://ethereum-sepolia.publicnode.com --broadcast --etherscan-api-key I26HJBWR9SJYQW9HX65F8H2KM6HFNSFP1N --verify


// forge script script/FactoryDeploy.s.sol --rpc-url https://rpc.ankr.com/eth --broadcast --etherscan-api-key I26HJBWR9SJYQW9HX65F8H2KM6HFNSFP1N --verify