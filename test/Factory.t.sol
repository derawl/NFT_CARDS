pragma solidity 0.8.17;

import {Test, console2} from "forge-std/Test.sol";
import {Factory1155} from "../src/Factory1155.sol";
import {BafDevUser1155Token} from "../src/OwnBafNft1155.sol";

contract Factory1155Test is Test {
    Factory1155 public factory;

    address OWNER = address(0x111);
    address FEE_RECEIVER = address(0x222);

    function setUp() public {
        vm.startPrank(OWNER);
        factory = new Factory1155();
        factory.setMintFee(0.001 ether);
        factory.setFeeReceiver(FEE_RECEIVER);
        vm.deal(OWNER, 100 ether);
        vm.stopPrank();
    }

    function testDeploy() public {
        bytes32 salt = bytes32(uint256(0));
        string memory name = "Test";
        string memory symbol = "TST";
        string memory tokenURIPrefix = "https://example.com/";

        vm.startPrank(OWNER);

        address addr = factory.deploy(salt, name, symbol, tokenURIPrefix);

        vm.stopPrank();

        BafDevUser1155Token token = BafDevUser1155Token(address(addr));

        assertNotEq(addr, address(0));
        assertEq(token.name(), name);
        assertEq(token.symbol(), symbol);
        assertEq(token.owner(), OWNER);
    }

    function testMint() public {
        bytes32 salt = bytes32(uint256(0));
        string memory name = "Test";
        string memory symbol = "TST";
        string memory tokenURIPrefix = "https://example.com/";

        vm.startPrank(OWNER);

        address addr = factory.deploy(salt, name, symbol, tokenURIPrefix);

        vm.stopPrank();

        console2.log(FEE_RECEIVER.balance);

        BafDevUser1155Token token = BafDevUser1155Token(address(addr));
        vm.startPrank(OWNER);
        token.mint{value: 0.001 ether}("", 100, 6);
        vm.stopPrank();

        assertEq(0.001 ether, FEE_RECEIVER.balance);
        assertEq(token.balanceOf(OWNER, 1), 6);
    }

    function testChangeFeeReceiver() public {
        address newFeeReceiver = address(0x333);

        vm.startPrank(OWNER);
        factory.setFeeReceiver(newFeeReceiver);
        vm.stopPrank();

        assertEq(newFeeReceiver, factory.feeReceiver());
    }


    function testChangeMintFee() public {
        uint256 newMintFee = 0.002 ether;

        vm.startPrank(OWNER);
        factory.setMintFee(newMintFee);
        vm.stopPrank();

        assertEq(newMintFee, factory.mintFee());
    }


    function testFailChangeMintFee() public {
        vm.startPrank(OWNER);
        factory.setMintFee(0);
        vm.stopPrank();

        vm.expectRevert("Factory1155: mint fee is zero");
    }

    function testFailChangeFeeReceiver() public {
        vm.startPrank(OWNER);
        factory.setFeeReceiver(address(0));
        vm.stopPrank();

        vm.expectRevert("Factory1155: fee receiver is the zero address");
    }

    function testFailIfNotAdmin() public {
        vm.startPrank(address(0x123));
        factory.setFeeReceiver(address(0));
        vm.stopPrank();

        vm.expectRevert();

        vm.startPrank(address(0x123));
        factory.setMintFee(0);
        vm.stopPrank();
        vm.expectRevert();
    }

}


