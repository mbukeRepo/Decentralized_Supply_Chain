pragma solidity >=0.5.0 <=0.6.0;

import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable {
    struct S_Item {
        string _identifier;
        Item _item;
        ItemManager.SupplyChainState _state;
    }
    mapping (uint => S_Item) public items;
    uint itemIndex;
    enum SupplyChainState{Created, Paid, Delivered}
    event SupplyChainStep(uint _itemIndex, uint _step, address _itemAddress);

    function createItem(string memory _identifier, uint _price) public onlyOwner {
        Item item = new Item(this, itemIndex, _price);
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._item= item;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, uint(SupplyChainState.Created), address(item));
        itemIndex++;
    }

    function triggerPayment(uint _itemIndex) public payable {
        // require(items[_itemIndex]._itemPrice == msg.value, "Only full payments are accepted");
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in the chain");
        items[_itemIndex]._state = SupplyChainState.Paid;

        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }

    function triggerDerivery(uint _itemIndex) public onlyOwner {
        require(items[_itemIndex]._state == SupplyChainState.Paid, "Item is further in the chain");
        items[_itemIndex]._state = SupplyChainState.Delivered;

        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }
}