// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/*


██████╗░███████╗███╗░░██╗████████╗░░░██████╗░███████╗███████╗██╗
██╔══██╗██╔════╝████╗░██║╚══██╔══╝░░░██╔══██╗██╔════╝██╔════╝██║
██████╔╝█████╗░░██╔██╗██║░░░██║░░░░░░██║░░██║█████╗░░█████╗░░██║
██╔══██╗██╔══╝░░██║╚████║░░░██║░░░░░░██║░░██║██╔══╝░░██╔══╝░░██║
██║░░██║███████╗██║░╚███║░░░██║░░░██╗██████╔╝███████╗██║░░░░░██║
╚═╝░░╚═╝╚══════╝╚═╝░░╚══╝░░░╚═╝░░░╚═╝╚═════╝░╚══════╝╚═╝░░░░░╚═╝

The Rent Control Protocol is a revolutionary philanthropic endeavor
that aims to provide affordable housing to users across the globe.

Learn More @ https://rent.defi

*/

contract TaxOracle is Ownable {
    using SafeMath for uint256;

    IERC20 public rent;
    IERC20 public wftm;
    address public pair;

    constructor(
        address _rent,
        address _wftm,
        address _pair
    ) public {
        require(_rent != address(0), "rent address cannot be 0");
        require(_wftm != address(0), "wftm address cannot be 0");
        require(_pair != address(0), "pair address cannot be 0");
        rent = IERC20(_rent);
        wftm = IERC20(_wftm);
        pair = _pair;
    }

    function consult(address _token, uint256 _amountIn) external view returns (uint144 amountOut) {
        require(_token == address(rent), "token needs to be rent");
        uint256 rentBalance = rent.balanceOf(pair);
        uint256 wftmBalance = wftm.balanceOf(pair);
        return uint144(rentBalance.mul(_amountIn).div(wftmBalance));
    }

    function getRentBalance() external view returns (uint256) {
	    return rent.balanceOf(pair);
    }

    function getWftmBalance() external view returns (uint256) {
	    return wftm.balanceOf(pair);
    }

    function getPrice() external view returns (uint256) {
        uint256 rentBalance = rent.balanceOf(pair);
        uint256 wftmBalance = wftm.balanceOf(pair);
        return rentBalance.mul(1e18).div(wftmBalance);
    }

    function setRent(address _rent) external onlyOwner returns (bool) {
        require(_rent != address(0), "rent address cannot be 0");
        rent = IERC20(_rent);
        return true;
    }

    function setWftm(address _wftm) external onlyOwner returns (bool) {
        require(_wftm != address(0), "wftm address cannot be 0");
        wftm = IERC20(_wftm);
        return true;
    }

    function setPair(address _pair) external onlyOwner returns (bool) {
        require(_pair != address(0), "pair address cannot be 0");
        pair = _pair;
        return true;
    }
}
