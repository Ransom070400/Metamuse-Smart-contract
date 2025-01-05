# MetaMuse

## Overview
The **MetaMuse** is a decentralized application that allows artists to collaboratively create digital artwork in real-time, mint it as a non-fungible token (NFT) on Lisk, and distribute fractional ownership using Arbitrum. This platform ensures transparent royalty distribution and shared ownership, empowering artists to collaborate creatively and securely.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Smart Contract Fractional Ownership overview](#smart-contract-development)
- [Setup and Installation](#setup-and-installation)
- [Usage](#usage)
- [Testing](#testing)
- [Project Structure](#project-structure)
- [License](#license)

## Features
- **Real-time Collaborative Canvas**: Multiple artists can create and edit artwork in real-time.
- **NFT Minting on Lisk**: The completed artwork is minted as an NFT on the Lisk blockchain.
- **Fractional Ownership on Arbitrum**: Ownership shares and royalties are distributed among collaborators via Arbitrum smart contracts.
- **Decentralized Storage**: Artwork and metadata are stored on IPFS for decentralized, secure storage.

## Tech Stack
- **Blockchain**: Lisk, Arbitrum
- **Smart Contracts**: Solidity, Forge
- **Backend**: Lisk SDK, IPFS (Pinata or Infura)

## Getting Started

## Smart Contract Fractional Ownership overview
Smart contracts in this project handle:

Fractional Ownership: Distributing shares among contributors.
Royalty Distribution: Automatically redistributing royalties to collaborators on resale.
Smart contracts are located in the contracts/ directory. Forge scripts for testing and deployment can be added in script/.

### Prerequisites
Make sure you have the following installed:
- [Node.js](https://nodejs.org/) and npm
- [Lisk SDK](https://lisk.io/)
- [Arbitrum Development Environment](https://developer.offchainlabs.com/)
- [IPFS CLI](https://docs.ipfs.io/install/)
- [Foundry & Forge](https://book.getfoundry.sh/)


### Key Features

- **Contributor Shares Assignment**: The owner can assign shares to multiple contributors.
- **NFT Purchase**: The contract allows anyone to buy the NFT by paying to the contract.
- **Automatic Payment Distribution**: Upon purchase, the payment is distributed to all contributors based on their shares.
- **Events**: Emits events for tracking NFT purchases and payments made to contributors.

### Events

- `NFTPurchased(address indexed buyer, uint256 totalPaid, uint256 tokenId)`: Emitted when an NFT is purchased.
- `SharesAssigned(address indexed contributor, uint256 shares)`: Emitted when shares are assigned to a contributor.
- `PaymentDistributed(address indexed contributor, uint256 amount)`: Emitted when payments are distributed to contributors.

### Functions

- `assignShares(address[] memory _contributors, uint256[] memory _shares)`: Allows the owner to assign shares to contributors.
- `buyNFT(uint256 tokenId)`: Allows users to buy the NFT and triggers payment distribution to contributors.

## Setup and Installation
 **Clone the Repository**:
   ```bash
   git clone git@github.com:georgegoldman/metamuse.git
   cd metamuse

### Installation
   ```
**Install Foundry: If you haven’t installed Foundry, you can do so with the following commands:**
```
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

**Install Dependencies: Run the following command to install dependencies (if any):**
```
forge install
```


Install dependencies:
```
npm install
```

## Usage

1. **Compile the Contract:**
```
forge build
```
2. **Deploy the Contract: To deploy the contract locally using Foundry:**
```
forge create metamuse --private-key <YOUR_PRIVATE_KEY>
```
3. **Deploy on Lisk testnet for the NFT minting and NFT ownership**
```
forge create --rpc-url https://rpc.sepolia-api.lisk.com --etherscan-api-key <etherscan-api-key> --verify --verifier blockscout --verifier-url https://sepolia-blockscout.lisk.com/api --private-key <private-key> src/NFT.sol:SecureNFTMinter --constructor-args "Lisk" "LSK" "https://baseuri.com/"
```
4. **Deploy on Arbitrum testnet for the Fractional ownership part**
```
forge create CollaborativeNFTOwnership --contracts ./src/FractionalNFT.t.sol --private-key <private> --rpc-url https://sepolia-rollup-sequencer.arbitrum.io/rpc
```

5. **Interacting with the Contract:**
- Assign Shares: Use the assignShares function to add contributors and their ownership shares.
- Buy NFT: Call buyNFT with the NFT’s token ID to simulate a purchase and trigger the payment distribution.

## Example
Here’s an example of how you might call the functions in a test or a deployment script:
```
CollaborativeNFTOwnership contractInstance = CollaborativeNFTOwnership(<deployed_address>);
contractInstance.assignShares([address1, address2], [50, 50]);
contractInstance.buyNFT(tokenId, {value: amount});
```

## Testing
To run tests with Foundry:
1. Write Tests: Tests are located in the ```test/``` folder. You can add tests as ```.sol``` files.
2. Run Tests:
```
forge test
```
3. View Coverage: For checking test coverage:
```
forge coverage
```

-Set up IPFS:

Use Pinata or Infura for IPFS API keys to store artwork and metadata.
### Running the Application
Start the local development server:

```
npm start
```
**Launch Lisk and Arbitrum nodes:**

Follow setup instructions for Lisk SDK and Arbitrum.
Deploy the Arbitrum smart contracts with Forge:

Ensure Forge is installed and set up by following the Foundry book.

**Deploy contracts from the contracts folder:**
```
forge create --rpc-url <ARBITRUM_RPC_URL> --private-key <YOUR_PRIVATE_KEY> src/YourContract.sol:YourContract
```

### Project Structure
```
.
├── foundry.toml
├── README.md
├── script
├── src
│   ├── FractionalNFT.sol
│   └── NFT.sol
└── test
    ├── FractionalNFT.t.sol
    └── NFT.t.sol

4 directories, 6 files

```
### License
This project is licensed under the MIT License - see the LICENSE file for details.


