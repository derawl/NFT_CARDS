// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.21;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./common/ERC2981.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";
import {IFactory} from "./interface/IFactory.sol";


contract BafDevUser1155Token is
    Context,
    ERC1155Burnable,
    ERC1155Supply,
    ERC2981,
    AccessControl,
    Pausable
{
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _tokenIdTracker;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    bool public isInitialized;

    mapping(uint256 => string) private _tokenURIs;

    IFactory public factory;

    string public baseTokenURI;
    string private _name;
    string private _symbol;
    address public owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event MintFeeCollected(address indexed collector, uint256 indexed amount);
    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        string memory _baseTokenURI,
        address _factory
    ) ERC1155(_baseTokenURI) {
        baseTokenURI = _baseTokenURI;
        owner = _msgSender();
        _setupRole(ADMIN_ROLE, msg.sender);
        _name = _tokenName;
        _symbol = _tokenSymbol;
        _tokenIdTracker.increment();
        factory = IFactory(_factory);
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function pause() external whenNotPaused onlyRole(ADMIN_ROLE) {
        _pause();
    }

    function unpause() external whenPaused onlyRole(ADMIN_ROLE) {
        _unpause();
    }

    function initialize(address newOwner) external onlyRole(ADMIN_ROLE) {
        require(!isInitialized, "BafDevUser1155Token: already initialized");
        bool transfered = _transferOwnership(newOwner);
        require(
            transfered,
            "BafDevUser1155Token: Initialization ownership transfer failed"
        );
        isInitialized = true;
    }

    function transferOwnership(
        address newOwner
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        bool transfered = _transferOwnership(newOwner);
        require(transfered, "BafDevUser1155Token: Ownership transfer failed");
    }

    /** @dev change the Ownership from current owner to newOwner address
        @param newOwner : newOwner address 
    */
    function _transferOwnership(
        address newOwner
    ) internal whenNotPaused returns (bool) {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _revokeRole(ADMIN_ROLE, owner);
        owner = newOwner;
        _setupRole(ADMIN_ROLE, newOwner);
        _setupRole(DEFAULT_ADMIN_ROLE, newOwner);
        emit OwnershipTransferred(owner, newOwner);
        return true;
    }


    function mint(
        string memory _tokenURI,
        uint96 _royaltyFee,
        uint256 supply
    ) external payable virtual whenNotPaused returns (uint256 _tokenId) {
        if (factory.mintFee() > 0) {
            require(
                msg.value == factory.mintFee(),
                "BafDevUser1155Token: invalid fee amount"
            );
            factory.sendFee{value: msg.value}();
        }
        if (bytes(_tokenURI).length <= 0) {
            revert("BafDevUser1155Token: invalid token URI");
        }
        _tokenId = _tokenIdTracker.current();
        _mint(_msgSender(), _tokenId, supply, "");
        _tokenURIs[_tokenId] = _tokenURI;
        _setTokenRoyalty(_tokenId, _msgSender(), _royaltyFee);
        _tokenIdTracker.increment();
        emit MintFeeCollected(factory.feeReceiver(), msg.value);
        return _tokenId;
    }

    /*
     * @dev sets the royalty fee percentage for a given token
     * @param tokenId uint256 ID of the token to query
     * @return uint96 royalty fee
     */
    function editRoyalty(
        uint256 tokenId,
        uint96 royaltyFee
    ) external virtual returns (bool) {
        //feeDeonominator is 1e18 =100%
        (address minter, ) = royaltyInfo(tokenId, 1e18);
        require(_msgSender() == minter, "ERC1155: caller is not the owner");
        _setTokenRoyalty(tokenId, _msgSender(), royaltyFee);
        return true;
    }

    function uri(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(
            exists(tokenId),
            "ERC1155URIStorage: URI query for nonexistent token"
        );

        string memory _tokenURI = _tokenURIs[tokenId];
        if (bytes(baseTokenURI).length == 0) {
            return _tokenURI;
        }
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(baseTokenURI, _tokenURI));
        }
        return
            bytes(baseTokenURI).length > 0
                ? string(abi.encodePacked(baseTokenURI, tokenId.toString()))
                : "";
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC2981, ERC1155, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address _operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override(ERC1155Supply, ERC1155) {
        super._beforeTokenTransfer(_operator, from, to, ids, amounts, data);
    }
}