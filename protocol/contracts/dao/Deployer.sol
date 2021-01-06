/*
    Sup
*/

pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "../external/Decimal.sol";
import "../token/Bitcoin.sol";
import "../oracle/Oracle.sol";
import "../oracle/Pool.sol";
import "./Upgradeable.sol";
import "./Permission.sol";

contract Deployer1 is State, Permission, Upgradeable {
    function initialize() public initializer {
        _state.provider.bitcoin = new Bitcoin();
    }

    function implement(address implementation) external {
        upgradeTo(implementation);
    }
}

contract Deployer2 is State, Permission, Upgradeable {
    function initialize() public initializer {
        _state.provider.oracle = new Oracle(address(bitcoin()));
        oracle().setup();
    }

    function implement(address implementation) external {
        upgradeTo(implementation);
    }
}

contract Deployer3 is State, Permission, Upgradeable {
    function initialize() public initializer {
        _state.provider.pool = address(
            new Pool(address(bitcoin()), address(oracle().pair()))
        );
    }

    function implement(address implementation) external {
        upgradeTo(implementation);
    }
}
