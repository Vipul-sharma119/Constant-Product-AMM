// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool);
}


contract AMM {
    IERC20 immutable tokenA;
    IERC20 immutable tokenB;


    uint reserveA;
    uint reserveB;


    uint totalLPShares;
    mapping (address => uint256) shares;


    constructor(address _tokenA, address _tokenB){
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }


    function _mint(uint _shares) internal {
         shares[msg.sender]=shares[msg.sender]+_shares;
         totalLPShares=totalLPShares + _shares;  
    }


    function _update(uint _newReserveA,uint _newReserveB) internal{
         reserveA= _newReserveA;
         reserveB=_newReserveB;
    }


    function add_liquidity(uint _amtA,uint _amtB) external{
        require(_amtA>0 && _amtB>0,"invalid amount");


        if(reserveA>0 || reserveB>0){
           require(reserveA*_amtB == reserveB*_amtA,"Invalid ratio");
        }
       
        tokenA.transferFrom(msg.sender, address(this), _amtA);
        tokenB.transferFrom(msg.sender, address(this), _amtB);


        uint shareQty;
        if (totalLPShares==0){
            shareQty = _sqrt(_amtA*_amtB);
        }else{
            shareQty = _min(
                (totalLPShares*_amtA)/reserveA,
                (totalLPShares*_amtB)/reserveB
                );
        }
         _mint(shareQty);


         _update(
            tokenA.balanceOf(address(this)),
            tokenB.balanceOf(address(this))
         );
      
    }


   function _burn(uint _shares) internal {
     shares[msg.sender] -= _shares;
     totalLPShares -= _shares;
   }


    function remove_liquidity(uint _shares) external {
      require(_shares > 0, "invalid share amount");
      require(shares[msg.sender] >= _shares, "not enough shares");
      
      uint amtA = (reserveA * _shares) / totalLPShares;
      uint amtB = (reserveB * _shares) / totalLPShares;
      _burn(_shares);
      _update(
        tokenA.balanceOf(address(this)) - amtA,
        tokenB.balanceOf(address(this)) - amtB
      );
     tokenA.transfer(msg.sender, amtA);
     tokenB.transfer(msg.sender, amtB);
    }


    function swap(address _token,uint _amt) external {
        require(_token==address(tokenA) || _token == address(tokenB),"invalid token");
         
        (IERC20 _tokenA,IERC20 _tokenB,uint _resA,uint _resB) = 
        _token==address(tokenA)?
        (tokenA,tokenB,reserveA,reserveB):
        (tokenB,tokenA,reserveB,reserveA);
        uint amtInWithFee = (_amt*997)/1000; //dx(1-fee) = dx(1-0.3%)=dx(1-3/1000)=dx(997/1000);
        uint _amtOut = (amtInWithFee*_resB)/(_resA+amtInWithFee);


        _tokenA.transferFrom(msg.sender, address(this), _amt);
        _tokenB.transfer(msg.sender, _amtOut);
         _update(
         _tokenA.balanceOf(address(this)),
         _tokenB.balanceOf(address(this)));
    }


    function _min(uint x,uint y) internal pure returns(uint){
        return x>y?y:x;
    }


    function _sqrt(uint256 y) private pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}
