// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/LaunchPadFactory.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/interfaces/ILaunchPad.sol";


contract LaunchPadFactoryTest is Test {
    LaunchPadFactory launchPadFactory;
    ERC20 tokenA;

    function setUp() public{
        launchPadFactory = new LaunchPadFactory();
        tokenA = new ERC20("Token A", "TKA");
        deal(address(tokenA), address(0x90), 20 ether);
    }

    function test_1_createFactory() public {
        vm.startPrank(address(0x90));
        IERC20(address(tokenA)).approve(address(launchPadFactory),20 ether);
        launchPadFactory.createLaunchPadProject(address(tokenA),20000,block.timestamp + 10, block.timestamp + 1000);
        vm.stopPrank();
    }

    function test_2_CheckTotalShare() public{
        test_1_createFactory();
        address hello = launchPadFactory.getLaunchPadProjectByID(0);
        ILaunchPad(hello).totalShare();
    }

    function test_3_DepositNativeToken() public {
        test_1_createFactory();
        vm.warp(100);
        depositNativeToken(0,address(0x30),1 ether);
        depositNativeToken(0,address(0x31),10 ether);
        depositNativeToken(0,address(0x32),5 ether);
        depositNativeToken(0,address(0x33),7 ether);
        depositNativeToken(0,address(0x34),3 ether);
        depositNativeToken(0,address(0x35),8 ether);
        depositNativeToken(0,address(0x36),4 ether);
    }

    function test_4_ClaimToken() public {
        test_3_DepositNativeToken();
        claimToken(0,address(0x30));
        claimToken(0,address(0x31));
        claimToken(0,address(0x32));
        claimToken(0,address(0x33));
        claimToken(0,address(0x34));
        claimToken(0,address(0x35));
        claimToken(0,address(0x36));
    }







    function depositNativeToken(uint256 id,address depositor, uint256 deposit) internal {
        deal(depositor, deposit);
        address project = launchPadFactory.getLaunchPadProjectByID(id);
        vm.prank(depositor);
        ILaunchPad(project).depositNativeToken{value: deposit}();
    }
    function claimToken(uint256 id,address depositor) internal {
        address project = launchPadFactory.getLaunchPadProjectByID(id);
        vm.prank(depositor);
        ILaunchPad(project).claimToken();
    }
}
