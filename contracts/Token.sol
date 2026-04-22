pragma solidity 0.7.0;

import "./IERC20.sol";
import "./IMintableToken.sol";
import "./IDividends.sol";
import "./SafeMath.sol";

contract Token is IERC20, IMintableToken, IDividends {
  // ------------------------------------------ //
  // ----- BEGIN: DO NOT EDIT THIS SECTION ---- //
  // ------------------------------------------ //
  using SafeMath for uint256;
  uint256 public totalSupply;
  uint256 public decimals = 18;
  string public name = "Test token";
  string public symbol = "TEST";
  mapping (address => uint256) public balanceOf;
  // ------------------------------------------ //
  // ----- END: DO NOT EDIT THIS SECTION ------ //  
  // ------------------------------------------ //

   // Additional state variables
  mapping(address => mapping(address => uint256)) private _allowances;
  
  // Token holder tracking
  address[] private _holders;
  mapping(address => uint256) private _holderIndex; 
  
  // Dividend tracking
  mapping(address => uint256) private _withdrawableDividends;

   // Helper function to add a holder if not already in the list
  function _addHolder(address holder) private {
    if (_holderIndex[holder] == 0) {
      _holders.push(holder);
      _holderIndex[holder] = _holders.length;
    }
  }
  // IERC20

  function allowance(address owner, address spender) external view override returns (uint256) {
    revert();
  }

  function transfer(address to, uint256 value) external override returns (bool) {
    revert();
  }

  function approve(address spender, uint256 value) external override returns (bool) {
    revert();
  }

  function transferFrom(address from, address to, uint256 value) external override returns (bool) {
    revert();
  }

  // IMintableToken

  function mint() external payable override {
    revert();
  }

  function burn(address payable dest) external override {
    revert();
  }

  // IDividends

  function getNumTokenHolders() external view override returns (uint256) {
    return _holders.length;
  }

  function getTokenHolder(uint256 index) external view override returns (address) {
    require(index >= 1 && index <= _holders.length, "Index out of bounds");
    return _holders[index - 1];
  }

  function recordDividend() external payable override {
     require(msg.value > 0, "Dividend must be greater than 0");
    require(totalSupply > 0, "No token holders");
    
    for (uint256 i = 0; i < _holders.length; i++) {
      address holder = _holders[i];
      uint256 proportion = (balanceOf[holder] * msg.value) / totalSupply;
      _withdrawableDividends[holder] = _withdrawableDividends[holder].add(proportion);
    }
  }

  function getWithdrawableDividend(address payee) external view override returns (uint256) {
    return _withdrawableDividends[payee];
  }

  function withdrawDividend(address payable dest) external override {
     uint256 dividend = _withdrawableDividends[msg.sender];
    require(dividend > 0, "No dividends to withdraw");
    
    _withdrawableDividends[msg.sender] = 0;
    dest.transfer(dividend);
  }
}