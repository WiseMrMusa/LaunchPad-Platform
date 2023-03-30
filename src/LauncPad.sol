// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LaunchPad is ERC20 {
    event Deposit(address, uint256);
    
    uint256 projectStartTime;
    uint256 projectStopTime;

    address projectOwner;
    uint256 _totalSupply;

    address[] tokenHolders;
    mapping(address => bool) isTokenHolder;
    mapping(address => uint256) share;

    constructor(
        string memory _tokenName, 
        string memory _tokenSymbol,
        uint256 _tokenTotalSupply,

        uint256 _projectStartTime,
        uint256 _projectEndTime
    ) ERC20(_tokenName, _tokenSymbol)
    {
        projectOwner = msg.sender;
        projectStartTime = _projectStartTime;
        projectStopTime = _projectEndTime;
        _totalSupply = _tokenTotalSupply;
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
