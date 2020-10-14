import 'package:flutter/material.dart';
// My Import
import 'package:fooddelivery/crud.dart';
import 'package:jiffy/jiffy.dart';

class MyOrders extends StatefulWidget {
  MyOrders({Key key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  Crud crud = new Crud();
  setLocal() async {
    await Jiffy.locale("ar");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('طلباتي'),
          ),
          body: FutureBuilder(
            future: crud.readDataWhere("orders", "1"),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListOrders(orders: snapshot.data[index]);
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}

class ListOrders extends StatelessWidget {
  final orders;

  const ListOrders({Key key, this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            child: Column(
      children: [
        ListTile(
          title: Text("معرف الطلبية : ${orders['orders_id']}"),
          trailing: Text(
            "${Jiffy(orders['orders_date']).fromNow()}",
            style: TextStyle(color: Colors.blue),
          ),
          isThreeLine: true ,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              int.parse(orders['orders_status']) == 0
                  ? Text("حالة الطلبية :  قيد التوصيل ")
                  : Text("حالة الطلبية : تم التوصيل بنجاح")    , 
                    Text("السعر الكلي : ${orders['orders_total']} نقطة"  , style: TextStyle(color: Colors.red),)
            ],
          ),
        )
      ],
    )));
  }
}



 