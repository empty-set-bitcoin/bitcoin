pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";

contract TestnetWBTC is ERC20Detailed, ERC20Burnable {
    constructor() public ERC20Detailed("WBTC", "Wrapped Bitcoin", 18) {}

    function mint(address account, uint256 amount) external returns (bool) {
        _mint(account, amount);
        return true;
    }

    function isBlacklisted(address account) external view returns (bool) {
        return false;
    }
}
