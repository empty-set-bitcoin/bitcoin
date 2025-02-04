pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "../dao/Comptroller.sol";
import "../token/Bitcoin.sol";
import "./MockState.sol";

contract MockComptroller is Comptroller, MockState {
    constructor(address pool) public {
        _state.provider.bitcoin = new Bitcoin();
        _state.provider.pool = pool;
    }

    function mintToAccountE(address account, uint256 amount) external {
        super.mintToAccount(account, amount);
    }

    function burnFromAccountE(address account, uint256 amount) external {
        super.burnFromAccount(account, amount);
    }

    function redeemToAccountE(address account, uint256 amount) external {
        super.redeemToAccount(account, amount);
    }

    function burnRedeemableE(uint256 amount) external {
        super.burnRedeemable(amount);
    }

    function increaseDebtE(uint256 amount) external {
        super.increaseDebt(amount);
    }

    function decreaseDebtE(uint256 amount) external {
        super.decreaseDebt(amount);
    }

    function resetDebtE(uint256 percent) external {
        super.resetDebt(Decimal.ratio(percent, 100));
    }

    /* For testing only */
    function mintToE(address account, uint256 amount) external {
        bitcoin().mint(account, amount);
    }
}
