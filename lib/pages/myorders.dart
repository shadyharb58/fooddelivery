import 'package:flutter/material.dart';
// My Import
import 'package:fooddelivery/crud.dart';


class MyOrders extends StatefulWidget {
  MyOrders({Key key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  
  Crud crud = new Crud() ; 

  @override
  Widget build(BuildContext context) {
    return  Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Text("sd"),
    ));
  }
}