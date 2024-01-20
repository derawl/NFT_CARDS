//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.21;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./interface/ITransferProxy.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract TransferProxy is AccessControl, ITransferProxy, ReentrancyGuard  {
    event OperatorChanged(address indexed from, address indexed to);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    address public owner;
    address public operator;

    constructor() {
        owner = msg.sender;
        _setupRole("ADMIN_ROLE", msg.sender);
        _setupRole("OPERATOR_ROLE", operator);
    }

    function changeOperator(address _operator)
        external
        onlyRole("ADMIN_ROLE")
        returns (bool)
    {
        require(
            _operator != address(0),
            "Operator: new operator is the zero address"
        );
        _revokeRole("OPERATOR_ROLE", operator);
        operator = _operator;
        _setupRole("OPERATOR_ROLE", operator);
        emit OperatorChanged(address(0), operator);
        return true;
    }

    /** change the Ownership from current owner to newOwner address
        @param newOwner : newOwner address */

    function transferOwnership(address newOwner)
        external
        onlyRole("ADMIN_ROLE")
        returns (bool)
    {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _revokeRole("ADMIN_ROLE", owner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        _setupRole("ADMIN_ROLE", newOwner);
        return true;
    }

    function erc1155safeTransferFrom(
        IERC1155 token,
        address from,
        address to,
        uint256 tokenId,
        uint256 value,
        bytes calldata data
    ) external nonReentrant onlyRole("OPERATOR_ROLE") {
        token.safeTransferFrom(from, to, tokenId, value, data);
    }

    function erc20safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) external nonReentrant onlyRole("OPERATOR_ROLE") {
        require(
            token.transferFrom(from, to, value),
            "failure while transferring"
        );
    }

    function withdrawErc20(address tokenAddress, address receipient) external onlyRole("ADMIN_ROLE") {
        uint256 balance = IERC20(tokenAddress).balanceOf(address(this));
        require(balance > 0, "Trade: Insufficient balance");
        require(IERC20(tokenAddress).transfer(receipient, balance), "ERC20 transfer failed");
    }

    function withdrawEth(address payable receipient) external onlyRole("ADMIN_ROLE") {
        uint256 balance = address(this).balance;
        require(balance > 0, "Trade: Insufficient balance");
        (bool success, ) = receipient.call{value: balance}("");
        require(success, "Eth Transfer failed.");
    }
}