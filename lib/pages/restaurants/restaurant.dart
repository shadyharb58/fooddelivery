import 'package:flutter/material.dart';
import 'package:fooddelivery/pages/items/itemscatres.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery/component/addtocart.dart';

// My Import

import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/pages/items/itemdetails.dart';

class Restaurant extends StatefulWidget {
  @override
  _RestaurantState createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  Crud crud = new Crud();

  @override
  Widget build(BuildContext context) {
    Map routes = ModalRoute.of(context).settings.arguments;

    var mdw = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: Container(
            height: 60,
            color: Colors.red,
            child: MaterialButton(
                minWidth: 200,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pushNamed("cart");
                },
                child:
                    Consumer<AddToCart>(builder: (context, addtocart, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                      ),
                      Text(
                        " السلة ",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      addtocart.totalprice == null
                          ? SizedBox(
                              width: 1,
                            )
                          : Text(
                              "${addtocart.totalprice.toStringAsFixed(3)} دنيار كويتي",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 23),
                            ),
                    ],
                  );
                }))),
        body: WillPopScope(child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                buildTopRaduis(mdw),
                buildTopText(mdw),
                buildCardrestaurant(routes),
                Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 230),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "الاقسام",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                        buildListHorizontal(routes),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              "  الاكلات الاكثر مبيعا  ",
                              style: Theme.of(context).textTheme.headline2,
                            )),
                        SizedBox(height: 20),
                        Container(
                          height: 270,
                          child: FutureBuilder(
                            future:
                                crud.readDataWhere("items", routes['resid']),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data[0] == "faild") {
                                  return Image.asset("images/notfound.jpg");
                                } else {
                                  return ListView.builder(
                                      itemCount: snapshot.data.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, i) {
                                        return buildImageItems(
                                            mdw, snapshot.data[i]);
                                      });
                                }
                              }
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Text(
                              "الوجبات",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              "روئية الجميع",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        FutureBuilder(
                          future: crud.readDataWhere("items", routes['resid']),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data[0] == "faild") {
                                return Image.asset("images/notfound.jpg");
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, i) {
                                      return buildListItems(snapshot.data[i]);
                                    });
                              }
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        )
                      ],
                    ))
              ],
            )
          ],
        ), onWillPop: (){
          Navigator.of(context).pushNamed("home");
        }),
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
      padding: EdgeInsets.only(top: 10, right: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.arrow_back , color: Colors.white,), onPressed: (){
                Navigator.pushNamed(context, "home") ; 
              }),
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

  Container buildCardrestaurant(Map routes) {
    return Container(
        margin: EdgeInsets.only(top: 100, right: 30, left: 30),
        child: Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  "${routes['resname']}",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  "${routes['resdescription']}",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 2,
              ),
              SizedBox(
                height: 10,
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
                    " ${routes['restime']} - ${int.parse(routes['restime']) + 15} دقيقة   ",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Icon(
                    Icons.local_shipping, //directions_bike
                    size: 18,
                  ),
                  Text(
                    double.parse(routes['resprice']) == 0
                        ? " مجانا "
                        : " ${double.parse(routes['resprice'])} د.ك",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }

  Container buildListHorizontal(Map routes) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 110,
      child: FutureBuilder(
        future: crud.readData("categories"),
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
                      return ItemCatRes(
                        catid: snapshot.data[i]['cat_id'],
                        catname: snapshot.data[i]['cat_name'],
                        resid: routes['resid'],
                        resname: routes['resname'],
                      );
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

  InkWell buildImageItems(mdw, Map items) {
    return InkWell(
        onTap: () {
          return Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return ItemDetails(
              id: items['item_id'],
              name: items['item_name'],
              description: items['item_description'],
              image: items['item_image'],
              price: items['item_price'],
              items: items,
              deliveryprice: items['res_price_delivery'],
              deliveytime: items['res_time_delivery'],
            );
          }));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: 300,
          height: 100,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "http://${crud.server_name}/upload/items/${items['item_image']}"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Container(
              margin:
                  EdgeInsets.only(top: 100, bottom: 50, right: 30, left: 30),
              child: Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "${items['item_name']}",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        "${items['cat_name']}",
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
                          " ${items['res_time_delivery']} - ${int.parse(items['res_time_delivery']) + 15} دقيقة   ",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Icon(
                          Icons.local_shipping, //directions_bike
                          size: 18,
                        ),
                        Text(
                          double.parse(items['res_price_delivery']) == 0
                              ? " مجانا "
                              : " ${double.parse(items['res_price_delivery'])} د.ك",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ));
  }

  Container buildListItems(Map items) {
    return Container(
      child: InkWell(
        onTap: () {
          return Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return ItemDetails(
              id: items['item_id'],
              name: items['item_name'],
              description: items['item_description'],
              image: items['item_image'],
              price: items['item_price'],
              items: items,
              deliveryprice: items['res_price_delivery'],
              deliveytime: items['res_time_delivery'],
            );
          }));
        },
        child: Card(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Image.network(
                "http://${crud.server_name}/upload/items/${items['item_image']}",
                fit: BoxFit.cover,
                height: 90,
              ),
            ),
            Expanded(
                flex: 3,
                child: ListTile(
                  trailing: Container(
                    width: 81,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          " ${items['item_price']} ",
                          style: TextStyle(fontSize: 13),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Consumer<AddToCart>(
                          builder: (context, addtocart, child) {
                            return Container(
                                decoration: BoxDecoration(
                                    color:
                                        addtocart.active[items['item_id']] != 1
                                            ? Colors.black
                                            : Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    border: Border.all(
                                        width: 1, color: Colors.white)),
                                child: InkWell(
                                  onTap: () {
                                    addtocart.active[items['item_id']] != 1
                                        ? addtocart.add(
                                            items,
                                            items['res_price_delivery'],
                                            items['res_id'])
                                        : addtocart.reset(
                                            items,
                                            items['res_price_delivery'],
                                            items['res_id']);
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ));
                          },
                        )
                      ],
                    ),
                  ),
                  isThreeLine: true,
                  title: Text(
                    "${items['item_name']}",
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("${items['cat_name']}",
                          style: TextStyle(fontSize: 14)),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Color(0xffFFD700),
                            size: 16,
                          ),
                          Text(
                            " 4.8   ",
                            style: TextStyle(fontSize: 12),
                          ),
                          Icon(
                            Icons.timer,
                            size: 16,
                          ),
                          Text(
                              " ${items['res_time_delivery']} - ${int.parse(items['res_time_delivery']) + 15} دقيقة   ",
                              style: TextStyle(fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ))
          ],
        )),
      ),
    );
  }
}
