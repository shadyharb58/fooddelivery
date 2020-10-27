import 'package:flutter/material.dart';
import 'package:fooddelivery/component/addtocart.dart';
import 'package:fooddelivery/pages/items/itemdetails.dart';
import 'package:provider/provider.dart';
class ItemsList extends StatelessWidget {
  final items ; 
  final crud ; 
  const ItemsList({Key key , this.items , this.crud}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child: Container(
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
              deliveryprice : items['res_price_delivery'] ,
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
                    width: 90,
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
                                        ? addtocart.add(items , items['res_price_delivery']  , items['res_id'])
                                        : addtocart.reset(items, items['res_price_delivery'] , items['res_id']);
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
    ));
  }
}

 