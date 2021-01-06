pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";

contract TestnetSBTC is ERC20Detailed, ERC20Burnable {
    constructor() public ERC20Detailed("sBTC", "Synth sBTC", 18) {}

    function mint(address account, uint256 amount) external returns (bool) {
        _mint(account, amount);
        return true;
    }

    function isBlacklisted(address account) external view returns (bool) {
        return false;
    }
}
