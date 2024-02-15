// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract ERC20 {
    address public owner;
    string public name;
    string public symbol;
    uint public decimals;
    uint public totalSupply;
    mapping(address => uint) balanceOfAddr;
    mapping(address => mapping(address => uint)) public allowance;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Balance(uint indexed _balance);

    constructor(address _owner, string memory _name, string memory _symbol, uint _decimals, uint _initialSupply) {
        owner = _owner;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOfAddr[owner] += totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        require(_owner != address(0), "Caller Error");

        return balanceOfAddr[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "Zero address should not spend");
        require(msg.sender == owner, "Only owner can call the function");
        require(balanceOfAddr[owner] >= _value, "Insufficient Funds");
        require(_value > 0, "Please pass in a value greater than 0");

        allowance[msg.sender][_spender] = _value;

        emit Approval(owner, _spender, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "You can't send to zero address");
        require(_value > 0, "Invalid amount to be sent");
        require(balanceOfAddr[msg.sender] >= _value, "Insufficient Balance");

        balanceOfAddr[msg.sender] -= _value;
        uint256 _burnAmount = _value / 10;
        totalSupply -= _burnAmount;
        emit Transfer(owner, address(0), _value);
        balanceOfAddr[_to] += _value;
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "You can't send to zero address");
        require(_from != address(0), "You can't send from zero address");
        require(_value > 0, "Invalid amount to be sent");
        require(allowance[owner][msg.sender] >= _value || balanceOfAddr[owner] >= _value, "Insufficient Balance");

        allowance[owner][msg.sender] -= _value;
        balanceOfAddr[owner] -= _value;
        uint256 _burnAmount = _value / 10;
        emit Balance(totalSupply);
        totalSupply -= _burnAmount;
        emit Transfer(msg.sender, address(0), _burnAmount);
        emit Balance(totalSupply);
        balanceOfAddr[_to] += _value;
        emit Transfer(msg.sender, _to, _value);

        return true;
    }
}