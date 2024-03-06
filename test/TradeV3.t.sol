// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/OwnBafNft1155.sol";
import {Test, console2} from "forge-std/Test.sol";
import { Factory1155 } from "../src/Factory1155.sol";
import { TradeV3 } from "../src/TradeV3.sol";
import {MockWeth} from "../src/MockWeth.sol";
import {TransferProxy} from "../src/TransferProxy.sol";
import {ITransferProxy} from "../src/interface/ITransferProxy.sol";


   /* An ECDSA signature. */
    struct Sign {
        uint8 v;
        bytes32 r;
        bytes32 s;
        uint256 nonce;
    }
    /** Order Params
        @param seller address of user,who's selling the NFT.
        @param buyer address of user, who's buying the NFT.
        @param erc20Address address of the token, which is used as payment token(WETH/WBNB/WMATIC...)
        @param nftAddress address of NFT contract where the NFT token is created/Minted.
        @param uintprice the Price Each NFT.
        @param amount the price of NFT(assetFee).
        @param tokenId 
        @param qty number of quantity to be transfer.
     */

    enum PartnerFeeType {
        nonPartner,
        partner
    }

    struct Order {
        address seller;
        address buyer;
        address partner;
        address erc20Address;
        address nftAddress;
        PartnerFeeType partnerType;
        uint256 unitPrice;
        uint256 amount;
        uint256 tokenId;
        uint256 qty;
    }

contract TradeV3Test is Test {
    BafDevUser1155Token public token;
    BafDevUser1155Token public token2;

    address public OWNER = address(0x111);

    uint256 tester1Key = 0x1111111;

    address public Tester1 = vm.addr(tester1Key);
    address public Tester2 = address(0x333);

    Factory1155 public factory;

    TradeV3 public trade;
    MockWeth public weth;
    TransferProxy public transferProxy;

    // Setup function to initialize a new token contract before each test
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


        transferProxy = new TransferProxy(OWNER);
        trade = new TradeV3(
            25, //2.5%
            25, //2.5%
            50, //5%
            2, //0.2%
            address(transferProxy),
            OWNER,
            ITransferProxy(address(transferProxy))
        );
        transferProxy.changeOperator(address(trade));
        vm.stopPrank();

        vm.startPrank(Tester1);
        token.mint{value: 0.001 ether}("1", 200, 5);
        vm.stopPrank();

        vm.startPrank(Tester2);
        token2.mint{value: 0.001 ether}("1", 100, 5);
        vm.stopPrank();

    }

    modifier ownerCall() {
        vm.startPrank(OWNER);
        _;
        vm.stopPrank();
    }

    function testSetSellerFee() public ownerCall {
        trade.setSellerServiceFee(10);
        assertEq(trade.sellerFeePermille(), 10);
    }

    function testSetSellerFeeNonAdmin () public {
         vm.expectRevert();
        trade.setSellerServiceFee(10);
    }

    function testSetPartnerFee() public  {
        vm.startPrank(OWNER);
        trade.setPartnerFee(10);
        assertEq(trade.partnerFeePermille(), 10);
        vm.stopPrank();

        //non admin 
        vm.expectRevert();
        trade.setPartnerFee(10);
    }

    function testSetAllFees() public {
        vm.startPrank(OWNER);
        trade.setAllFees(200, 10, 20, 20);
        assertEq(trade.maxRoyaltyFee(), 200);
        assertEq(trade.sellerFeePermille(), 20);
        assertEq(trade.marketingFeePermille(), 10);
        uint256 partnerFeePermille = trade.partnerFeePermille();
        assertEq(partnerFeePermille, 20);
        console2.log("trade.partnerFeePermille()", trade.partnerFeePermille());
        vm.stopPrank();

        //non admin
        vm.expectRevert();
        trade.setAllFees(200, 10, 20, 20);

        vm.prank(OWNER);
        vm.expectRevert();
        trade.setAllFees(1001, 1002, 2000, 3000);

    } 

    function testSetMarketingFee() public  {
        vm.startPrank(OWNER);
        trade.setMarketingFee(10);
        assertEq(trade.marketingFeePermille(), 10);
        vm.stopPrank();

        //non admin
        vm.expectRevert();
        trade.setMarketingFee(10);

        vm.prank(OWNER);
        vm.expectRevert();
        trade.setMarketingFee(1001);
    }


    function testSetMaxRoyaltyFee() public  {
        vm.startPrank(OWNER);
        trade.setMaxRoyaltyFee(10);
        assertEq(trade.maxRoyaltyFee(), 10);
        trade.setMaxRoyaltyFee(1000);
        vm.stopPrank();

        //non admin
        vm.expectRevert();
        trade.setMaxRoyaltyFee(10);

        vm.prank(OWNER);
        vm.expectRevert("Trade: Invalid value");
        trade.setMaxRoyaltyFee(1002);

    }

    function testPause () public {
        vm.startPrank(OWNER);
        trade.pause();
        assertEq(trade.paused(), true);
        vm.stopPrank();

        //non admin
        vm.expectRevert();
        trade.pause();

        vm.prank(OWNER);
        vm.expectRevert();
        trade.pause();
    }
    

    function testUnpause () public {
        vm.startPrank(OWNER);
        trade.pause();
        trade.unpause();
        assertEq(trade.paused(), false);
        vm.stopPrank();

        //non admin
        vm.expectRevert();
        trade.unpause();

        vm.prank(OWNER);
        vm.expectRevert();
        trade.unpause();
    }

    function invariant_transFerProxyIsNeverAddress0() public {
        assertNotEq(address(transferProxy), address(0));
    }

    function invaratiant_OwnerIsAdmin() public {
        assertEq(trade.hasRole(trade.ADMIN_ROLE(), OWNER), true);
    }

    function invariant_feesNeverGreaterThanPrecision() public {
        assertLe(trade.sellerFeePermille(), trade.PRECISION());
        assertLe(trade.marketingFeePermille(), trade.PRECISION());
        assertLe(trade.partnerFeePermille(), trade.PRECISION());
    }

    function invariant_adminsNotAddress0() public {
        assertNotEq(trade.admin1(), address(0));
        assertNotEq(trade.admin2(), address(0));
    }


    function testSetTransferProxy() public ownerCall {
        TransferProxy transferProxy = new TransferProxy(OWNER);
        trade.setTransferProxy(address(transferProxy));
        assertEq(address(trade.transferProxy()), address(transferProxy));

        //non admin
        vm.expectRevert();
        trade.setTransferProxy(address(0));
    }

    function testSetTransferProxyNonOwner() public {
        TransferProxy transferProxy = new TransferProxy(OWNER);
        vm.expectRevert();
        trade.setTransferProxy(address(transferProxy));
    }

    function testTransferOwnership() public ownerCall {
        trade.transferOwnership(Tester1);
        assertEq(trade.owner(), Tester1);
        
        assertTrue(!trade.hasRole(trade.ADMIN_ROLE(), OWNER));
        assertTrue(!trade.hasRole(trade.DEFAULT_ADMIN_ROLE(), OWNER));
    }

    function testTransferOwnershipToZero() public ownerCall {
        vm.expectRevert("Ownable: new owner is the zero address");
        trade.transferOwnership(address(0));
    }

    function testTransferOwnershipNonOwner() public {
        vm.expectRevert();
        trade.transferOwnership(Tester1);
    }

    function testSetAdmins () public ownerCall {
        trade.setAdmin1(Tester1);
        trade.setAdmin2(Tester2);
        assertEq(trade.admin1(), Tester1);
        assertEq(trade.admin2(), Tester2);      
        assertTrue(trade.hasRole(trade.ADMIN_ROLE(), Tester1));
        assertTrue(trade.hasRole(trade.ADMIN_ROLE(), Tester2));
    }

    function testSetAdminsNonOwner () public {
        vm.expectRevert();
        trade.setAdmin1(Tester1);
        vm.expectRevert();
        trade.setAdmin2(Tester2);
    }


    function testBuyAsset() public {
        vm.startPrank(Tester1);
        token.setApprovalForAll(address(transferProxy), true);
        vm.stopPrank();

        vm.startPrank(Tester2);
        token2.setApprovalForAll(address(transferProxy), true);
        vm.stopPrank();

        //let Tester1 sell token to Tester2
        vm.startPrank(Tester1);
        TradeV3.Order memory sellOrder = TradeV3.Order({
            seller: Tester1,
            buyer: Tester2,
            partner: address(0),
            erc20Address: address(weth),
            nftAddress: address(token),
            unitPrice: 1 ether,
            amount: 1 ether * 1,
            tokenId: 1,
            qty: 1,
            partnerType: TradeV3.PartnerFeeType.nonPartner
        });

        uint256 nonce = 0;
        console2.log(Tester1);

        // In Solidity, you would typically use a tuple for this purpose

        // let Tester1 sign a sell order
        bytes32 hash = keccak256(abi.encodePacked(sellOrder.nftAddress, sellOrder.tokenId, sellOrder.erc20Address, sellOrder.amount, nonce));
        vm.stopPrank();

        bytes32 ethSignedHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
        );



        (uint8 v, bytes32 r, bytes32 s) = vm.sign(tester1Key, ethSignedHash);

        address signer = ecrecover(hash, v, r, s);

        console2.log(signer);

        //let Tester2 buy token from Tester1
        vm.startPrank(Tester2);
        weth.approve(address(transferProxy), 20 ether);
        TradeV3.Sign memory sign = TradeV3.Sign({
            v: v,
            r: r,
            s: s,
            nonce: nonce
        });
        trade.buyAsset(sellOrder, sign);
        vm.stopPrank();
    }


    function testAssetBid () public {
        vm.startPrank(Tester1); //buyer
        weth.approve(address(transferProxy), 20 ether);
        vm.stopPrank();

        vm.startPrank(Tester2); //seller
        token2.setApprovalForAll(address(transferProxy), true);
        vm.stopPrank();

        //let Tester1 sell token to Tester2
        vm.startPrank(Tester1);
        TradeV3.Order memory sellOrder = TradeV3.Order({
            seller: Tester2,
            buyer: Tester1,
            partner: address(0),
            erc20Address: address(weth),
            nftAddress: address(token2),
            unitPrice: 1 ether,
            amount: 1 ether * 1,
            tokenId: 1,
            qty: 1,
            partnerType: TradeV3.PartnerFeeType.nonPartner
        });

        uint256 nonce = 1;

 
        // let Tester1 sign a sell order
        bytes32 hash = keccak256(abi.encodePacked(sellOrder.nftAddress, sellOrder.tokenId, sellOrder.erc20Address, sellOrder.amount, sellOrder.qty, nonce));
        vm.stopPrank();


        bytes32 ethSignedHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
        );

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(tester1Key, ethSignedHash);

        address signer = ecrecover(ethSignedHash, v, r, s);

        console2.log(signer, Tester1);
        //let Tester2 approves bid from Tester1
        vm.startPrank(Tester2);
        TradeV3.Sign memory sign = TradeV3.Sign({
            v: v,
            r: r,
            s: s,
            nonce: nonce
        });
        trade.executeBid(sellOrder, sign);
        vm.stopPrank();
    }

    function testGetFees(uint256 amount) public {
        //admin
        vm.assume(amount < 1000_000_000_000_000_000 ether);
        TradeV3.Fee memory fee = trade.getFees(amount, address(token), 1);
        assertEq(fee.sellerFee, (amount * trade.sellerFeePermille()) / trade.PRECISION());
        assertEq(fee.marketingFee, (amount * trade.marketingFeePermille()) / trade.PRECISION());
        assertEq(fee.partnerFee, (amount * trade.partnerFeePermille()) / trade.PRECISION());
        assertLe(fee.royaltyFee, (amount * trade.maxRoyaltyFee()) / trade.PRECISION());
        uint256 assetFee = amount - (fee.sellerFee + fee.royaltyFee + fee.partnerFee + fee.marketingFee);
        assertEq(fee.assetFee, assetFee);
    }

    function testWithdrawEth () public {
        //admin
        vm.startPrank(OWNER);
        vm.expectRevert("Trade: Insufficient balance");
        trade.withdrawEth(payable(Tester1));
        vm.stopPrank();

        //non admin
        vm.expectRevert();
        vm.expectRevert("Trade: Insufficient balance");
        trade.withdrawEth(payable(Tester2));

    }

    function testWithdrawErc20 () public {
        //admin
        weth.mint(address(trade), 20 ether);
        vm.startPrank(OWNER);
        trade.withdrawErc20(address(weth), Tester1);
        vm.stopPrank();

        //non admin
        vm.expectRevert();
        trade.withdrawErc20(address(weth), Tester1);
    }
}