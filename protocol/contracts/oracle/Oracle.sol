pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "../external/UniswapV2OracleLibrary.sol";
import "../external/UniswapV2Library.sol";
import "../external/Require.sol";
import "../external/Decimal.sol";
import "./IOracle.sol";
import "../Constants.sol";

contract Oracle is IOracle {
    using Decimal for Decimal.D256;

    bytes32 private constant FILE = "Oracle";
    address private constant UNISWAP_FACTORY =
        address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);

    address internal _dao;
    address internal _bitcoin;

    bool internal _initialized;
    IUniswapV2Pair internal _pair;
    uint256 internal _index;
    uint256 internal _cumulative;
    uint32 internal _timestamp;

    uint256 internal _reserve;

    constructor(address bitcoin) public {
        _dao = msg.sender;
        _bitcoin = bitcoin;
    }

    function setup() public onlyDao {
        _pair = IUniswapV2Pair(
            IUniswapV2Factory(UNISWAP_FACTORY).createPair(_bitcoin, WBTC())
        );

        (address token0, address token1) = (_pair.token0(), _pair.token1());
        _index = _bitcoin == token0 ? 0 : 1;

        Require.that(
            _index == 0 || _bitcoin == token1,
            FILE,
            "Bitcoin not found"
        );
    }

    /**
     * Trades/Liquidity: (1) Initializes reserve and blockTimestampLast (can calculate a price)
     *                   (2) Has non-zero cumulative prices
     *
     * Steps: (1) Captures a reference blockTimestampLast
     *        (2) First reported value
     */
    function capture() public onlyDao returns (Decimal.D256 memory, bool) {
        if (_initialized) {
            return updateOracle();
        } else {
            initializeOracle();
            return (Decimal.one(), false);
        }
    }

    function initializeOracle() private {
        IUniswapV2Pair pair = _pair;
        uint256 priceCumulative =
            _index == 0
                ? pair.price0CumulativeLast()
                : pair.price1CumulativeLast();
        (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) =
            pair.getReserves();
        if (reserve0 != 0 && reserve1 != 0 && blockTimestampLast != 0) {
            _cumulative = priceCumulative;
            _timestamp = blockTimestampLast;
            _initialized = true;
            _reserve = _index == 0 ? reserve1 : reserve0; // get counter's reserve
        }
    }

    function updateOracle() private returns (Decimal.D256 memory, bool) {
        Decimal.D256 memory price = updatePrice();
        uint256 lastReserve = updateReserve();

        bool valid = true;
        if (lastReserve < Constants.getOracleReserveMinimum()) {
            valid = false;
        }
        if (_reserve < Constants.getOracleReserveMinimum()) {
            valid = false;
        }

        return (price, valid);
    }

    function updatePrice() private returns (Decimal.D256 memory) {
        (
            uint256 price0Cumulative,
            uint256 price1Cumulative,
            uint32 blockTimestamp
        ) = UniswapV2OracleLibrary.currentCumulativePrices(address(_pair));
        uint32 timeElapsed = blockTimestamp - _timestamp; // overflow is desired
        uint256 priceCumulative =
            _index == 0 ? price0Cumulative : price1Cumulative;
        Decimal.D256 memory price =
            Decimal.ratio(
                (priceCumulative - _cumulative) / timeElapsed,
                2**112
            );

        _timestamp = blockTimestamp;
        _cumulative = priceCumulative;

        return price;
    }

    function updateReserve() private returns (uint256) {
        uint256 lastReserve = _reserve;
        (uint112 reserve0, uint112 reserve1, ) = _pair.getReserves();
        _reserve = _index == 0 ? reserve1 : reserve0; // get counter's reserve

        return lastReserve;
    }

    function WBTC() internal view returns (address) {
        return Constants.getWBTCAddress();
    }

    function pair() external view returns (address) {
        return address(_pair);
    }

    function reserve() external view returns (uint256) {
        return _reserve;
    }

    modifier onlyDao() {
        Require.that(msg.sender == _dao, FILE, "Not dao");

        _;
    }
}
