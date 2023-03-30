// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./LauncPad.sol";

contract LaunchPadFactory {
   address[] launchPadProjects;

   function createLaunchPadProject(
    address _tokenAddress,
    uint256 _totalTokenShare,
    uint256 _projectStartTime,
    uint256 _projectEndTime

   ) public {
    LaunchPad myLaunchPadProject = new LaunchPad(
        _tokenAddress,
        _totalTokenShare,
        _projectStartTime,
        _projectEndTime
    );

    launchPadProjects.push(address(myLaunchPadProject));
    IERC20(_tokenAddress).transfer(address(myLaunchPadProject), _totalTokenShare);
    
   }
}
