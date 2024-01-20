// SPDX-License-Identifier:UNLICENSED
pragma solidity 0.8.21;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "./interface/ITransferProxy.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";


//Todo: make sure fee structures maintain precision of 1000

contract TradeV3 is AccessControl, Pausable, ReentrancyGuard{

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");


    enum PartnerFeeType {
        nonPartner,
        partner
    }

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event MaxRoyaltyFee(uint16 maxRoyaltyFee);
    event MarketingFee(uint16 marketingFee);
    event SellerFee(uint16 sellerFee);
    event PartnerFee(uint16 partnerFee);
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
    event FeeTransfers(
        uint256 indexed tokenId,
        uint256 indexed royaltyFee,
        uint256 indexed sellerFee,
        uint256 partnerFee,
        uint256 marketingFee,
        uint256 assetFee
    );


    uint16 public constant PRECISION = 1000;

    //seller platformFee
    uint16 public sellerFeePermille;
    //partner platformFee
    uint16 public partnerFeePermille;

    //royalty fee 
    uint16 public maxRoyaltyFee;

    uint16 public marketingFeePermille;

    ITransferProxy public transferProxy;
    //contract owner and admins
    address public owner;
    address public admin1;
    address public admin2;

    mapping(uint256 => bool) public  usedNonce;

    /** Fee Struct
        @param platformFee  sellerFee value which is transferred to current contract owner.
        @param assetFee  uint256  assetvalue which is transferred to current seller of the NFT.
        @param royaltyFee  uint256 value, transferred to Minter of the NFT.
        @param price  uint256 value, the assetValue.
        @param tokenCreator address value, it's store the creator of NFT.
     */
    struct Fee {
        uint256 sellerFee;
        uint256 partnerFee;
        uint256 marketingFee;
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
        @param uintprice the Price Each NFT.
        @param amount the price of NFT(assetFee).
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


    modifier isValidRange(uint16 _value) {
        require(_value >= 0 && _value <= PRECISION, "Trade: Invalid value");
        _;
    }

    constructor(
        uint16 _maxRoyaltyFee,
        uint16 _sellerFee,
        uint16 _partnerFee,
        uint16 _maketingFee,
        address _admin1,
        address _admin2,
        ITransferProxy _transferProxy
    ) {
        sellerFeePermille = _sellerFee;
        partnerFeePermille = _partnerFee;
        marketingFeePermille = _maketingFee;
        transferProxy = _transferProxy;
        owner = msg.sender;
        admin1 = _admin1;
        admin2 = _admin2;
        maxRoyaltyFee = _maxRoyaltyFee;
        _setupRole(ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, admin1);
        _setupRole(ADMIN_ROLE, admin2);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
        returns the sellerservice Fee in multiply of PRECISION.
     */

    function sellerServiceFee() external view virtual returns (uint16) {
        return sellerFeePermille;
    }

    function partnerServiceFee() external view virtual returns (uint16) {
        return partnerFeePermille;
    }

    function setMaxRoyaltyFee(uint16 _maxRoyaltyFee) external onlyRole(ADMIN_ROLE) isValidRange(_maxRoyaltyFee) returns (bool) {
        maxRoyaltyFee = _maxRoyaltyFee;
        emit MaxRoyaltyFee(_maxRoyaltyFee);
        return true;
    }



    function pause() external onlyRole(ADMIN_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(ADMIN_ROLE) {
        _unpause();
    }


    function setTransferProxy(address newTransferProxy) external onlyRole(ADMIN_ROLE) returns (bool) {
        require(newTransferProxy != address(0), "Trade: Invalid address");
        transferProxy = ITransferProxy(newTransferProxy);
        return true;
    }

    function setAllFees(
        uint16 _maxRoyaltyFee,
        uint16 _marketingFee,
        uint16 _sellerFee,
        uint16 _partnerFee
    ) external onlyRole(ADMIN_ROLE) returns (bool) {
        require(_marketingFee >= 0 && _marketingFee <= PRECISION, "Trade: Invalid value");
        require(_sellerFee >= 0 && _sellerFee <= PRECISION, "Trade: Invalid value");
        require(_partnerFee >= 0 && _partnerFee <= PRECISION, "Trade: Invalid value");
        require(_maxRoyaltyFee >= 0 && _maxRoyaltyFee <= PRECISION, "Trade: Invalid value");
        marketingFeePermille = _marketingFee;
        sellerFeePermille = _sellerFee;
        partnerFeePermille = _partnerFee;
        maxRoyaltyFee = _maxRoyaltyFee;
        emit MaxRoyaltyFee(_maxRoyaltyFee);
        emit MarketingFee(_marketingFee);
        emit SellerFee(_sellerFee);
        emit PartnerFee(_partnerFee);
        return true;
    }


    function setMarketingFee(
        uint16 _marketingFee
    ) external onlyRole(ADMIN_ROLE) isValidRange(_marketingFee) returns (bool) {
        marketingFeePermille = _marketingFee;
        emit MarketingFee(marketingFeePermille);
        return true;
    }
   
    /** 
        @param _sellerFee  value for buyerservice in multiply of PRECISION.
    */

    function setSellerServiceFee(
        uint16 _sellerFee
    ) external onlyRole(ADMIN_ROLE) isValidRange(_sellerFee) returns (bool) {
        sellerFeePermille = _sellerFee;
        emit SellerFee(sellerFeePermille);
        return true;
    }

    function setPartnerFee(
        uint16 _partnerFee
    ) external onlyRole(ADMIN_ROLE) isValidRange(_partnerFee) returns (bool) {
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

    /*
        change the admin2 from current admin2 to admin2 address.
        @param newAdmin2 the new admin address
     */
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
    ) external nonReentrant whenNotPaused returns (bool) {
        require(!usedNonce[sign.nonce], "Nonce : Invalid Nonce");
        usedNonce[sign.nonce] = true;
        Fee memory fee = getFees(
            order.amount,
            order.nftAddress,
            order.tokenId
        );
        // require(
        //     (fee.price >= order.unitPrice * order.qty),
        //     "Paid invalid amount"
        // );
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
    ) external nonReentrant whenNotPaused returns (bool) {
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
    ) private pure {
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
    ) private pure {
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
        uint256 price =  paymentAmt;
        uint256 sellerFee = (price * sellerFeePermille) / PRECISION;
        uint256 partnerFee = (price * partnerFeePermille) / PRECISION;
        
        (tokenCreator, royaltyFee) = IERC2981(buyingAssetAddress)
            .royaltyInfo(tokenId, price);

        uint256 maxAcceptableRoyaltyFee = (price * maxRoyaltyFee) / PRECISION;

        uint256 marketingFee = (price * marketingFeePermille) / PRECISION;

        royaltyFee = royaltyFee > maxAcceptableRoyaltyFee
            ? maxAcceptableRoyaltyFee
            : royaltyFee;
        
        assetFee = price - (sellerFee + royaltyFee + partnerFee + marketingFee);
       
        return
            Fee(
                sellerFee,
                partnerFee,
                marketingFee,
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
        
        if (fee.marketingFee > 0) {
            transferProxy.erc20safeTransferFrom(
                IERC20(order.erc20Address),
                buyer,
                admin1,
                fee.marketingFee
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

        emit FeeTransfers(
            order.tokenId,
            fee.royaltyFee,
            fee.sellerFee,
            fee.partnerFee,
            fee.marketingFee,
            fee.assetFee
            );
    }


    function withdrawErc20(address tokenAddress, address receipient) external onlyRole(ADMIN_ROLE) {
        uint256 balance = IERC20(tokenAddress).balanceOf(address(this));
        require(balance > 0, "Trade: Insufficient balance");
        require(IERC20(tokenAddress).transfer(receipient, balance), "ERC20 transfer failed");
    }

    function withdrawEth(address payable receipient) external onlyRole(ADMIN_ROLE) {
        uint256 balance = address(this).balance;
        require(balance > 0, "Trade: Insufficient balance");
        (bool success, ) = receipient.call{value: balance}("");
        require(success, "Trade: ETH transfer failed");
    }
}