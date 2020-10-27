import 'package:flutter/material.dart';
import 'package:fooddelivery/pages/items/itemscat.dart';

class CategoriesList extends StatelessWidget {
  final crud;
  final categories;
  CategoriesList({this.categories, this.crud});
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
