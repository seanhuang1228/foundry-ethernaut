// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/DoubleEntryPoint.sol";
import "src/levels/DoubleEntryPointFactory.sol";

contract TestDoubleEntryPoint is BaseTest {
    DoubleEntryPoint private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new DoubleEntryPointFactory();
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

        levelAddress = payable(this.createLevelInstance{value: 0.001 ether}(true));
        level = DoubleEntryPoint(levelAddress);

        // Check that the contract is correctly setup
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);


        vm.stopPrank();
    }
}

contract DetectionBot is IDetectionBot {
    address private monitoredSource;
    bytes private monitoredSig;

    constructor(address _monitoredSource, bytes memory _monitoredSig) public {
        monitoredSource = _monitoredSource;
        monitoredSig = _monitoredSig;
    }

    function handleTransaction(address user, bytes calldata msgData) external override {
        (address to, uint256 value, address origSender) = abi.decode(msgData[4:], (address, uint256, address));

        bytes memory callSig = abi.encodePacked(msgData[0], msgData[1], msgData[2], msgData[3]);

        if (origSender == monitoredSource && keccak256(callSig) == keccak256(monitoredSig)) {
            IForta(msg.sender).raiseAlert(user);
        }
    }
}
