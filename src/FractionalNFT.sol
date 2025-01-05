// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;


contract CollaborativeNFTOwnership {
    struct Contributor {
        uint256 shares; // Share percentage (e.g., 100 = 100%)
        bool exists; // You can add more fields if necessary
    }

    mapping(address => Contributor) public contributors;
    address[] public contributorAddresses;
    uint256 public totalShares;
    address public owner; // Owner on Lisk

    event NFTPurchased(address indexed buyer, uint256 totalPaid, uint256 tokenId);
    event SharesAssigned(address indexed contributor, uint256 shares);
    event PaymentDistributed(address indexed contributor, uint256 amount);

    modifier onlyOwner(){
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor() {
        totalShares = 100; // Total shares represent 100% ownership
        owner = msg.sender;
    }

    // Assign shares to each contributor based on collaboration percentage
    function assignShares(address[] memory _contributors, uint256[] memory _shares) external onlyOwner {
        require(_contributors.length == _shares.length, "Contributors and shares length mismatch");
        
        for (uint256 i = 0; i < _contributors.length; i++) {
            address contributor = _contributors[i];
            uint256 share = _shares[i];
            require(share > 0, "Shares must be greater than zero");
            require(!contributors[contributor].exists, "Contributor already exists");

            contributors[contributor] = Contributor(share, true);
            contributorAddresses.push(contributor);

            emit SharesAssigned(contributor, share);
        }
    }

    // Function to purchase the NFT, triggering payment distribution and ownership transfer event
    function buyNFT(uint256 tokenId) external payable {
        require(msg.value > 0, "Payment is required to buy NFT");

        // Distribute payment based on shares
        uint256 totalPayment = msg.value;
        
        for (uint256 i = 0; i < contributorAddresses.length; i++) {
            address contributor = contributorAddresses[i];
            uint256 contributorShare = (contributors[contributor].shares * totalPayment) / totalShares;
            (bool success, ) = contributor.call{value: contributorShare}("");
            require(success, "Payment to contributor failed");

            emit PaymentDistributed(contributor, contributorShare);
        }

        // Emit NFT purchase event for bridge to trigger ownership update on Lisk
        emit NFTPurchased(msg.sender, totalPayment, tokenId);
    }
}
