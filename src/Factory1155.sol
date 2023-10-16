//SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import "./OwnBafNft1155.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract Factory1155 is AccessControl {

    uint256 public mintFee;

    address public feeReceiver;

    mapping(address => bool) public isDeployed;

    event Deployed(address owner, address contractAddress);
    event MintFeeChanged(uint256 oldFee, uint256 newFee);
    event FeeReceiverChanged(address oldReceiver, address newReceiver);
    event MintFeeCollected(uint256 indexed amount, address indexed nftContract);



    constructor(){
        feeReceiver = msg.sender;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function deploy(
        bytes32 _salt,
        string memory name,
        string memory symbol,
        string memory tokenURIPrefix
    ) external returns (address addr) {
        addr = address(
            new BafDevUser1155Token{salt: _salt}(name, symbol, tokenURIPrefix, address(this)
        ));
        BafDevUser1155Token token = BafDevUser1155Token(address(addr));
        token.transferOwnership(msg.sender);
        isDeployed[addr] = true;
        emit Deployed(msg.sender, addr);
    }

    //sets the mint fee in eth
    function setMintFee(uint256 _mintFee) public onlyRole(DEFAULT_ADMIN_ROLE){
        mintFee = _mintFee;
        emit MintFeeChanged(mintFee, _mintFee);
    }

    function setFeeReceiver(address _feeReceiver) public onlyRole(DEFAULT_ADMIN_ROLE){
        require(_feeReceiver != address(0), "Factory1155: fee receiver is the zero address");
        feeReceiver = _feeReceiver;
        emit FeeReceiverChanged(feeReceiver, _feeReceiver);
    }
    
    //good that admin is multisig
    function sendFee() public payable {
        require(isDeployed[msg.sender], "Factory1155: not deployed by this factory");
        require(msg.value >= mintFee , "Factory1155: mint fee is zero");
        payable(feeReceiver).transfer(msg.value);
        emit MintFeeCollected(msg.value, msg.sender);
    }
}