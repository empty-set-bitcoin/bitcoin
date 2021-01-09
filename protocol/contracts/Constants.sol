pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "./external/Decimal.sol";

library Constants {
    /* Chain */
    uint256 private constant CHAIN_ID = 1; // Mainnet

    /* Bootstrapping */
    // uint256 private constant BOOTSTRAPPING_PERIOD = 56; // 14 days
    uint256 private constant BOOTSTRAPPING_PERIOD = 168; // 14 days
    uint256 private constant BOOTSTRAPPING_PRICE = 11e17; // ESB price == 1.10 * sBTC

    /* Oracle */
    address private constant sBTC =
        address(0x60b3BFebD319767a1DB45DFA3cE37124CED61568); // for ropsten
    // address(0xfE18be6b3Bd88A2D2A7f928d00292E7a9963CfC6);
    uint256 private constant ORACLE_RESERVE_MINIMUM = 1e18;

    /* Bonding */
    uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 ESB -> 100M ESBS

    /* Epoch */
    struct EpochStrategy {
        uint256 offset;
        uint256 start;
        uint256 period;
    }

    // uint256 private constant EPOCH_START = 1610323200; // 1/10/2021, 7:00:00 PM Standard Time)
    uint256 private constant EPOCH_START = 1609027200;
    uint256 private constant EPOCH_OFFSET = 0;
    // uint256 private constant EPOCH_PERIOD = 21600; // 6 hours
    uint256 private constant EPOCH_PERIOD = 7200; // 2 hours

    /* Governance */
    // uint256 private constant GOVERNANCE_PERIOD = 9; // 9 epochs
    uint256 private constant GOVERNANCE_PERIOD = 27; // 9 * 3 epochs since epoch period is reduced
    // uint256 private constant GOVERNANCE_EXPIRATION = 2; // 2 + 1 epochs
    uint256 private constant GOVERNANCE_EXPIRATION = 7; // 2 * 3 + 1 epochs
    uint256 private constant GOVERNANCE_QUORUM = 20e16; // 20%
    uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 5e15; // 0.5%
    uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
    // uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 6; // 6 epochs
    uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 18; // 18 epochs (36 hours; same as ESG)

    /* DAO */
    // uint256 private constant ADVANCE_INCENTIVE = 1e17; // 0.1 ESB
    uint256 private constant ADVANCE_INCENTIVE = 1e15; // 0.001 ESB // not making this too crazy
    uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 20; // 5 days

    /* Pool */
    uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 8; // 2 days

    /* Market */
    // uint256 private constant COUPON_EXPIRATION = 120; // 30 days
    uint256 private constant COUPON_EXPIRATION = 360; // 30 days
    // uint256 private constant DEBT_RATIO_CAP = 35e16; // 35%
    uint256 private constant DEBT_RATIO_CAP = 25e16; // 25%; inspired by DSD DIP-8

    /* Regulator */
    uint256 private constant SUPPLY_CHANGE_LIMIT = 5e16; // 5%
    // uint256 private constant SUPPLY_CHANGE_LIMIT = 1e17; // 10%
    uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 3e16; // 3% since we are expanding less too
    // uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 6e16; // 6%
    uint256 private constant ORACLE_POOL_RATIO = 20; // 20%
    uint256 private constant TREASURY_RATIO = 250; // 2.5%, until TREASURY_ADDRESS is set, this portion is sent to LP

    // TODO: vote on recipient
    address private constant TREASURY_ADDRESS =
        address(0x0000000000000000000000000000000000000000);

    function getSBTCAddress() internal pure returns (address) {
        return sBTC;
    }

    function getOracleReserveMinimum() internal pure returns (uint256) {
        return ORACLE_RESERVE_MINIMUM;
    }

    function getCurrentEpochStrategy()
        internal
        pure
        returns (EpochStrategy memory)
    {
        return
            EpochStrategy({
                offset: EPOCH_OFFSET,
                start: EPOCH_START,
                period: EPOCH_PERIOD
            });
    }

    function getInitialStakeMultiple() internal pure returns (uint256) {
        return INITIAL_STAKE_MULTIPLE;
    }

    function getBootstrappingPeriod() internal pure returns (uint256) {
        return BOOTSTRAPPING_PERIOD;
    }

    function getBootstrappingPrice()
        internal
        pure
        returns (Decimal.D256 memory)
    {
        return Decimal.D256({value: BOOTSTRAPPING_PRICE});
    }

    function getGovernancePeriod() internal pure returns (uint256) {
        return GOVERNANCE_PERIOD;
    }

    function getGovernanceExpiration() internal pure returns (uint256) {
        return GOVERNANCE_EXPIRATION;
    }

    function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
        return Decimal.D256({value: GOVERNANCE_QUORUM});
    }

    function getGovernanceProposalThreshold()
        internal
        pure
        returns (Decimal.D256 memory)
    {
        return Decimal.D256({value: GOVERNANCE_PROPOSAL_THRESHOLD});
    }

    function getGovernanceSuperMajority()
        internal
        pure
        returns (Decimal.D256 memory)
    {
        return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
    }

    function getGovernanceEmergencyDelay() internal pure returns (uint256) {
        return GOVERNANCE_EMERGENCY_DELAY;
    }

    function getAdvanceIncentive() internal pure returns (uint256) {
        return ADVANCE_INCENTIVE;
    }

    function getDAOExitLockupEpochs() internal pure returns (uint256) {
        return DAO_EXIT_LOCKUP_EPOCHS;
    }

    function getPoolExitLockupEpochs() internal pure returns (uint256) {
        return POOL_EXIT_LOCKUP_EPOCHS;
    }

    function getCouponExpiration() internal pure returns (uint256) {
        return COUPON_EXPIRATION;
    }

    function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
        return Decimal.D256({value: DEBT_RATIO_CAP});
    }

    function getSupplyChangeLimit()
        internal
        pure
        returns (Decimal.D256 memory)
    {
        return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
    }

    function getCouponSupplyChangeLimit()
        internal
        pure
        returns (Decimal.D256 memory)
    {
        return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
    }

    function getOraclePoolRatio() internal pure returns (uint256) {
        return ORACLE_POOL_RATIO;
    }

    function getTreasuryRatio() internal pure returns (uint256) {
        return TREASURY_RATIO;
    }

    function getChainId() internal pure returns (uint256) {
        return CHAIN_ID;
    }

    function getTreasuryAddress() internal pure returns (address) {
        return TREASURY_ADDRESS;
    }
}
