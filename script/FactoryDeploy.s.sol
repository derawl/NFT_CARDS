// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import { Factory1155 } from "../src/Factory1155.sol";
import { Trade } from "../src/Trade.sol";
import { TransferProxy } from "../src/TransferProxy.sol";


contract Deploy is Script {

    function run() public {
        uint256 defaulMintFee = 0.001 ether;
        address defaultFeeReceiver = 0x8478F8c1d693aB4C054d3BBC0aBff4178b8F1b0B;

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Factory1155 factory = new Factory1155();
        factory.setMintFee(defaulMintFee);
        factory.setFeeReceiver(defaultFeeReceiver);
        
        vm.stopBroadcast();
    }
}