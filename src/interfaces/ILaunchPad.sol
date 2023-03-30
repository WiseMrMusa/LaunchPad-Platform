// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

interface ILaunchPad {
    event Deposit(address, uint256); 
    function projectStartTime() external;
    function projectStopTime() external;
    function projectOwner() external;
    function tokenContractAddress() external;
    function totalShare() external;
    function value() external;
    function tokenHolders(uint256) external returns (address);
    function isTokenHolder(address) external returns (bool);
    function share(address) external returns (uint256);
    function depositNativeToken() external payable;
    function claimToken() external;
    function withDrawValue() external;
}
