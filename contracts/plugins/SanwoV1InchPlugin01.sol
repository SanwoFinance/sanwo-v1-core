// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "../interfaces/I1InchAggregratorRouter.sol";
import "./SanwoV1PaymentEvent01.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import  '../libraries/UNIERC20.sol';


contract OneInchPlugin{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;


  // Address representating ETH (e.g. in payment routing paths)
  address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  // MAXINT to be used only, to increase allowance from
  // payment protocol contract towards known 
  // decentralized exchanges, not to dyanmically called contracts!!!
  uint public immutable MAXINT = type(uint256).max;
  

  // Address of 1Inch aggregrator router.
  address public immutable AggregationRouterV3;

  // Indicates that this plugin requires delegate call
  bool public immutable delegate = true;

  // struct for swap details on 1Inch router 
      struct SwapDescription {
        IERC20 srcToken;
        IERC20 dstToken;
        address srcReceiver;
        address dstReceiver;
        uint256 amount;
        uint256 minReturnAmount;
        uint256 flags;
        bytes permit;
    } 

  address paymenteventplugin;

  // Pass WETH and the UniswapRouter when deploying this contract.
  constructor (
      address _paymenteventplugin,
    address _AggregationRouterV3
  ) public {
     AggregationRouterV3 = _AggregationRouterV3;
     paymenteventplugin = _paymenteventplugin;
  }


    // Swap tokenA<>tokenB, ETH<>tokenA or tokenA<>ETH on 1Inch as part of the payment.
     function execute(IAggregationExecutor caller,
        SwapDescription memory desc,
        bytes calldata data) public {

    // Make sure swapping the token within the payment protocol contract is approved on the Uniswap router.
    if( 
      desc.srcToken != IERC20(ETH) &&
      desc.srcToken.allowance(address(this), AggregationRouterV3) < desc.amount
    ) {
      desc.srcToken.safeApprove(AggregationRouterV3, MAXINT);
    }
     IAggregationRouterV3(AggregationRouterV3).swap(caller, IAggregationRouterV3.SwapDescription(desc.srcToken, desc.dstToken, desc.srcReceiver, desc.dstReceiver, desc.amount, desc.minReturnAmount, desc.flags, desc.permit), data);
     
     address[] memory path = new address[](2);
     path[0] = address(desc.srcToken);
     path[1] = address(desc.dstToken);

     address[] memory addresses = new address[](2);
     addresses[0] = desc.srcReceiver;
     addresses[1] = desc.dstReceiver;

    uint256[] memory amounts  = new uint256[](2);
    amounts[0] = desc.amount;
    amounts[1] = desc.minReturnAmount;


    SanwoRouterV1PaymentEvent01(paymenteventplugin).execute(path, amounts, addresses);
    }
}
