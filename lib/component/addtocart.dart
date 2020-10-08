import 'package:flutter/material.dart';

class AddToCart with ChangeNotifier {
  List _items = [];
  List _itemsnoreapt = [];
  int _price = 0;
  Map quantity = {};
  Map active = {}; // Change Color Button

  void add(items) {
    // print(items) ;
    active[items['item_id']] = 1; // Acive Button any Change color To Red
    _price += int.parse(items['item_price'].toString());
    if (quantity[items['item_id']] == null) {
      _itemsnoreapt.add(items);
      quantity[items['item_id']] = 1;
    } else if (quantity[items['item_id']] == 0) {
      _itemsnoreapt.add(items);
      quantity[items['item_id']] = 1;
    } else {
      quantity[items['item_id']] = quantity[items['item_id']] + 1;
    }
    print(_itemsnoreapt)  ; 
    notifyListeners();
  }

  void remove(items) {
    if (quantity[items['item_id']] == 1) {
      _itemsnoreapt.removeWhere((item) => item['item_id'] == items['item_id']);
       active[items['item_id']] = 0;
    }
    if (quantity[items['item_id']] > 0) {
      _price -= int.parse(items['item_price'].toString());
      quantity[items['item_id']] = quantity[items['item_id']] - 1;
    }

    notifyListeners();
  }

  void reset(items) {
  _itemsnoreapt.removeWhere((item) => item['item_id'] == items['item_id'] );
    _price = _price -
        (int.parse(quantity[items['item_id']].toString()) *
            int.parse(items['item_price'].toString()));
    quantity[items['item_id']] = 0;
    active[items['item_id']] = 0; // unAcive Button any Change color To black
    notifyListeners();
  }

  int get count {
    return _items.length;
  }

  int get totalprice {
    return _price;
  }

  List get basket {
    return _items;
  }

  List get basketnoreapt {
    return _itemsnoreapt;
  }

  // Color button change

}
