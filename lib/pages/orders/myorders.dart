import 'package:flutter/material.dart';
// My Import
import 'package:fooddelivery/component/crud.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrders extends StatefulWidget {
  MyOrders({Key key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  Crud crud = new Crud();
  var userid;
  setLocal() async {
    await Jiffy.locale("ar");
  }

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("id");
      print(userid);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setLocal();
    getuserid();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: Text('طلباتي'),
            ),
            body: WillPopScope(
                child: userid == null
                    ? Center(child: CircularProgressIndicator())
                    : FutureBuilder(
                        future: crud.readDataWhere("orders", userid),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data[0] == "faild") {
                              return Center(
                                  child: Text(
                                "لا يوجد اي طلب ",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 30),
                              ));
                            }
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
                onWillPop: () {
                  Navigator.pushNamed(context, "home");
                })));
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
            style: TextStyle(color: Colors.grey),
          ),
          isThreeLine: true,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(
                      style:
                          TextStyle(fontFamily: 'Cairo', color: Colors.black),
                      children: [
                    TextSpan(
                        text: "حالة الطلبية : ",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: int.parse(orders['orders_status']) == 0
                            ? "بانتظار الموافقة"
                            : int.parse(orders['orders_status']) == 1
                                ? "قيد التوصيل"
                                : "تم التوصيل",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w600)),
                  ])),
              RichText(
                  text: TextSpan(
                      style:
                          TextStyle(fontFamily: 'Cairo', color: Colors.black),
                      children: [
                    TextSpan(
                        text: "المطعم : ",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: " ${orders['res_name']}  ",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600)),
                  ])),
              RichText(
                  text: TextSpan(
                      style:
                          TextStyle(fontFamily: 'Cairo', color: Colors.black),
                      children: [
                    TextSpan(
                        text: "السعر الكلي :",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: " ${orders['orders_total']} د.ك",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600)),
                  ])),
            ],
          ),
        )
      ],
    )));
  }
}
