// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LaunchPad {
    event Deposit(address, uint256);
    
    uint256 projectStartTime;
    uint256 projectStopTime;

    address projectOwner;
    address tokenContractAddress;
    uint256 totalShare;

    address[] tokenHolders;
    mapping(address => bool) isTokenHolder;
    mapping(address => uint256) share;

    constructor(
        address _tokenContractAddress,
        uint256 _totalTokenShare,

        uint256 _projectStartTime,
        uint256 _projectEndTime
    ) {
        projectOwner = msg.sender;
        projectStartTime = _projectStartTime;
        projectStopTime = _projectEndTime;

        totalShare = _totalTokenShare;
        tokenContractAddress = _tokenContractAddress;
        // IERC20(_tokenContractAddress).transferFrom(msg.sender, address(this), _totalTokenShare);
    }

    function depositNativeToken() public payable {
        ensureProjectHasStarted();
        ensureProjectHasNotEnded();
        if(!isTokenHolder[msg.sender]){
            isTokenHolder[msg.sender] = true;
            tokenHolders.push(msg.sender);
        }
        share[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }


    function ensureProjectHasStarted() internal view{
        if(block.timestamp < projectStartTime) revert("Project has not started!");
    }
    function ensureProjectHasNotEnded() internal view{
        if(block.timestamp > projectStopTime) revert("Project has ended!");
    }
}
