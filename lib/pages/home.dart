import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fooddelivery/component/searchglobal.dart';
import 'package:fooddelivery/crud.dart';
import 'package:fooddelivery/pages/items/itemscat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Crud crud = new Crud();

  Future getCategories() async {
    var responsebody = await crud.readData("categories");
    return responsebody;
  }

  Future getRestaurants() async {
    var responsebody = await crud.readData("restaurants");
    return responsebody;
  }
   checkSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("id") == null) {
      Navigator.of(context).pushReplacementNamed("login");
    }
  }
 
  @override
  void initState() {
    checkSignIn() ; 
    super.initState();
  }
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
    double mdw = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: WillPopScope(child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                buildTopRaduis(mdw),
                buildTopText(mdw),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[ // ] ))])
                      Container(
                        margin: EdgeInsets.only(top: 200),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "الاقسام",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      buildListHorizontal(),
                      Padding(
                          padding: EdgeInsets.only(top: 10, right: 15),
                          child: Text(
                            " المطاعم الاعلى تقييما ",
                            style: Theme.of(context).textTheme.headline2,
                          )),
                      Container(
                        height: 260,
                        margin: EdgeInsets.only(top: 10, right: 15),
                        child: FutureBuilder(
                          future: crud.readData("restaurantstopselling"),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
                                    return buildImageRestrant(
                                      mdw,
                                      snapshot.data[i]['res_image'],
                                      snapshot.data[i]['res_name'],
                                      snapshot.data[i]['res_description'],
                                      snapshot.data[i]['res_id'],
                                      snapshot.data[i]['res_type'],
                                      snapshot.data[i]['res_price_delivery'],
                                      snapshot.data[i]['res_time_delivery'],
                                    );
                                  });
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10, right: 15),
                          child: Text(
                            " المطاعم الاكثر مبيعيا",
                            style:Theme.of(context).textTheme.headline2,
                          )),
                      Container(
                        height: 270,
                        margin: EdgeInsets.only(top: 10, right: 15),
                        child: FutureBuilder(
                          future: crud.readData("restaurantstopselling"),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
                                    return buildImageRestrant(
                                      mdw,
                                      snapshot.data[i]['res_image'],
                                      snapshot.data[i]['res_name'],
                                      snapshot.data[i]['res_description'],
                                      snapshot.data[i]['res_id'],
                                      snapshot.data[i]['res_type'],
                                      snapshot.data[i]['res_price_delivery'],
                                      snapshot.data[i]['res_time_delivery'],
                                    );
                                  });
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ],
                  ),
                )   , 
                
            

              ],
            ),
          ],
        ), onWillPop: onWillPop ),
      ),
    );
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
                    showSearch(context: context, delegate: SearchGlobal()) ;
                  })
            ],
          ),
          Text("الصفحة الرئيسية",
              style: TextStyle(color: Colors.white, fontSize: 30)),
        ],
      ),
    );
  }

  Container buildListHorizontal() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 110,
      child: FutureBuilder(
        future: getCategories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ItemsCat(
                          catid: snapshot.data[i]['cat_id'],
                          catname: snapshot.data[i]['cat_name']);
                    }));
                  },
                  child: Container(
                    child: Card(
                      child: Column(
                        children: [
                          Image.network(
                            "http://${crud.server_name}/upload/categories/${snapshot.data[i]['cat_photo']}",
                            height: 70,
                            width: 80,
                            fit: BoxFit.fill,
                          ),
                          Text("${snapshot.data[i]['cat_name']}")
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  InkWell buildImageRestrant(
      mdw, image, name, description, resid, restype, resprice, restime) {
    return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed("restaurant", arguments: {
            "resid": resid,
            "resname": name,
            "resdescription": description,
            "resprice": resprice,
            "restime": restime
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: 300,
          height: 100,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "http://${crud.server_name}/upload/reslogo/$image"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Container(
              margin:
                  EdgeInsets.only(top: 100, bottom: 50, right: 30, left: 30),
              child: Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "${name}",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        "${restype}",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 1,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Color(0xffFFD700),
                          size: 18,
                        ),
                        Text(
                          " 4.8   ",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Icon(
                          Icons.timer,
                          size: 18,
                        ),
                        Text(
                          " ${int.parse(restime)} - ${int.parse(restime) + 15} دقيقة   ",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Icon(
                          Icons.local_shipping, //directions_bike
                          size: 18,
                        ),
                        Text(
                          int.parse(resprice) == 0
                              ? " مجانا "
                              : " ${resprice} د.ك",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ));
  }
}
