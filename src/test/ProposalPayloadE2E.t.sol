// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

// testing libraries
import "@forge-std/Test.sol";

// contract dependencies
import {GovHelpers} from "@aave-helpers/GovHelpers.sol";
import {AaveV2Ethereum} from "@aave-address-book/AaveV2Ethereum.sol";
import {ProposalPayload} from "../ProposalPayload.sol";
import {DeployMainnetProposal} from "../../script/DeployMainnetProposal.s.sol";
import {AaveV2Helpers, ReserveConfig} from "./utils/AaveV2Helpers.sol";

contract ProposalPayloadE2ETest is Test {
    uint256 public proposalId;
    string public constant WETH_SYMBOL = "WETH";
    address public constant NEW_INTEREST_RATE_STRATEGY = 0x04dC7E231Fe1355a461588D75F32c218dFaE9d2c;

    function setUp() public {
        // To fork at a specific block: vm.createSelectFork(vm.rpcUrl("mainnet"), BLOCK_NUMBER);
        vm.createSelectFork(vm.rpcUrl("mainnet"));

        // Deploy Payload
        ProposalPayload proposalPayload = new ProposalPayload();

        // Create Proposal
        vm.prank(GovHelpers.AAVE_WHALE);
        proposalId = DeployMainnetProposal._deployMainnetProposal(
            address(proposalPayload),
            0x344d3181f08b3186228b93bac0005a3a961238164b8b06cbb5f0428a9180b8a7 // TODO: Replace with actual IPFS Hash
        );
    }

    function testExecute() public {
        // Pre-execution assertations
        ReserveConfig[] memory allConfigsBefore = AaveV2Helpers._getReservesConfigs(false);

        ReserveConfig memory configWethBefore = AaveV2Helpers._findReserveConfig(allConfigsBefore, WETH_SYMBOL, false);

        // Pass vote and execute proposal
        GovHelpers.passVoteAndExecute(vm, proposalId);

        // Post-execution assertations
        ReserveConfig[] memory allConfigsAfter = AaveV2Helpers._getReservesConfigs(false);

        configWethBefore.interestRateStrategy = NEW_INTEREST_RATE_STRATEGY;

        AaveV2Helpers._validateReserveConfig(configWethBefore, allConfigsAfter);

        assertEq(AaveV2Ethereum.POOL.getReserveData(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).interestRateStrategyAddress, NEW_INTEREST_RATE_STRATEGY);
    }
}
