// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import { MockWeth } from "../src/MockWeth.sol";

contract DeployMockWeth is Script {

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address admin = 0x8478F8c1d693aB4C054d3BBC0aBff4178b8F1b0B;

        vm.startBroadcast(deployerPrivateKey);
        MockWeth weth = new MockWeth();
        weth.mint(admin, 100e18);
        weth.mint(0x98EFA62a1DcB1eac0Db308C34b4905382891B4Fe, 100e18);
        weth.mint(0x98EFA62a1DcB1eac0Db308C34b4905382891B4Fe, 100e18);
        vm.stopBroadcast();
    }
}