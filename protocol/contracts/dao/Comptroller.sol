pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./Setters.sol";
import "../external/Require.sol";

contract Comptroller is Setters {
    using SafeMath for uint256;

    bytes32 private constant FILE = "Comptroller";

    function mintToAccount(address account, uint256 amount) internal {
        bitcoin().mint(account, amount);
        if (!bootstrappingAt(epoch())) {
            increaseDebt(amount);
        }

        balanceCheck();
    }

    function burnFromAccount(address account, uint256 amount) internal {
        bitcoin().transferFrom(account, address(this), amount);
        bitcoin().burn(amount);
        decrementTotalDebt(amount, "Comptroller: not enough outstanding debt");

        balanceCheck();
    }

    function redeemToAccount(address account, uint256 amount) internal {
        bitcoin().transfer(account, amount);
        decrementTotalRedeemable(
            amount,
            "Comptroller: not enough redeemable balance"
        );

        balanceCheck();
    }

    function burnRedeemable(uint256 amount) internal {
        bitcoin().burn(amount);
        decrementTotalRedeemable(
            amount,
            "Comptroller: not enough redeemable balance"
        );

        balanceCheck();
    }

    function increaseDebt(uint256 amount) internal returns (uint256) {
        incrementTotalDebt(amount);
        uint256 lessDebt = resetDebt(Constants.getDebtRatioCap());

        balanceCheck();

        return lessDebt > amount ? 0 : amount.sub(lessDebt);
    }

    function decreaseDebt(uint256 amount) internal {
        decrementTotalDebt(amount, "Comptroller: not enough debt");

        balanceCheck();
    }

    function increaseSupply(uint256 newSupply)
        internal
        returns (uint256, uint256)
    {
        uint256 rewards;

        if (
            Constants.getTreasuryAddress() ==
            address(0x0000000000000000000000000000000000000000)
        ) {
            // Pay out to Pool, with treasury reward in addition
            uint256 poolAllocation =
                newSupply.mul(Constants.getOraclePoolRatio()).div(100);
            uint256 treasuryAllocation =
                newSupply.mul(Constants.getTreasuryRatio()).div(10000);
            rewards = poolAllocation.add(treasuryAllocation);
            mintToPool(rewards);
        } else {
            // 0-a. Pay out to Pool
            uint256 poolReward =
                newSupply.mul(Constants.getOraclePoolRatio()).div(100);
            mintToPool(poolReward);

            // 0-b. Pay out to Treasury
            uint256 treasuryReward =
                newSupply.mul(Constants.getTreasuryRatio()).div(10000);
            mintToTreasury(treasuryReward);

            rewards = poolReward.add(treasuryReward);
        }

        newSupply = newSupply > rewards ? newSupply.sub(rewards) : 0;

        // 1. True up redeemable pool
        uint256 newRedeemable = 0;
        uint256 totalRedeemable = totalRedeemable();
        uint256 totalCoupons = totalCoupons();
        if (totalRedeemable < totalCoupons) {
            newRedeemable = totalCoupons.sub(totalRedeemable);
            newRedeemable = newRedeemable > newSupply
                ? newSupply
                : newRedeemable;
            mintToRedeemable(newRedeemable);
            newSupply = newSupply.sub(newRedeemable);
        }

        // 2. Payout to DAO
        if (totalBonded() == 0) {
            newSupply = 0;
        }
        if (newSupply > 0) {
            mintToDAO(newSupply);
        }

        balanceCheck();

        return (newRedeemable, newSupply.add(rewards));
    }

    function resetDebt(Decimal.D256 memory targetDebtRatio)
        internal
        returns (uint256)
    {
        uint256 targetDebt =
            targetDebtRatio.mul(bitcoin().totalSupply()).asUint256();
        uint256 currentDebt = totalDebt();

        if (currentDebt > targetDebt) {
            uint256 lessDebt = currentDebt.sub(targetDebt);
            decreaseDebt(lessDebt);

            return lessDebt;
        }

        return 0;
    }

    function balanceCheck() private {
        Require.that(
            bitcoin().balanceOf(address(this)) >=
                totalBonded().add(totalStaged()).add(totalRedeemable()),
            FILE,
            "Inconsistent balances"
        );
    }

    function mintToDAO(uint256 amount) private {
        if (amount > 0) {
            bitcoin().mint(address(this), amount);
            incrementTotalBonded(amount);
        }
    }

    function mintToPool(uint256 amount) private {
        if (amount > 0) {
            bitcoin().mint(pool(), amount);
        }
    }

    function mintToTreasury(uint256 amount) private {
        if (amount > 0) {
            bitcoin().mint(Constants.getTreasuryAddress(), amount);
        }
    }

    function mintToRedeemable(uint256 amount) private {
        bitcoin().mint(address(this), amount);
        incrementTotalRedeemable(amount);

        balanceCheck();
    }
}
