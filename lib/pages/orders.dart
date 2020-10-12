import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// my import

import 'package:fooddelivery/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../component/addtocart.dart';
import 'package:geolocator/geolocator.dart';

class Orders extends StatefulWidget {
  Orders({Key key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  var userid, username, lat, long;

  Crud crud = new Crud();

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userid = prefs.getString("id");

    username = prefs.getString('username');

    setState(() {});
  }

  getLocation() async {
    Position position =  await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          bottomNavigationBar: Container(
              height: 60,
              color: Colors.red,
              child: Consumer<AddToCart>(
                builder: (context, addtocart, child) {
                  return MaterialButton(
                      minWidth: 200,
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        var data = {
                          "listfood": addtocart.basketnoreapt,
                          "quantity": addtocart.quantity,
                          'userid': userid,
                          'totalprice': addtocart.sumtotalprice, // total price with price delivery
                          'resprice': addtocart.resprice,
                          'lat' : lat , 
                          'long' : long , 
                          'timenow' : DateTime.now().toString()
                        };
                        await crud.addOrders("addorders", data);
                      },
                      child: Consumer<AddToCart>(
                          builder: (context, addtocart, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.payment,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              " الدفع ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 23),
                            ),
                          ],
                        );
                      }));
                },
              )),
          body: ListView(
            children: [
              Stack(
                children: [
                  buildTopRaduis(mdw),
                  buildTopText(mdw),
                  buildCardPrice(mdw),
                  Consumer<AddToCart>(builder: (context, addtocart, child) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 330),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: addtocart.basketnoreapt.length,
                          itemBuilder: (context, i) {
                            return Card(
                                child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Image.network(
                                    "http://${crud.server_name}/upload/items/${addtocart.basketnoreapt[i]['item_image']}",
                                    fit: BoxFit.cover,
                                    height: 70,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: ListTile(
                                    title: Text(
                                        "${addtocart.basketnoreapt[i]['item_name']}"),
                                    trailing: Text(
                                        "${addtocart.quantity[addtocart.basketnoreapt[i]['item_id']]}"),
                                  ),
                                )
                              ],
                            ));
                          }),
                    );
                  })
                ],
              )
            ],
          ),
        ));
  }

  Transform buildTopRaduis(mdw) {
    return Transform.scale(
        scale: 2,
        child: Transform.translate(
          offset: Offset(0, -200),
          child: Container(
            height: mdw,
            width: mdw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(mdw)),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ));
  }

  Padding buildTopText(mdw) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("TalabPay",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              Expanded(child: Container()),
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: null)
            ],
          ),
        ],
      ),
    );
  }

  Center buildCardPrice(mdw) {
    return Center(
        child: Consumer<AddToCart>(builder: (context, addtocart, child) {
      return Container(
        margin: EdgeInsets.only(top: 100),
        child: Card(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      " التكلفة  ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(child: Container()),
                    Text("${addtocart.totalprice} د.ك",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text("التوصيل ", style: TextStyle(fontSize: 20)),
                    Expanded(child: Container()),
                    Text("${addtocart.totalpricedelivery}",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor))
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(" التكلفة الكلية ", style: TextStyle(fontSize: 20)),
                    Expanded(child: Container()),
                    Text("${addtocart.sumtotalprice}  د.ك ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor))
                  ],
                ),
              ),
            ],
          ),
        ),
        width: mdw - 0.2 * mdw,
        height: 200,
      );
    }));
  }
}
