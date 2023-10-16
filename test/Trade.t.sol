pragma solidity 0.8.17;

import {Test, console} from "forge-std/Test.sol";
import {Trade} from "../src/Trade.sol";
import {ITransferProxy} from "../src/interface/ITransferProxy.sol";
import {TransferProxy} from "../src/TransferProxy.sol";
import {BafDevUser1155Token} from "../src/OwnBafNft1155.sol";
import { Factory1155 } from "../src/Factory1155.sol";
contract TestTrade is Test {
    Trade public trade;
    Factory1155 public factory;
    address OWNER = address(0x111);
    address ADMIN_ONE = address(0x222);
    address ADMIN_TWO = address(0x333);
    address SELLER = address(0x444);
    address BUYER = address(0x555);


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

    ITransferProxy transferProxy;
    BafDevUser1155Token token;
    function setUp() public {
        vm.startPrank(OWNER);
        transferProxy = new TransferProxy();
        trade = new Trade(
            50,
            10,
            15,
            ADMIN_ONE,
            ADMIN_TWO,
            transferProxy
        );
        factory = new Factory1155();
        token = new BafDevUser1155Token("Test", "TST", "https://example.com/", address(factory));
        vm.stopPrank();
    }

    function testSetAdmin() public {
        assertEq(trade.admin1(), ADMIN_ONE);
        assertEq(trade.admin2(), ADMIN_TWO);
        bool isDefaultAdmin = trade.hasRole(trade.DEFAULT_ADMIN_ROLE(), OWNER);
        console.log(isDefaultAdmin);
        vm.startPrank(OWNER);
        trade.transferOwnership(ADMIN_ONE);
        vm.stopPrank();

        assertEq(trade.hasRole(trade.DEFAULT_ADMIN_ROLE(), ADMIN_ONE), true);
        assertEq(trade.hasRole(trade.DEFAULT_ADMIN_ROLE(), OWNER), false);
        // assertEq( true));
    }

    function testBuyAsset() public {
        Order memory order = Order(
            OWNER,
            address(0),
            address(0),
            address(0),
            address(token),
            PartnerFeeType.nonPartner,
            100,
            1,
            1,
            1
        );
        
        vm.startPrank(SELLER);
        // token.mint(SELLER, 1, 1, "");
        
        vm.stopPrank();
    }
}