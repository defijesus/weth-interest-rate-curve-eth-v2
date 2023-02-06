// SPDX-License-Identifier: MIT

/*
   _      ΞΞΞΞ      _
  /_;-.__ / _\  _.-;_\
     `-._`'`_/'`.-'
         `\   /`
          |  /
         /-.(
         \_._\
          \ \`;
           > |/
          / //
          |//
          \(\
           ``
     defijesus.eth
*/

pragma solidity ^0.8.15;

import {AaveV2Ethereum} from "@aave-address-book/AaveV2Ethereum.sol";

/**
 * @title wETH Interest Rate Curve - Ethereum v2
 * @author Llama
 * @notice Upgrade wETH interest rate on Ethereum v2 to match Ethereum v3 Liquidity Pool.
 * Governance Forum Post: https://governance.aave.com/t/arfc-weth-wsteth-interest-rate-curve-ethereum-network/11372
 * Snapshot: https://snapshot.org/#/aave.eth/proposal/0x9ae28e9c82c5fc0d24cf1df788094e959d99f906d11b89e455a60ee16b071d6f
 */
contract ProposalPayload {
    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant NEW_INTEREST_RATE_STRATEGY = 0x04dC7E231Fe1355a461588D75F32c218dFaE9d2c;

    /// @notice The AAVE governance executor calls this function to implement the proposal.
    function execute() external {
        AaveV2Ethereum.POOL_CONFIGURATOR.setReserveInterestRateStrategyAddress(WETH, NEW_INTEREST_RATE_STRATEGY);
    }
}
