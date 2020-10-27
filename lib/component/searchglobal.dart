 
import 'package:flutter/material.dart';
import 'package:fooddelivery/component/crud.dart';

class DataSearch extends SearchDelegate<Future<Widget>> {
  List<dynamic> list;
  final type;
  final mdw;

  DataSearch({this.type, this.mdw});

  Crud crud = new Crud();
  @override
  List<Widget> buildActions(BuildContext context) {
    // Action for AppBar
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icon Leading
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    return Text("yes");
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searchers for something
    if (query.isEmpty) {
      return Center(
        child: Stack(
          children: [
            Positioned(
                left: mdw - 85 / 100 * mdw,
                top: mdw - 50 / 100 * mdw,
                child: Image.asset(
                  "images/search.png",
                  width: mdw,
                  height: mdw,
                ))
          ],
        ),
      );
    } else {
      return FutureBuilder(
        future: type == "categories"
            ? crud.readDataWhere("searchcats", query.toString())
            : type == "items"
                ? crud.readDataWhere("searchitems", query.toString())
                : type == "users" ? 
                  crud.readDataWhere("searchusers", query.toString()) : type == "restuarants" ? 
                    crud.readDataWhere("searchrestaurants", query.toString()) : ""
                 ,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data[0] == "faild") {
              return Text("فارغ");
            }
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  if (type == "categories") {
                    return Text("w");
                  } else if (type == "items") {
                          return Text("w");
                  } else if (type == "users") {
                     return Text("w");
                  }else if (type == "restuarants") {
                    return  Text("w");
                  }
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    }
  }
}
