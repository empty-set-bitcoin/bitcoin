pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract IBitcoin is IERC20 {
    function burn(uint256 amount) public;

    function burnFrom(address account, uint256 amount) public;

    function mint(address account, uint256 amount) public returns (bool);
}
