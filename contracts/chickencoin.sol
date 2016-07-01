import 'erc20/base.sol';

contract ChickenCoin is ERC20Base(0) {
    uint constant UNIT = 10**18;

    // The fallback function also initializes the contract the
    // first time it is called with 1 ETH.
    // This is because solidity doesn't yet let you build a contract
    // with a default ether value (have a positive msg.value in the constructor).
    // After initialization, the fallback acts just like `purchase`: this contract's
    // self-owned chickencoin can never be withdrawn.
    function() {
        if( _supply == 0 ) {
            if( msg.value != UNIT ) throw;
            _balances[this] = UNIT;
            _supply = UNIT;
        } else {
            purchase();
        }
    }

    function purchase() {
        var ratio = UNIT * msg.value / (this.balance - msg.value);
        var coins = ratio * _supply / UNIT;
        var fee = coins / 200; // 0.5%
        var granted_coins = coins - fee;
        _balances[msg.sender] += granted_coins;
        _supply += granted_coins;
    }
    function redeem(uint quantity) {
        if( _balances[msg.sender] < quantity )
            throw;
        var ratio = UNIT * quantity / _supply;
        var eth = ratio * this.balance / UNIT;
        var fee = eth / 200; // 0.5%
        var granted_eth = eth - fee;
        _balances[msg.sender] -= granted_eth;
        _supply -= granted_eth;
        if( !msg.sender.call.value(granted_eth)() ) {
            throw;
        }
    }
}
