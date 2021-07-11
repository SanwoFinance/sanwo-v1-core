// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/I1InchAggregratorRouter.sol";



contract OneInchPlugin{

  // Address representating ETH (e.g. in payment routing paths)
  address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  // MAXINT to be used only, to increase allowance from
  // payment protocol contract towards known 
  // decentralized exchanges, not to dyanmically called contracts!!!
  uint public immutable MAXINT = type(uint256).max;
  
  // Address of WETH.
  address public immutable WETH;

  // Address of 1Inch aggregrator router.
  address public immutable AggregationRouterV3;

  // Indicates that this plugin requires delegate call
  bool public immutable delegate = true;

    event SanwoSwap(
        address sender,
        IERC20 srcToken,
        IERC20 dstToken,
        address dstReceiver,
        uint256 spentAmount,
        uint256 returnAmount
    );


  // Pass WETH and the UniswapRouter when deploying this contract.
  constructor (
    address _WETH,
    address _AggregationRouterV3
  ) public {
    WETH = _WETH;
     AggregationRouterV3 = _AggregationRouterV3;
  }


    // Swap tokenA<>tokenB, ETH<>tokenA or tokenA<>ETH on 1Inch as part of the payment.
     function execute(IAggregationExecutor caller,
        SwapDescription calldata desc,
        bytes calldata data){

    // Make sure swapping the token within the payment protocol contract is approved on the Uniswap router.
    if( 
      desc.srcToken != ETH &&
      IERC20(desc.srcToken).allowance(address(this), AggregationRouterV3) < desc.amount
    ) {
      IERC20(desc.srcToken).safeApprove(desc.srcToken, AggregationRouterV3, MAXINT);
    }

     IAggregationRouterV3(AggregationRouterV3).swap(caller, desc, data);
     emit SanwoSwap(
            msg.sender,
            desc.srcToken,
            desc.dstToken,
            desc.dstReceiver,
            desc.spentAmount,
            desc.returnAmount
        );
    }
}
