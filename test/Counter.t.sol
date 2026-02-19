// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {DeployDiamond} from "../script/Deploy.s.sol";

contract DiamondTest is Test {

    function setUp() public {
    }

    function test_dummy() pure public {
        assertEq(true, true);
    }
}
