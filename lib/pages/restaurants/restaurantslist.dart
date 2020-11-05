import 'package:flutter/material.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RestaurantsList extends StatelessWidget {
  Crud crud = new Crud();
  final res_id;
  final res_image;
  final res_name;
  final res_decsription;
  final res_address;
  final res_approve;
  final res_price;
  final res_time;
  RestaurantsList(
      {this.res_name,
      this.res_image,
      this.res_decsription,
      this.res_address,
      this.res_approve,
      this.res_id,
      this.res_price,
      this.res_time});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed("restaurant", arguments: {
              "resid": res_id,
              "resname": res_name,
              "resdescription": res_decsription,
              "resprice": res_price,
              "restime": res_time
            });
          },
          child: Container(
            child: Card(
                child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: CachedNetworkImage(
                    imageUrl:
                        "http://${crud.server_name}/upload/reslogo/$res_image",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text("مطعم ${res_name}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("كافة الوجبات الغربية"),
                                Text(
                                  "العنوان ${res_address}",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            )),
          ),
        ),
        (res_approve == "0")
            ? Positioned(
                left: 0,
                top: 10,
                child: Container(
                  child: Text(
                    "موافقة",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.red,
                  width: 50,
                  height: 20,
                ))
            : SizedBox()
      ],
    );
  }
}
