// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.23;

import {Test, console} from  "forge-std/Test.sol";
import "forge-std/Script.sol";
import  {CollaborativeNFTOwnership} from  "../src/FractionalNFT.sol";

contract CollaborativeNFTOwnershipTest is Test {
    CollaborativeNFTOwnership nftContract;
    address owner = address(this);
    address contributor1 = address(0x123);
    address contributor2 = address(0x456);

    function setUp() public {
        // Deploy the contract
        nftContract = new CollaborativeNFTOwnership();
    }

    function testAssignShares() public {
        // Initialize test data
        address[] memory contributors = new address[](2);
        contributors[0] = contributor1;
        contributors[1] = contributor2;

        uint256[] memory shares = new uint256[](2);
        shares[0] = 60;
        shares[1] = 40;

        // Assign shares
        nftContract.assignShares(contributors, shares);

        // Check if shares were assigned correctly
        (uint256 contributor1Shares, bool exists1) = nftContract.contributors(contributor1);
        (uint256 contributor2Shares, bool exists2) = nftContract.contributors(contributor2);

        assertTrue(exists1, "Contributor1 should exist");
        assertTrue(exists2, "Contributor2 should exist");
        assertEq(contributor1Shares, 60, "Contributor1 should have 60 shares");
        assertEq(contributor2Shares, 40, "Contributor2 should have 40 shares");
    }

    function testAssignSharesOnlyOwner() public {
        // Simulate a non-owner trying to assign shares
        vm.prank(address(0x789));
        address[] memory contributors = new address[](2);
        contributors[0] = contributor1;
        contributors[1] = contributor2;
        uint256[] memory shares = new uint256[](2);
        shares[0] = 60;
        shares[1] = 40;

        // Expect the transaction to revert due to onlyOwner modifier
        vm.expectRevert("not owner");
        nftContract.assignShares(contributors, shares);
    }

    function testBuyNFTAndDistributePayments() public {
        // Assign shares to contributors
        uint256[] memory shares = new uint256[](2);
        shares[0] = 60;
        shares[1] = 40;

        // Start tracking balance for contributors
        uint256 initialBalanceContributor1 = contributor1.balance;
        uint256 initialBalanceContributor2 = contributor2.balance;

        // Buy NFT and pay 1 ether
        uint256 tokenId = 1;
        vm.deal(address(this), 1 ether); // Fund the buyer
        nftContract.buyNFT{value: 1 ether}(tokenId);

        // Calculate expected payments
        uint256 expectedPaymentContributor1 = (60 * 1 ether) / 100;
        uint256 expectedPaymentContributor2 = (40 * 1 ether) / 100;

        // Verify balances after payment distribution
        assertEq(contributor1.balance, initialBalanceContributor1 + expectedPaymentContributor1, "Contributor1 should receive 60%");
        assertEq(contributor2.balance, initialBalanceContributor2 + expectedPaymentContributor2, "Contributor2 should receive 40%");
    }

    function testBuyNFTNoPaymentShouldFail() public {
        uint256 tokenId = 1;

        // Expect the transaction to revert due to zero payment
        vm.expectRevert("Payment is required to buy NFT");
        nftContract.buyNFT(tokenId);
    }

    function testDoubleAssignSharesFails() public {
        // Assign shares to contributors
        address[] memory contributors = new address[](2);
        contributors[0] = contributor1;
        contributors[1] = contributor2;
        uint256[] memory shares = new uint256[](2);
        shares[0] = 60;
        shares[1] = 40;
        nftContract.assignShares(contributors, shares);

        // Attempt to assign shares to the same contributor again should fail
        vm.expectRevert("Contributor already exists");
        nftContract.assignShares(contributors, shares);
    }

    function testAssignSharesInvalidLengthShouldFail() public {
        // Set up mismatched lengths for contributors and shares
        address[] memory contributors = new address[](2);
        contributors[0] = contributor1;
        contributors[1] = contributor2;
        uint256[] memory shares = new uint256[](2);
        shares[0] = 60;
        shares[1] = 40;

        // Expect the transaction to revert due to length mismatch
        vm.expectRevert("Contributors and shares length mismatch");
        nftContract.assignShares(contributors, shares);
    }
}