import 'package:flutter/material.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/component/searchglobal.dart';
import 'package:fooddelivery/pages/items/itemslist.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery/component/addtocart.dart';

class ItemsCat extends StatefulWidget {
  final catid;
  final catname;
  ItemsCat({Key key, this.catid, this.catname}) : super(key: key);
  @override
  _ItemsCatState createState() => _ItemsCatState();
}

class _ItemsCatState extends State<ItemsCat> {
  Crud crud = new Crud();
  Map data;

  @override
  void initState() {
    data = {"catid": widget.catid};

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width ; 
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('${widget.catname}'),
            actions: [
               IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showSearch(context: context, delegate: DataSearch( type:  "itemscat" , mdw: mdw  ,cat: widget.catid));
                  })
            ],
          ),
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
                  }  
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          return ItemsList(items: snapshot.data[i],crud: crud,);
                        });         
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ));
  }

  
}
