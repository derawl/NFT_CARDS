//SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.21;

import "./OwnBafNft1155.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Factory1155 is AccessControl, ReentrancyGuard {
    bytes32 public constant WITHDRAWER_ROLE = keccak256("WITHDRAWER_ROLE");

    uint256 public mintFee;

    address public feeReceiver;

    mapping(address => bool) public isDeployed;

    event Deployed(address owner, address contractAddress);
    event MintFeeChanged(uint256 oldFee, uint256 newFee);
    event FeeReceiverChanged(address oldReceiver, address newReceiver);
    event MintFeeCollected(uint256 indexed amount, address indexed nftContract);
    event BaseURIChanged(address indexed nftContract, string indexed newURI);

    modifier isWithdrawerOrAdmin() {
        require(
            hasRole(WITHDRAWER_ROLE, msg.sender) ||
                hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
            "NOT Authorized"
        );
        _;
    }

    constructor(address admin_, address feeReceiver_) {
        feeReceiver = feeReceiver_;
        _setupRole(DEFAULT_ADMIN_ROLE, admin_);
    }

    function deploy(
        bytes32 _salt,
        string memory name,
        string memory symbol,
        string memory tokenURIPrefix
    ) external nonReentrant returns (address addr) {
        addr = address(
            new BafDevUser1155Token{salt: _salt}(
                name,
                symbol,
                tokenURIPrefix,
                address(this)
            )
        );
        BafDevUser1155Token token = BafDevUser1155Token(address(addr));
        token.initialize(msg.sender);
        isDeployed[addr] = true;
        emit Deployed(msg.sender, addr);
    }

    //sets the mint fee in eth
    function setMintFee(uint256 _mintFee) public onlyRole(DEFAULT_ADMIN_ROLE) {
        mintFee = _mintFee;
        emit MintFeeChanged(mintFee, _mintFee);
    }

    function setFeeReceiver(
        address _feeReceiver
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(
            _feeReceiver != address(0),
            "Invalid Address"
        );
        feeReceiver = _feeReceiver;
        emit FeeReceiverChanged(feeReceiver, _feeReceiver);
    }


    function sendFee() public payable nonReentrant {
        require(
            isDeployed[msg.sender],
            "Not Deployed"
        );
        require(msg.value >= mintFee, "Insufficient fee");
        (bool success, ) = payable(feeReceiver).call{value: msg.value}("");
        require(success, "Fee Failed");
        emit MintFeeCollected(msg.value, msg.sender);
    }

    function withdrawEth() public isWithdrawerOrAdmin nonReentrant {
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdrawErc20(
        address tokenAddress,
        address receipient
    ) public isWithdrawerOrAdmin nonReentrant {
        uint256 balance = IERC20(tokenAddress).balanceOf(address(this));
        require(
            IERC20(tokenAddress).transfer(receipient, balance),
            "ERC20 transfer failed"
        );
    }
}
