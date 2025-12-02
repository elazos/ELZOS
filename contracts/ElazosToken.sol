// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ELAZOS (ELZOS) — простейший стандартный ERC20 без доп.логики
contract ElazosToken {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    string private _name = "ELAZOS";
    string private _symbol = "ELZOS";
    uint8 private constant _decimals = 18;

    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor() {
        uint256 initialSupply = 15_500_000 * (10 ** uint256(_decimals));
        _mint(msg.sender, initialSupply);
    }

    function name() public view returns (string memory) { return _name; }
    function symbol() public view returns (string memory) { return _symbol; }
    function decimals() public pure returns (uint8) { return _decimals; }
    function totalSupply() public view returns (uint256) { return _totalSupply; }
    function balanceOf(address account) public view returns (uint256) { return _balances[account]; }
    function allowance(address owner, address spender) public view returns (uint256) { return _allowances[owner][spender]; }

    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        require(currentAllowance >= value, "ELZOS: insufficient allowance");

        unchecked { _approve(from, msg.sender, currentAllowance - value); }
        _transfer(from, to, value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(from != address(0), "ELZOS: transfer from zero");
        require(to != address(0), "ELZOS: transfer to zero");

        uint256 fromBal = _balances[from];
        require(fromBal >= value, "ELZOS: balance too low");

        unchecked { _balances[from] = fromBal - value; }
        _balances[to] += value;

        emit Transfer(from, to, value);
    }

    function _mint(address to, uint256 value) internal {
        require(to != address(0), "ELZOS: mint to zero");
        _totalSupply += value;
        _balances[to] += value;
        emit Transfer(address(0), to, value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ELZOS: approve from zero");
        require(spender != address(0), "ELZOS: approve to zero");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }
}
