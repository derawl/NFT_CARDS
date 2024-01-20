// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/OwnBafNft1155.sol";
import {Test, console2} from "forge-std/Test.sol";
import { Factory1155 } from "../src/Factory1155.sol";
import { TradeV3 } from "../src/TradeV3.sol";
import {MockWeth} from "../src/MockWeth.sol";
import {TransferProxy} from "../src/TransferProxy.sol";
import {ITransferProxy} from "../src/interface/ITransferProxy.sol";


contract TestTransferProxy is Test {

    TransferProxy transferProxy;
    Factory1155 factory;
    TradeV3 trade;
    MockWeth weth;

    BafDevUser1155Token public token;
    BafDevUser1155Token public token2;

    address public OWNER = address(0x111);

    uint256 tester1Key = 0x1111111;

    address public Tester1 = vm.addr(tester1Key);
    address public Tester2 = address(0x333);


    function setUp() public {
        vm.deal(OWNER, 10000 ether);
        vm.deal(Tester1, 100 ether);
        vm.deal(Tester2, 100 ether);
        vm.startPrank(OWNER);
        factory = new Factory1155(OWNER, OWNER);
        factory = new Factory1155(OWNER, OWNER);
        factory.setMintFee(0.001 ether);
        factory.setFeeReceiver(OWNER);
        bytes32 salt = bytes32(uint256(0));
        token = BafDevUser1155Token(factory.deploy(salt, "Test Token", "TST", "tokenURIPrefix"));
        token2 = BafDevUser1155Token(factory.deploy(salt, "Test Token2", "TST2", "tokenURIPrefix"));
        
        weth = new MockWeth();

        weth.mint(Tester2, 1000 ether);
        weth.mint(Tester1, 1000 ether);


        transferProxy = new TransferProxy();
        trade = new TradeV3(
            25, //2.5%
            25, //2.5%
            50, //5%
            2, //0.2%
            address(transferProxy),
            OWNER,
            ITransferProxy(address(transferProxy))
        );
        transferProxy.changeOperator(address(OWNER));
        vm.stopPrank();

        vm.startPrank(Tester1);
        token.mint{value: 0.001 ether}("1", 200, 5);
        token2.mint{value: 0.001 ether}("1", 100, 5);

        token.setApprovalForAll(address(transferProxy), true);
        vm.stopPrank();

    }

    modifier ownerCall() {
        vm.startPrank(OWNER);
        _;
        vm.stopPrank();
    }

    function invariant_operatorIsNeverAddressZero() public {
        assertNotEq(transferProxy.operator(), address(0));
    }

    function invariant_ownerIsAlwaysAdmin() public {
        assertEq(transferProxy.hasRole("ADMIN_ROLE", transferProxy.owner()), true);
    }

    function test_changeOperator() public   {
        vm.startPrank(OWNER);
        transferProxy.changeOperator(Tester1);
        assertEq(transferProxy.operator(), Tester1);

        vm.expectRevert();
        transferProxy.changeOperator(address(0));
        vm.stopPrank();

        vm.expectRevert();
        transferProxy.changeOperator(Tester1);

    }

    function test_transferOwnership() public ownerCall {
        transferProxy.transferOwnership(Tester1);
        assertEq(transferProxy.owner(), Tester1);
    }

    function test_erc1155safeTransferFrom() public ownerCall {
        transferProxy.erc1155safeTransferFrom(token, Tester1,Tester2, 1, 1, "");
        assertEq(token.balanceOf(Tester2, 1), 1);
    }

    function test_erc20safeTransferFrom() public  {
        uint256 balance = weth.balanceOf(Tester2);
        weth.mint(OWNER, 20 ether);
        vm.startPrank(OWNER);
        weth.approve(address(transferProxy), 20 ether);
        transferProxy.erc20safeTransferFrom(weth, OWNER,Tester2, 1);

        vm.stopPrank();
       
        assertEq(weth.balanceOf(Tester2), balance + 1);
    }


    function test_erc1155safeBatchTransferFrom() public ownerCall {
        transferProxy.erc1155safeTransferFrom(token, Tester1,Tester2, 1, 1, "");
        assertEq(token.balanceOf(Tester2, 1), 1);
    }


     function testWithdrawEth () public {
        //admin
        vm.startPrank(OWNER);
        vm.expectRevert("Trade: Insufficient balance");
        transferProxy.withdrawEth(payable(Tester1));
        vm.stopPrank();

        //non admin
        vm.expectRevert();
        vm.expectRevert("Trade: Insufficient balance");
        transferProxy.withdrawEth(payable(Tester2));

    }

    function testWithdrawErc20 () public {
        //admin
        weth.mint(address(transferProxy), 20 ether);
        vm.startPrank(OWNER);
        transferProxy.withdrawErc20(address(weth), Tester1);
        vm.stopPrank();

        //non admin
        vm.expectRevert();
        transferProxy.withdrawErc20(address(weth), Tester1);
    }

}