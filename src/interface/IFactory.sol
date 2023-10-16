pragma solidity 0.8.17;

interface IFactory{
    function deploy(
        bytes32 _salt,
        string memory name,
        string memory symbol,
        string memory tokenURIPrefix
    ) external returns (address addr);
    function mintFee() external view returns (uint256);
    function setMintFee() external;
    function setFeeReceiver() external;
    function feeReceiver() external view returns (address);
    function sendFee() external payable;
}