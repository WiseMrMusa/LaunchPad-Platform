// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/LaunchPadFactory.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LaunchPadFactoryTest is Test {
    LaunchPadFactory launchPadFactory;
    ERC20 tokenA;

    function setUp() public{
        launchPadFactory = new LaunchPadFactory();
        tokenA = new ERC20("Token A", "TKA");
        deal(address(tokenA), address(0x90), 20 ether);
    }

    function test_1_createFactory() public {
        vm.prank(address(0x90));
        launchPadFactory.createLaunchPadProject(address(tokenA),10000,block.timestamp + 1000, block.timestamp + 1000);
    }
}
