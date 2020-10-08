import 'package:flutter/material.dart';
import 'package:fooddelivery/crud.dart';
import 'package:fooddelivery/pages/items/itemscat.dart';

class Categories extends StatefulWidget {
  Categories({Key key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Crud crud = new Crud();
  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Stack(children: <Widget>[
              buildTopRaduis(mdw),
              buildTopText(mdw),
              Container(
                margin: EdgeInsets.only(top:200),
                child: Column(children: [
               FutureBuilder(
                future: crud.readData("categories"),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, i) {
                          return CategoriesList(
                            categories: snapshot.data[i],
                          );
                        });
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
              ],),)  ,
           
            ])
          ],
        ),
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
                  onPressed: null)
            ],
          ),
          Text("الاقسام",
              style: TextStyle(color: Colors.white, fontSize: 30)),
        ],
      ),
    );
  }
}

class CategoriesList extends StatelessWidget {
  
  Crud crud = new Crud() ; 

  final categories;
  CategoriesList({this.categories});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ItemsCat(
              catid: categories['cat_id'], catname: categories['cat_name']);
        }));
      },
      child: Card(
          child: Column(
        children: [
          Image.network(
            "http://${crud.server_name}/upload/categories/${categories['cat_photo']}",
            height: 130,
          ),
          Text(
            "${categories['cat_name']}",
            style: TextStyle(fontSize: 29, color: Colors.red),
          )
        ],
      )),
    );
  }
}
