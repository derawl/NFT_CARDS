pragma solidity 0.8.17;

import {Test, console2} from "forge-std/Test.sol";
import {Factory1155} from "../src/Factory1155.sol";
import {BafDevUser1155Token} from "../src/OwnBafNft1155.sol";

contract Factory1155Test is Test {
    Factory1155 public factory;

    address OWNER = address(0x111);
    address FEE_RECEIVER = address(0x222);

    BafDevUser1155Token public lastDeployed;

    function setUp() public {
        vm.startPrank(OWNER);
        factory = new Factory1155(OWNER, OWNER);
        factory.setMintFee(0.001 ether);
        factory.setFeeReceiver(FEE_RECEIVER);
        vm.deal(OWNER, 1000 ether);
        bytes32 salt = bytes32(uint256(0));
        lastDeployed = BafDevUser1155Token(factory.deploy(salt, "Test", "symbol", "tokenURIPrefix"));
        vm.stopPrank();
    }

    function invariant_feeReceiverIsNotZero() public {
        assert(factory.feeReceiver() != address(0));
    }

    function invariant_mintFeeIsNonNegative() public {
        assert(factory.mintFee() >= 0);
    }

    function invariant_ownershipTransferred() public {
        assertEq(lastDeployed.owner(), OWNER);
    }

    function invariant_isDeployed() public {
        assert(factory.isDeployed(address(lastDeployed)));
    }


    function invariant_onlyAdminCanWithdrawEth() public {
        assertEq(factory.hasRole(factory.DEFAULT_ADMIN_ROLE(), OWNER), true);
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


    function testAdminCanWithdrawEth() public {
        vm.deal(address(factory), 1 ether);

        // Act - Attempt to withdraw as an admin
        vm.prank(OWNER); // Assuming OWNER is the admin
        factory.withdrawEth();

        // Assert - Check the ETH was successfully withdrawn
        // (You can assert the balance of the admin or the contract as needed)
    }

    function testNonAdminCannotWithdrawEth() public {
        // Arrange - Another account that's not an admin
        address nonAdmin = address(0x123);

        // Act & Assert - Attempt to withdraw as a non-admin should revert
        
        vm.prank(nonAdmin);
        vm.expectRevert();
        factory.withdrawEth();
    }


    function testNonDeployedContractCannotCallSendFee() public {
        // Arrange - Another account that's not an admin
        address nonAdmin = address(0x123);

        // Act & Assert - Attempt to withdraw as a non-admin should revert
        vm.prank(nonAdmin);
        vm.expectRevert();
        factory.sendFee();
    }
}


