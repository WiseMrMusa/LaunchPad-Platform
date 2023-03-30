// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LaunchPad {
    event Deposit(address, uint256);
    
    uint256 projectStartTime;
    uint256 projectStopTime;

    address projectOwner;
    address tokenContractAddress;
    uint256 public totalShare;
    uint256 value;

    address[] tokenHolders;
    mapping(address => bool) isTokenHolder;
    mapping(address => uint256) share;

    constructor(
        address _tokenContractAddress,
        uint256 _totalTokenShare,

        uint256 _projectStartTime,
        uint256 _projectEndTime,

        address _owner
    ) {
        projectOwner = _owner;
        projectStartTime = _projectStartTime;
        projectStopTime = _projectEndTime;

        totalShare = _totalTokenShare;
        tokenContractAddress = _tokenContractAddress;
    }

    function depositNativeToken() public payable {
        ensureProjectHasStarted();
        ensureProjectHasNotEnded();
        if(!isTokenHolder[msg.sender]){
            isTokenHolder[msg.sender] = true;
            tokenHolders.push(msg.sender);
        }
        value += msg.value;
        share[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    

    function claimToken() public{
        ensureIsTokenHolder();
        ensureProjectHasEnded();
        uint256 myToken = (share[msg.sender] * totalShare) / value;
        IERC20(tokenContractAddress).transfer(msg.sender,myToken);
    }

    function withDrawValue() public{
        ensureIsProjectOwner();
        ensureProjectHasEnded();
        (bool success,) = payable(projectOwner).call{value: 45 }("");
        if(!success) revert("Failed");
    }

    function ensureProjectHasStarted() internal view{
        if(block.timestamp < projectStartTime) revert("Project has not started!");
    }
    function ensureProjectHasNotEnded() internal view{
        if(block.timestamp > projectStopTime) revert("Project has ended!");
    }

    function ensureProjectHasEnded() internal view {
        if(block.timestamp < projectStopTime) revert("Project is still on!");
    }

    function ensureIsTokenHolder() internal view {
        if (isTokenHolder[msg.sender] != true) revert("You are not a token holder");
    }

    function ensureIsProjectOwner() internal view {
        if (msg.sender != projectOwner) revert("You are not authorized for this");
    }
}
