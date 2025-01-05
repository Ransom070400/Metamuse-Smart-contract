// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console} from  "forge-std/Test.sol";
import  {SecureNFTMinter} from  "../src/NFT.sol";

contract SecureNFTMinterTest is Test {
    SecureNFTMinter nftMinter;
    address owner = address(0x1);
    address bridge = address(0x2);
    address user1 = address(0x3);
    address user2 = address(0x4);

    function setUp() public {
        vm.prank(owner);
        nftMinter = new SecureNFTMinter("TestNFT", "TNFT");
    }

    function testMintNFT() public {
        // Mint an NFT for user1
        vm.prank(user1);
        uint256 tokenId = nftMinter.mintNFT(user1, "QmExampleHash123");

        // Check that the tokenId incremented correctly and ownership is set
        assertEq(nftMinter.ownerOf(tokenId), user1);
        assertEq(nftMinter.tokenURI(tokenId), "ipfs://QmExampleHash123");
    }

    function testSetBridgeAddress() public {
        // Set the bridge address as the owner
        vm.prank(owner);
        nftMinter.setBridgeAddress(bridge);

        // Verify the bridge address was set
        assertEq(nftMinter.bridgeAddress(), bridge);
    }

    function testTransferNFTByBridge() public {
        // Mint an NFT for user1
        vm.prank(user1);
        uint256 tokenId = nftMinter.mintNFT(user1, "QmExampleHash123");

        // Set the bridge address
        vm.prank(owner);
        nftMinter.setBridgeAddress(bridge);

        // Attempt transfer by bridge to user2
        vm.prank(bridge);
        nftMinter.transferNFT(tokenId, user2);

        // Verify the new ownership
        assertEq(nftMinter.ownerOf(tokenId), user2);
    }

    function testFailTransferNFTByNonBridge() public {
        // Mint an NFT for user1
        vm.prank(user1);
        uint256 tokenId = nftMinter.mintNFT(user1, "QmExampleHash123");

        // Set the bridge address
        vm.prank(owner);
        nftMinter.setBridgeAddress(bridge);

        // Attempt transfer by non-bridge address (should fail)
        vm.prank(user1);
        nftMinter.transferNFT(tokenId, user2); // This should revert
    }
}