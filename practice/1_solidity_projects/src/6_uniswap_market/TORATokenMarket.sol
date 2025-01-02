// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IUniswapV2Router02} from "lib/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract TORATokenMarket {
    error TORATokenMarket__RouterAddressNotDefined();
    error TORATokenMarket__notOwner();

    address public s_routerAddress;
    address public immutable s_tokenAddress;
    address public immutable s_owner;

    constructor(address tokenAddress) {
        s_tokenAddress = tokenAddress;
        s_owner = msg.sender;
    }

    modifier m_onlyOwner {
        if (msg.sender != s_owner) {
            revert TORATokenMarket__notOwner();
        }
        _;
    }

    function changeRouter(address _newRouter) external m_onlyOwner{        
        s_routerAddress = _newRouter;
    }

    function addLiquidity(uint256 TTAmount, uint256 deadline)
        external
        payable
        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity)
    {
        if (s_routerAddress == address(0)) {
            revert TORATokenMarket__RouterAddressNotDefined();
        }
        // receive TT Token, need msg.sender approve the amount first.
        IERC20(s_tokenAddress).transferFrom(msg.sender, address(this), TTAmount);

        // approve TT Token amount and wth to pair Address.
        IERC20(s_tokenAddress).approve(s_routerAddress, TTAmount);
        // ETH transfer to pair address as is known that eth is not a erc20 standard token.
        // IERC20(s_tokenAddress).approve(s_routerAddress, TTAmount);

        address WETH = IUniswapV2Router02(s_routerAddress).WETH();
        address factory = IUniswapV2Router02(s_routerAddress).factory();
        (amountToken, amountETH, liquidity) = IUniswapV2Router02(s_routerAddress).addLiquidityETH{value: msg.value}(
            s_tokenAddress, TTAmount, TTAmount / 2, msg.value / 2, msg.sender, block.timestamp
        );
    }

    function buyToken(uint256 amountMin, uint256 deadline) external payable {
        address[] memory path = new address[](2);
        path[0] = IUniswapV2Router02(s_routerAddress).WETH();
        path[1] = s_tokenAddress;
        IUniswapV2Router02(s_routerAddress).swapExactETHForTokens{value: msg.value}(
            amountMin, path, msg.sender, block.timestamp
        );
    }
}
