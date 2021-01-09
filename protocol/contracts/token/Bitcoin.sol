pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/access/roles/MinterRole.sol";
import "./Permittable.sol";
import "./IBitcoin.sol";

contract Bitcoin is
    IBitcoin,
    MinterRole,
    ERC20Detailed,
    Permittable,
    ERC20Burnable
{
    constructor()
        public
        ERC20Detailed("Dynamic Set Bitcoin", "DSB", 18)
        Permittable()
    {}

    function mint(address account, uint256 amount)
        public
        onlyMinter
        returns (bool)
    {
        _mint(account, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        _transfer(sender, recipient, amount);
        if (allowance(sender, _msgSender()) != uint256(-1)) {
            _approve(
                sender,
                _msgSender(),
                allowance(sender, _msgSender()).sub(
                    amount,
                    "Bitcoin: transfer amount exceeds allowance"
                )
            );
        }
        return true;
    }
}
