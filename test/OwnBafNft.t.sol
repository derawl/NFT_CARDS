// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/OwnBafNft1155.sol";
import {Test} from "forge-std/Test.sol";
import { Factory1155 } from "../src/Factory1155.sol";

contract BafDevUser1155TokenTest is Test {
    BafDevUser1155Token public token;

    address public OWNER = address(0x111);

    Factory1155 public factory;

    // Setup function to initialize a new token contract before each test
    function setUp() public {
          vm.deal(OWNER, 10000 ether);
        vm.startPrank(OWNER);
        factory = new Factory1155(OWNER, OWNER);
        factory = new Factory1155(OWNER, OWNER);
        factory.setMintFee(0.001 ether);
        factory.setFeeReceiver(OWNER);
        bytes32 salt = bytes32(uint256(0));
        token = BafDevUser1155Token(factory.deploy(salt, "Test Token", "TST", "tokenURIPrefix"));
        
        token.mint{value: 0.001 ether}("1", 100, 5);
        vm.stopPrank();
    }

    modifier ownerCall() {
        vm.startPrank(OWNER);
        _;
        vm.stopPrank();
    }


    function invariant_tokenName() public {
        assertEq(token.name(), "Test Token");
    }

    function invariant_tokenSymbol() public {
        assertEq(token.symbol(), "TST");
    }

    function invariant_isInitialized() public{
        assertEq(token.isInitialized(), true);
    }

    function invariant_ownerIsNotNull() public {
        assertNotEq(token.owner(), address(0));
    }

    function invariant_ownerIsAlwaysAdmin() public {
        assertEq(token.hasRole(token.DEFAULT_ADMIN_ROLE(), token.owner()), true);
    }

    function invariant_factory() public {
        assert(address(token.factory()) == address(factory));
    }

    function testPause() public ownerCall {
        token.pause();
        assertTrue(token.paused());
    }

    function testUnpause() public ownerCall {
        token.pause();
        token.unpause();
        assertFalse(token.paused());
    }

    function testFailUnpauseWhenNotPaused() public ownerCall {
        token.unpause();
        vm.expectRevert();
    }

    function testFailPauseWhenPaused() public ownerCall {
        token.pause();
        token.pause();
        vm.expectRevert("Pausable: paused");
    }


    function testNonOwnerFailPause() public {
        vm.expectRevert();
        token.pause();
    }

    function testNonOwnerFailUnpause() public {
        vm.expectRevert();
        token.unpause();
    }


    // Test to verify the token name
    function testName() public {
        string memory name = token.name();
        assertEq(name, "Test Token");
    }

    // Test to verify the token symbol
    function testSymbol() public {
        string memory symbol = token.symbol();
        assertEq(symbol, "TST");
    }

    // Test to verify transfer of ownership
    function testTransferOwnership() public ownerCall {
        address newOwner = address(0x123);
        token.transferOwnership(newOwner);
        assertEq(token.owner(), newOwner);
    }

    // Test to verify failure on transferring ownership to zero address
    function testFailTransferOwnershipToZeroAddress() public ownerCall {
        token.transferOwnership(address(0));
        vm.expectRevert("Ownable: new owner is the zero address");
    }

    // Test to check base URI setting
    function testSetBaseURI() public ownerCall {
        string memory newBaseURI = "https://newexample.com/";
        assertTrue(token.setBaseURI(newBaseURI));
        // assertEq(token.baseTokenURI(), newBaseURI);
    }

    // Test to check minting of tokens
    function testMint() public ownerCall {
        uint256 supply = 10;
        uint256 tokenId = token.mint{value: 0.001 ether}("https://tokenuri.com/", 50, supply);
        assertEq(token.balanceOf(address(OWNER), tokenId), supply);
    }

    // Test to check editing of royalty
    function testEditRoyalty() public ownerCall {
        uint256 tokenId = token.mint{value: 0.001 ether}("https://tokenuri.com/", 5, 10);
        token.editRoyalty(tokenId, 8);
        (, uint256 royalty) = token.royaltyInfo(tokenId, 1e18);
        assertEq(royalty, (8 * 1e18) / 1000);
    }

    function testUri() public ownerCall {
        string memory newBaseURI = "https://example.com/";
        assertTrue(token.setBaseURI(newBaseURI));
        uint256 tokenId = token.mint{value: 0.001 ether}("tokenuri", 5, 10);
        assertEq(token.uri(tokenId), "https://example.com/tokenuri");
    }

     function testInvalidMintValue() public ownerCall {
        factory.setMintFee(0.001 ether);
        factory.setFeeReceiver(address(token));
        vm.expectRevert("BafDevUser1155Token: invalid fee amount");
        token.mint{value: 0.0001 ether}("tokenuri", 5, 10);
        vm.expectRevert("BafDevUser1155Token: invalid fee amount");
        token.mint{value: 20 ether}("tokenuri", 5, 10);
    }



}
