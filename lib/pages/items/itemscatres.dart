import 'package:flutter/material.dart';
import 'package:fooddelivery/crud.dart';
import 'package:fooddelivery/pages/items/itemdetails.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery/component/addtocart.dart';

class ItemCatRes extends StatefulWidget {
  final catid;
  final catname;
  final resid ; 
  final resname ; 
  ItemCatRes({Key key, this.catid, this.catname , this.resid  , this.resname}) : super(key: key);
  @override
  _ItemCatResState createState() => _ItemCatResState();
}

class _ItemCatResState extends State<ItemCatRes> {
  Crud crud = new Crud();
  Map data;

  @override
  void initState() {
    data = {"catid": widget.catid  , "resid" : widget.resid};

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('${widget.catname}'),
          ),
           bottomNavigationBar: Container(
            height: 60,
            color: Colors.red,
            child: MaterialButton(
                minWidth: 200,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pushNamed("orders");
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
                              "${addtocart.totalprice} دنيار كويتي",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 23),
                            ),
                    ],
                  );
                }))),
          body: Container(
            child: FutureBuilder(
              future: crud.writeData("items", data),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data[0] == "faild") {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 50, bottom: 50, left: 10, right: 10),
                          child: Text("لا يوجد وجبات في هذا القسم",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 25)),
                        ),
                        Image.asset("images/notfound.jpg")
                      ],
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          return buildListItems(snapshot.data[i]);
                        });
                  }
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
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
                height: 100,
              ),
            ),
            Expanded(
                flex: 3,
                child: ListTile(
                  trailing: Container(
                    width: 80,
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
                                        ? addtocart.add(items , items['res_price_delivery'] , items['res_id'])
                                        : addtocart.reset(items);
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
