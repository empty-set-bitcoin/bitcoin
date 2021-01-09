pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "../oracle/Pool.sol";

contract MockPool is Pool {
    address private _WBTC;

    constructor(
        address WBTC,
        address bitcoin,
        address univ2
    ) public Pool(bitcoin, univ2) {
        _WBTC = WBTC;
    }

    function set(address dao) external {
        _state.provider.dao = IDAO(dao);
    }

    function WBTC() public view returns (address) {
        return _WBTC;
    }

    function dao() public view returns (IDAO) {
        return _state.provider.dao;
    }

    function bitcoin() public view returns (IBitcoin) {
        return _state.provider.bitcoin;
    }

    function univ2() public view returns (IERC20) {
        return _state.provider.univ2;
    }

    function getReserves(address tokenA, address tokenB)
        internal
        view
        returns (uint256 reserveA, uint256 reserveB)
    {
        (reserveA, reserveB, ) = IUniswapV2Pair(address(univ2())).getReserves();
    }
}
