import 'package:flutter/material.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/pages/restaurants/restaurantslist.dart';
import 'dart:io';

class Restaurants extends StatefulWidget {
  Restaurants({Key key}) : super(key: key);
  @override
  _RestaurantsState createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  Crud crud = new Crud();

  @override
  Widget build(BuildContext context) {

       Future<bool> onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () => exit(0),
                //  onPressed: () =>   Navigator.of(context).pop(true)  ,
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

    var mdw = MediaQuery.of(context).size.width;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButton: Container(
              padding: EdgeInsets.only(left: mdw - 80),
              child: Container(
                  width: 60,
                  height: 60,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('addrestaurants');
                    },
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                    backgroundColor: Colors.red,
                  ))),
          body: WillPopScope(
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      buildTopRaduis(mdw),
                      buildTopText(mdw),
                      Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 200),
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "المطاعم",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                              FutureBuilder(
                                future: crud.readData('restaurants'),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data[0] == "faild") {
                                      return Text("لا يوجد اي مطاعم");
                                    } else {
                                      return RestaurantsApprove(
                                        resturantsapprove: snapshot.data,
                                      );
                                    }
                                  }
                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                              )
                            ]),
                      ),
                    ],
                  ),
                ],
              ),
              onWillPop:  onWillPop ),
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
                  onPressed: () {
                    // showSearch(context: context, delegate: SearchGlobal()) ;
                  })
            ],
          ),
          Text("جميع المطاعم",
              style: TextStyle(color: Colors.white, fontSize: 30)),
        ],
      ),
    );
  }
}

class RestaurantsApprove extends StatelessWidget {
  final resturantsapprove;

  RestaurantsApprove({this.resturantsapprove});
  Crud crud = new Crud();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true ,
        physics: NeverScrollableScrollPhysics(),
          itemCount: resturantsapprove.length,
          itemBuilder: (context, i) {
            return   RestaurantsList(
                res_id: resturantsapprove[i]['res_id'],
                res_name: resturantsapprove[i]['res_name'],
                res_address: resturantsapprove[i]['res_area'],
                res_approve: resturantsapprove[i]['res_approve'],
                res_image: resturantsapprove[i]['res_image'],
                res_price : resturantsapprove[i]['res_price_delivery']  , 
                res_time  :    resturantsapprove[i]['res_time_delivery']
              );
          }),
    );
  }
}
