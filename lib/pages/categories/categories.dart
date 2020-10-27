import 'package:flutter/material.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/component/searchglobal.dart';
import 'package:fooddelivery/pages/categories/categorieslist.dart';
import 'dart:io';

class Categories extends StatefulWidget {
  Categories({Key key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
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

    double mdw = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: WillPopScope(
            child: ListView(
              children: <Widget>[
                Stack(children: <Widget>[
                  buildTopRaduis(mdw),
                  buildTopText(mdw),
                  Container(
                    margin: EdgeInsets.only(top: 200),
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: crud.readData("categories"),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemBuilder: (context, i) {
                                    return CategoriesList(
                                      categories: snapshot.data[i],
                                      crud: crud,
                                    );
                                  });
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        )
                      ],
                    ),
                  ),
                ])
              ],
            ),
            onWillPop: onWillPop),
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
                    showSearch(
                        context: context,
                        delegate: DataSearch(type: "categories", mdw: mdw));
                  })
            ],
          ),
          Text("الاقسام", style: TextStyle(color: Colors.white, fontSize: 30)),
        ],
      ),
    );
  }
}

