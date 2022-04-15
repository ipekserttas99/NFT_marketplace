// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable, ERC721{

    uint256[] private _allTokens;

    //mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;
    //mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;
    //mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    //function tokenByIndex(uint256 _index) external view returns (uint256);
    //function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
    
    constructor() {
        _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^
        keccak256('tokenByIndex(uint256)')^keccak256('tokenOfOwnerByIndex(address, uint)')));
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721){
        super._mint(to, tokenId);
        //2 things! A. add tokens to the owner
        //B. add tokens to our totalSupply - to allTokens
        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    //add tokens to the _alltokens array and set the position of the token indexes
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private{
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private{
        // 1. add address and token id to the _ownedTokens
        // 2. ownedTokensIndex tokenId set to address of ownedTokens position
        // we want to execute the function with minting
        _ownedTokens[to].push(tokenId);
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
    }

    function tokenByIndex(uint256 index) public view returns(uint256){
        //make sure that the index is not out of bounds of the total supply
        require(index < totalSupply(), 'Global index is out of bounds!');
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint index) public view returns(uint256){
        require(index < balanceOf(owner), 'owner index is out of bounds');
        return _ownedTokens[owner][index];
    }

    //return the total supply of the _allTokens array
    function totalSupply() public view returns(uint256){
        return _allTokens.length;
    }
}