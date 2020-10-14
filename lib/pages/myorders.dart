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
        title: Text('طلباتي'),
      ),
      body: FutureBuilder(
        future: crud.readDataWhere("orders", "1"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
               return  ListView.builder(
          
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                  return  Column(children: [
                    Text(snapshot.data[index]['orders_id']) , 
                    FutureBuilder(
                      future: crud.readDataWhere("orderdetails", snapshot.data[index]['orders_id']),
                      builder: (BuildContext context, AsyncSnapshot snapshottwo) {
                         if (snapshottwo.hasData) {
                              return ListView.builder(
                       
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshottwo.data.length,
                                itemBuilder: (BuildContext context, int indextwo) {
                                return  Text("${snapshottwo.data[indextwo]['item_name']}");
                               },
                              ) ; 
                         }
                         return Center(child:CircularProgressIndicator()) ; 
                      },
                    ),

                  ]) ; 
                 },
                ) ;
            }
            return Center(child:CircularProgressIndicator()) ; 
                  },
      ),
    ));
  }
}