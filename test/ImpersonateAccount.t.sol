// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test, console} from "forge-std/Test.sol";

// ERC-20 interface for interacting with the USDC token
interface IERC20 {
    function balanceOf(address) external view returns (uint256);

    function transfer(address, uint256) external returns (bool);

    function decimals() external view returns (uint8);
}

/**
 * @title ImpersonatAccountAndSendTokens - This test will impersonate an account and transfer tokens to another account
 * @author Soumil Vavikar
 * @notice This will run as expected ONLY on forked chain.
 */
contract ImpersonatAccountAndSendTokens is Test {
    // Interface instance for USDC
    IERC20 s_usdc;
    // Polygon's ERC20 Bridge contract address on Ethereum Mainnet, used as a whale account
    address s_whaleAccountAddress = 0x40ec5B33f54e0E8A33A975908C5BA1c14e5BbbDf;
    // Using one of the local anvil test account as the recipient
    address s_recipientAccountAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    // USDC contract address on Ethereum Mainnet
    address s_usdcContractAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    /**
     *  testTokenTransfer function tests the transfer of USDC from the whale account to the recipient
     */
    function testTokenTransfer() public {
        // Initializing the USDC module
        s_usdc = IERC20(s_usdcContractAddress);

        // Impersonate the whale account using the vm.startPrank command
        vm.startPrank(s_whaleAccountAddress);

        // Step 1: Get the initial balance of the recipient and whale account
        uint256 whaleInitialBalance = s_usdc.balanceOf(s_whaleAccountAddress);
        console.log("Whale's initial balance: ", whaleInitialBalance);
        
        uint256 recipientInitialBalance = s_usdc.balanceOf(s_recipientAccountAddress);
        console.log("Recipient's initial balance: ", recipientInitialBalance);

        // Step 2: Get the decimal number of USDC and finalize the tokens to transfer
        uint8 usdcDecimals = s_usdc.decimals();
        uint256 tokensToTransfer = 1000000 * 10 ** usdcDecimals;

        // Step 3: Perform the token transfer from the whale to the recipient
        s_usdc.transfer(s_recipientAccountAddress, tokensToTransfer);

        // Step 4: Get the final balance of the recipient and whale account
        uint256 whaleFinalBalance = s_usdc.balanceOf(s_whaleAccountAddress);
        console.log("Whale's final balance: ", whaleFinalBalance);

        uint256 recipientFinalBalance = s_usdc.balanceOf(s_recipientAccountAddress);
        console.log("Recipient's final balance: ", recipientFinalBalance);

        // Step 5: Verify that the recipient's balance increased by the transfer amount
        assertEq(
            recipientFinalBalance,
            recipientInitialBalance + tokensToTransfer,
            "Token transfer failed"
        );

        // Stop impersonating the whale account
        vm.stopPrank();
    }
}
