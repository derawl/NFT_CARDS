// SPDX-License-Identifier:UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "../interface/ITransferProxy.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";

contract Trade is AccessControl, Pausable{

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");


    enum PartnerFeeType {
        nonPartner,
        partner
    }

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event SellerFee(uint8 sellerFee);
    event BuyerFee(uint8 buyerFee);
    event PartnerFee(uint8 partnerFee);
    event BuyAsset(
        address nftAddress,
        address indexed assetOwner,
        uint256 indexed tokenId,
        uint256 quantity,
        address indexed buyer
    );
    event ExecuteBid(
        address nftAddress,
        address indexed assetOwner,
        uint256 indexed tokenId,
        uint256 quantity,
        address indexed buyer
    );
    // buyer platformFee
    uint8 private buyerFeePermille;
    //seller platformFee
    uint8 private sellerFeePermille;
    //partner platformFee
    uint8 private partnerFeePermille;

    ITransferProxy public transferProxy;
    //contract owner and admins
    address public owner;
    address public admin1;
    address public admin2;

    mapping(uint256 => bool) private usedNonce;

    /** Fee Struct
        @param platformFee  uint256 (buyerFee + sellerFee) value which is transferred to current contract owner.
        @param assetFee  uint256  assetvalue which is transferred to current seller of the NFT.
        @param royaltyFee  uint256 value, transferred to Minter of the NFT.
        @param price  uint256 value, the combination of buyerFee and assetValue.
        @param tokenCreator address value, it's store the creator of NFT.
     */
    struct Fee {
        uint256 buyerFee;
        uint256 sellerFee;
        uint256 partnerFee;
        uint256 assetFee;
        uint256 royaltyFee;
        uint256 price;
        address tokenCreator;
    }

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
        @param uintprice the Price Each NFT it's not including the buyerFee.
        @param amount the price of NFT(assetFee + buyerFee).
        @param tokenId 
        @param qty number of quantity to be transfer.
     */
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

    constructor(
        uint8 _buyerFee,
        uint8 _sellerFee,
        uint8 _partnerFee,
        address _admin1,
        address _admin2,
        ITransferProxy _transferProxy
    ) {
        buyerFeePermille = _buyerFee;
        sellerFeePermille = _sellerFee;
        partnerFeePermille = _partnerFee;
        transferProxy = _transferProxy;
        owner = msg.sender;
        admin1 = _admin1;
        admin2 = _admin2;
        _setupRole(ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, admin1);
        _setupRole(ADMIN_ROLE, admin2);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
        returns the buyerservice Fee in multiply of 1000.
     */

    function buyerServiceFee() external view virtual returns (uint8) {
        return buyerFeePermille;
    }

    /**
        returns the sellerservice Fee in multiply of 1000.
     */

    function sellerServiceFee() external view virtual returns (uint8) {
        return sellerFeePermille;
    }

    function partnerServiceFee() external view virtual returns (uint8) {
        return partnerFeePermille;
    }


    function pause() external onlyRole(ADMIN_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(ADMIN_ROLE) {
        _unpause();
    }

    /** 
        @param _buyerFee  value for buyerservice in multiply of 1000.
    */

    function setBuyerServiceFee(
        uint8 _buyerFee
    ) external onlyRole(ADMIN_ROLE) returns (bool) {
        buyerFeePermille = _buyerFee;
        emit BuyerFee(buyerFeePermille);
        return true;
    }

    /** 
        @param _sellerFee  value for buyerservice in multiply of 1000.
    */

    function setSellerServiceFee(
        uint8 _sellerFee
    ) external onlyRole(ADMIN_ROLE) returns (bool) {
        sellerFeePermille = _sellerFee;
        emit SellerFee(sellerFeePermille);
        return true;
    }

    function setPartnerFee(
        uint8 _partnerFee
    ) external onlyRole(ADMIN_ROLE) returns (bool) {
        partnerFeePermille = _partnerFee;
        emit PartnerFee(partnerFeePermille);
        return true;
    }

    /**
        transfers the contract ownership to newowner address.    
        @param newOwner address of newOwner
     */

    function transferOwnership(
        address newOwner
    ) external onlyRole(DEFAULT_ADMIN_ROLE) returns (bool) {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _revokeRole(ADMIN_ROLE, owner);
        _revokeRole(DEFAULT_ADMIN_ROLE, owner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        _setupRole(ADMIN_ROLE, newOwner);
        _setupRole(DEFAULT_ADMIN_ROLE, newOwner);
        return true;
    }

    function setAdmin1(
        address newAdmin1
    ) external onlyRole(DEFAULT_ADMIN_ROLE) returns (bool) {
        require(
            newAdmin1 != address(0),
            "Admin1: new admin is the zero address"
        );
        _revokeRole(ADMIN_ROLE, admin1);
        _grantRole(ADMIN_ROLE, newAdmin1);
        admin1 = newAdmin1;
        return true;
    }

    function setAdmin2(
        address newAdmin2
    ) external onlyRole(DEFAULT_ADMIN_ROLE) returns (bool) {
        require(
            newAdmin2 != address(0),
            "Admin2: new admin is the zero address"
        );
        _revokeRole(ADMIN_ROLE, admin2);
        _grantRole(ADMIN_ROLE, newAdmin2);
        admin2 = newAdmin2;
        return true;
    }

    /**
        excuting the NFT order.
        @param order ordervalues(seller, buyer,...).
        @param sign Sign value(v, r, f).
    */

    function buyAsset(
        Order calldata order,
        Sign calldata sign
    ) external whenNotPaused returns (bool) {
        require(!usedNonce[sign.nonce], "Nonce : Invalid Nonce");
        usedNonce[sign.nonce] = true;
        Fee memory fee = getFees(
            order.amount,
            order.nftAddress,
            order.tokenId
        );
        require(
            (fee.price >= order.unitPrice * order.qty),
            "Paid invalid amount"
        );
        _verifySellerSign(
            order.seller,
            order.tokenId,
            order.unitPrice,
            order.erc20Address,
            order.nftAddress,
            sign
        );
        address buyer = msg.sender;
        _tradeAsset(order, fee, buyer, order.seller);
        emit BuyAsset(
            order.nftAddress,
            order.seller,
            order.tokenId,
            order.qty,
            msg.sender
        );
        return true;
    }

    /**
        excuting the NFT order.
        @param order ordervalues(seller, buyer,...).
        @param sign Sign value(v, r, f).
    */

    function executeBid(
        Order calldata order,
        Sign calldata sign
    ) external whenNotPaused returns (bool) {
        require(!usedNonce[sign.nonce], "Nonce : Invalid Nonce");
        usedNonce[sign.nonce] = true;
        Fee memory fee = getFees(
            order.amount,
            order.nftAddress,
            order.tokenId
        );
        _verifyBuyerSign(
            order.buyer,
            order.tokenId,
            order.amount,
            order.erc20Address,
            order.nftAddress,
            order.qty,
            sign
        );
        address seller = msg.sender;
        _tradeAsset(order, fee, order.buyer, seller);
        emit ExecuteBid(
            order.nftAddress,
            msg.sender,
            order.tokenId,
            order.qty,
            order.buyer
        );
        return true;
    }

    /**
        returns the signer of given signature.
     */
    function _getSigner(
        bytes32 hash,
        Sign memory sign
    ) internal pure returns (address) {
        return
            ecrecover(
                keccak256(
                    abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
                ),
                sign.v,
                sign.r,
                sign.s
            );
    }

    function _verifySellerSign(
        address seller,
        uint256 tokenId,
        uint256 amount,
        address paymentAssetAddress,
        address assetAddress,
        Sign memory sign
    ) internal pure {
        bytes32 hash = keccak256(
            abi.encodePacked(
                assetAddress,
                tokenId,
                paymentAssetAddress,
                amount,
                sign.nonce
            )
        );
        require(
            seller == _getSigner(hash, sign),
            "seller sign verification failed"
        );
    }

    function _verifyBuyerSign(
        address buyer,
        uint256 tokenId,
        uint256 amount,
        address paymentAssetAddress,
        address assetAddress,
        uint256 qty,
        Sign memory sign
    ) internal pure {
        bytes32 hash = keccak256(
            abi.encodePacked(
                assetAddress,
                tokenId,
                paymentAssetAddress,
                amount,
                qty,
                sign.nonce
            )
        );
        require(
            buyer == _getSigner(hash, sign),
            "buyer sign verification failed"
        );
    }

    /**
        it retuns platformFee, assetFee, royaltyFee, price and tokencreator.
     */

    function getFees(
        uint256 paymentAmt,
        address buyingAssetAddress,
        uint256 tokenId
    ) public view returns (Fee memory) {
        address tokenCreator;
        uint256 royaltyFee;
        uint256 assetFee;
        uint256 price = (paymentAmt * 1000) / (1000 + buyerFeePermille);
        uint256 buyerFee = paymentAmt - price;
        uint256 sellerFee = (price * sellerFeePermille) / 1000;
        uint256 partnerFee = (price * partnerFeePermille) / 1000;
        
        (tokenCreator, royaltyFee) = IERC2981(buyingAssetAddress)
            .royaltyInfo(tokenId, price);
        
        assetFee = price - sellerFee - royaltyFee - partnerFee;
        return
            Fee(
                buyerFee,
                sellerFee,
                partnerFee,
                assetFee,
                royaltyFee,
                price,
                tokenCreator
            );
    }

    /** 
        transfers the NFTs and tokens...
        @param order ordervalues(seller, buyer,...).
        @param fee Feevalues(platformFee, assetFee,...).
    */

    function _tradeAsset(
        Order calldata order,
        Fee memory fee,
        address buyer,
        address seller
    ) internal virtual {
        
        transferProxy.erc1155safeTransferFrom(
            IERC1155(order.nftAddress),
            seller,
            buyer,
            order.tokenId,
            order.qty,
            ""
        );
        
        if (fee.buyerFee > 0) {
            transferProxy.erc20safeTransferFrom(
                IERC20(order.erc20Address),
                buyer,
                admin1,
                fee.buyerFee
            );
        }
        if (fee.sellerFee > 0) {
            transferProxy.erc20safeTransferFrom(
                IERC20(order.erc20Address),
                buyer,
                admin2,
                fee.sellerFee
            );
        }
        if (fee.sellerFee > 0 && order.partnerType == PartnerFeeType.partner) {
            transferProxy.erc20safeTransferFrom(
                IERC20(order.erc20Address),
                buyer,
                order.partner,
                fee.partnerFee
            );
        }
        else {
            transferProxy.erc20safeTransferFrom(
                IERC20(order.erc20Address),
                buyer,
                seller,
                fee.partnerFee
            );
        }
        if (fee.royaltyFee > 0) {
            transferProxy.erc20safeTransferFrom(
                IERC20(order.erc20Address),
                buyer,
                fee.tokenCreator,
                fee.royaltyFee
            );
        }
        transferProxy.erc20safeTransferFrom(
            IERC20(order.erc20Address),
            buyer,
            seller,
            fee.assetFee
        );
    }
}