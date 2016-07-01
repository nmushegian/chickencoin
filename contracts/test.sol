import 'dapple/test.sol';
import 'chickenshares.sol';

contract ChickenSharesTest is Test {
    ChickenShares chi;
    function setUp() {
        chi = new ChickenShares();
    }
    function testFailBeforeInitialized() {
        chi.purchase.value(1 ether)();
    }
    function testInitialization() {
        var ok = chi.call.value(1 ether)();
        chi.purchase.value(1 ether)();
    }
}
