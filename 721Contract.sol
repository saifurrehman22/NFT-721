// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0 ;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/docs-v3.x/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/docs-v3.x/contracts/utils/Counters.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Whitelist {

    bool private whitelistEnabled;

       constructor() public
       {
             whitelistEnabled = true;
        }
    mapping(address => bool) private whitelistMap;
    
    event AddToWhitelist(address indexed _newAddress);
    event RemoveFromWhitelist(address indexed _removedAddress);

    function enableWhitelist(bool _enabled) public  {
        whitelistEnabled = _enabled;
    }
    function addToWhitelist(address[] memory _newAddress) public  {
        for (uint256 i = 0; i < _newAddress.length; i++)
        {
            _whitelist(_newAddress[i]);
        
        emit AddToWhitelist(_newAddress[i]);
        }
    }
    function removeFromWhitelist(address _removedAddress) public  {
        _unWhitelist(_removedAddress);
        emit RemoveFromWhitelist(_removedAddress);
    }
    function isWhitelisted(address _address) public view returns (bool) {
        if (whitelistEnabled) {
            return whitelistMap[_address];
        } else {
            return true;
        }
    }
    function _unWhitelist(address _removedAddress) internal {
        whitelistMap[_removedAddress] = false;
    }
    function _whitelist(address _newAddress) internal {
    
        whitelistMap[_newAddress] = true;
    }
}
contract NFT is ERC721 , Whitelist {
    
    uint startTime;
    uint closeTime;
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    // enum state(1st day, next days)
    
        constructor () public  ERC721("NFT", "ITM") 
        {
            startTime = block.timestamp;
            closeTime = startTime + 2 minutes;
        }
     
    function mintToken(address _user, string memory tokenURI)
        public
        returns (uint256)
    { 
        require(isWhitelisted(_user) ," this addres is not white listed so can't mint "  );
        if(block.timestamp >= startTime && block.timestamp <=closeTime){
        require(balanceOf(msg.sender)<2,"You  can only min 2 tokens in 24 hours");
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(_user, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
        }
        if(block.timestamp >=closeTime)
        {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(_user, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
        }
    }
}
