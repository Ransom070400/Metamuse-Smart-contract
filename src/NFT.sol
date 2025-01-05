// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SecureNFTMinter is ERC721 {
    uint256 public currentTokenId;
    mapping(uint256 => string) private _tokenURIs;
    address public bridgeAddress; // Address of the bridge contract on Lisk
    
    modifier onlyOwner(){
        require(bridgeAddress == address(this), "must be the contract");
        _;
    }

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        bridgeAddress = address(this);
    }

    // Function to mint an NFT, accessible to anyone
    function mintNFT(address to, string memory newTokenURI) external returns (uint256) {
        uint256 tokenId = ++currentTokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, newTokenURI); // Set the CID as the token URI
        return tokenId;
    }

    // Internal function to set the token URI (CID)
    function _setTokenURI(uint256 tokenId, string memory newTokenURI) internal {
        _tokenURIs[tokenId] = newTokenURI;
    }

    // Override tokenURI function to return the IPFS URI
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked("ipfs://", _tokenURIs[tokenId]));
    }

    // Function to set the bridge address (only the contract owner can do this)
    function setBridgeAddress(address _bridgeAddress) external onlyOwner {
        bridgeAddress = _bridgeAddress;
    }

    // Function to transfer ownership of an NFT, restricted to the bridge contract
    function transferNFT(uint256 tokenId, address newOwner) external {
        require(msg.sender == bridgeAddress, "Only the bridge can transfer ownership");
        // require(_exists(tokenId), "Token does not exist");

        address currentOwner = ownerOf(tokenId);
        _transfer(currentOwner, newOwner, tokenId); // Transfer ownership to the new owner
    }
}
