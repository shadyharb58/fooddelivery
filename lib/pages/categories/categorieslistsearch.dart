import 'package:flutter/material.dart';
import 'package:fooddelivery/pages/items/itemscat.dart';

class CategoriesListSearch extends StatelessWidget {
  final crud;
  final categories;
  CategoriesListSearch({this.categories, this.crud});
  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child: InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ItemsCat(
              catid: categories['cat_id'], catname: categories['cat_name']);
        }));
      },
      child: Card(
         child: Row(children: [
            Image.network("http://${crud.server_name}/upload/categories/${categories['cat_photo']}",  height: 100,width: 100,) , 
            Text(
            "  ${categories['cat_name']}",
            style: TextStyle(fontSize: 20, color: Colors.red),
          )

         ],),
         ),
    ));
  }
}
