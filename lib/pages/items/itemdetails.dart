import 'package:flutter/material.dart';
import 'package:fooddelivery/component/addtocart.dart';
import 'package:fooddelivery/crud.dart';
import 'package:provider/provider.dart';

class ItemDetails extends StatefulWidget {
  

  final id;
  final name;
  final description;
  final image;
  final price;
  final items;
  final deliveryprice ; 
  final deliveytime ; 
  ItemDetails(
      {Key key,
      this.items,
      this.id,
      this.name,
      this.image,
      this.description,
      this.price ,
      this.deliveryprice ,
      this.deliveytime
      })
      : super(key: key);
  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  var quanitity;

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            body: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                buildTopRaduis(mdw),
                buildTopText(mdw),
                buildImageItem(),
                Container(
                  margin: EdgeInsets.only(top: 500, right: 10, left: 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "${widget.name}",
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                          Expanded(child: Container()),
                          Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                " ${widget.price} KD ",
                                style:
                                    TextStyle(fontSize: 20, color: Colors.red),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.timer,
                            size: 20,
                            color: Colors.red,
                          ),
                          Text(
                            "  ${widget.deliveytime} -  ${int.parse(widget.deliveytime) + 15} دقيقة   ",
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(
                            Icons.local_shipping, //directions_bike
                            size: 20,
                            color: Colors.red,
                          ),
                          Text(
                            int.parse(widget.deliveryprice) == 0   ?  " مجانا " : " ${widget.deliveryprice} د.ك"  ,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Container(
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            "${widget.description}",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 16),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Text("الكمية "),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 20, left: 20),
                            decoration: BoxDecoration(
                                // borderRadius:
                                //     BorderRadius.all(Radius.circular(10)) ,
                                border: Border.all()),
                            child: Consumer<AddToCart>(
                              builder: (context, addtocart, child) {
                                if (addtocart.quantity[widget.id] != null) {
                                  return Text(
                                      "${addtocart.quantity[widget.id]}");
                                } else {
                                  return Text("0");
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Consumer<AddToCart>(
                              builder: (context, addtocart, child) {
                            return InkWell(
                              onTap: () {
                                addtocart.remove(widget.items);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50)))),
                            );
                          }),
                          SizedBox(
                            width: 10,
                          ),
                          Consumer<AddToCart>(
                            builder: (context, addtocart, child) {
                              return InkWell(
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)))),
                                onTap: () {
                                  addtocart.add(widget.items , widget.deliveryprice , widget.items['res_id']);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Consumer<AddToCart>(builder: (context, addtocart, child) {
                        return MaterialButton(
                          minWidth: 200,
                          color: Colors.red,
                          onPressed: () {
                            addtocart.add(widget.items  , widget.deliveryprice, widget.items['res_id']);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                " اضافة الى السلة ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                                size: 22,
                              )
                            ],
                          ),
                        );
                      })
                    ],
                  ),
                )
              ],
            )
          ],
        )));
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
              Consumer<AddToCart>(
                builder: (context, addtocart, child) {
                  return Row(
                    children: [
                      Directionality(
                          textDirection: TextDirection.ltr,
                          child: addtocart.totalprice == null
                              ? Text(
                                  "${0} K.D",
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  "${addtocart.totalprice} K.D",
                                  style: TextStyle(color: Colors.white),
                                )),
                      IconButton(
                          icon: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            return Navigator.of(context).pushNamed("orders") ;
                          }),
                    ],
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Container buildImageItem() {
  Crud crud = new Crud();

    return Container(
      width: double.infinity,
      height: 330,
      margin: EdgeInsets.only(top: 120, left: 40, right: 40),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100))),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        child: Image.network(
          "http://${crud.server_name}/upload/items/${widget.image}",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
