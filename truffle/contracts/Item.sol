pragma solidity >=0.5.0 <=0.6.0;
import "./ItemManager.sol";
contract Item {
    uint public priceInWei;
    uint public index;
    ItemManager parentContract;
    uint public pricePaid;

    constructor(ItemManager _parentContract, uint _index, uint _priceInWei) public {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable {
        require(pricePaid == 0, "Item is paid arleady");
        require(priceInWei == msg.value, "Only full payments allowed");
        pricePaid += msg.value;
        (bool success, ) = address(parentContract).call.value(msg.value)(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "The transaction was not successful, cancelling!");
    }
}