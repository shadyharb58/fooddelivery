import 'package:flutter/material.dart';
import 'package:fooddelivery/pages/orders/ordersdone.dart';
import 'package:fooddelivery/pages/orders/orderswait.dart';
// My Import


class MyOrders extends StatefulWidget {
  MyOrders({Key key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  

  @override
  Widget build(BuildContext context) {
    return Directionality(

        textDirection: TextDirection.rtl,
        child:  DefaultTabController(length: 2, child:Scaffold(
            appBar: AppBar(
              title: Text('طلباتي'),
              bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: [
                Text("بانتظار التوصيل") , 
                Text("تم التوصيل")
              ]),
            ),
            body:  TabBarView(children: [
                       OrdersWait()  , 
                       OrdersDone()
            ]) 
                )))
                ;
  }
}
 