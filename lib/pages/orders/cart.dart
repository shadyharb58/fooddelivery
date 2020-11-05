 
import 'package:flutter/material.dart';
import 'package:fooddelivery/component/alert.dart';
import 'package:provider/provider.dart';
// my import

import 'package:fooddelivery/component/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../component/addtocart.dart';
import 'package:geolocator/geolocator.dart';

class Cart extends StatefulWidget {
  Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  var userid, username, lat, long;

  List users = new List();

  Crud crud = new Crud();

  bool loading = true;

  getUser() async {
    if (this.mounted) {
      setState(() {
            loading = true;
          });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userid = prefs.getString("id");
    username = prefs.getString('username');
    users.addAll(await crud.readDataWhere("users", userid));

    print(users);
       if (this.mounted) { setState(() {
      loading = false;
    }); }
  }

  getLocation() async {

   bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();
   if (!isLocationServiceEnabled) {
     showdialogall(context , "تنبيه"  , "خدمة تفعيل الموقع غير مفعلة الرجاء التفعيل") ; 
     await Future.delayed(Duration(seconds: 2) , () {
       Navigator.of(context).pushNamed("home") ; 
     }) ; 
   }else {
     

     LocationPermission permission = await Geolocator.checkPermission()  ; 

     if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
           Position position =
              await  Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        if (this.mounted) {
        setState(() {
                    lat = position.latitude;
                    long = position.longitude;
                  });
        print(permission) ; 
        }  
     }else {
                permission = await Geolocator.requestPermission();
                showdialogall(context , "تنبيه"  , "لا يمكن استخدام التطبيق من دون اعطاء صلاحية الوصول للموقع") ; 
                 await Future.delayed(Duration(seconds: 2) , () {
                  Navigator.of(context).pushNamed("home") ; 
                }) ;
     }
   }

 
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          bottomNavigationBar: loading == false
              ? Container(
                  height: 60,
                  color: Colors.red,
                  child: Consumer<AddToCart>(
                    builder: (context, addtocart, child) {
                      return MaterialButton(
                          minWidth: 200,
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            var data = {
                              "resid" : addtocart.listres[0]  , 
                              "listfood": addtocart.basketnoreapt,
                              "quantity": addtocart.quantity,
                              'userid': userid,
                              'totalprice': addtocart
                                  .sumtotalprice, // total price with price delivery
                              'lat': lat,
                              'long': long,
                              'timenow': DateTime.now().toString()
                            };
                            if (double.parse(
                                        addtocart.sumtotalprice.toString()) <=
                                    double.parse(
                                        users[0]['user_balance'].toString()) &&
                                addtocart.basketnoreapt.isNotEmpty) {
                              await crud.addOrders("checkout", data);
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              List usersaftercheckout =
                                  await crud.readDataWhere(
                                      "users", prefs.getString("id"));
                              prefs.setString(
                                  "balance",
                                  usersaftercheckout[0]['user_balance']
                                      .toString());
                              Provider.of<AddToCart>(context, listen: false)
                                  .removeAll();
                              Navigator.of(context)
                                  .pushReplacementNamed("myorders");
                            } else if (addtocart.basketnoreapt.isEmpty) {
                              showdialogall(
                                  context, "تنبيه", " لا يوجد اي منتج للشراء ");
                            } else {
                              showdialogall(
                                  context, "تنبيه", "الرصيد غير كافي");
                              print(addtocart.basketnoreapt.toString());
                            }
                          },
                          child: Consumer<AddToCart>(
                              builder: (context, addtocart, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.payment,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                Text(
                                  " الدفع ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 23),
                                ),
                              ],
                            );
                          }));
                    },
                  ))
              : Center(
                  child: CircularProgressIndicator(),
                ),
          body: ListView(
            children: [
              Stack(
                children: [
                  buildTopRaduis(mdw),
                  buildTopText(mdw),
                  buildCardPrice(mdw),
                  Consumer<AddToCart>(builder: (context, addtocart, child) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 330),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: addtocart.basketnoreapt.length,
                          itemBuilder: (context, i) {
                            // return Dismissible(
                            //     key: UniqueKey(),
                            //     onDismissed: (direction) {
                            //       addtocart.reset(addtocart.basketnoreapt[i]);
                            //       addtocart.basketnoreapt.removeAt(i);
                            //     },
                            //     child:
                            return Card(
                                child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Image.network(
                                    "http://${crud.server_name}/upload/items/${addtocart.basketnoreapt[i]['item_image']}",
                                    fit: BoxFit.cover,
                                    height: 70,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: ListTile(
                                    title: Text(
                                        "${addtocart.basketnoreapt[i]['item_name']}"),
                                    trailing: Container(
                                      width: 110,
                                      child: Row(
                                        children: [
                                          IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: () {
                                                addtocart.remove(
                                                    addtocart.basketnoreapt[i]);
                                              }),
                                          Text(
                                              "${addtocart.quantity[addtocart.basketnoreapt[i]['item_id']]}"),
                                          IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                addtocart.add(
                                                    addtocart.basketnoreapt[i]);
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ));
                          }),
                    );
                  })
                ],
              )
            ],
          ),
        ));
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
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
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
        ],
      ),
    );
  }

  Center buildCardPrice(mdw) {
    return Center(
        child: Consumer<AddToCart>(builder: (context, addtocart, child) {
      return Container(
        margin: EdgeInsets.only(top: 100),
        child: Card(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      " التكلفة  ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(child: Container()),
                    Text("${addtocart.totalprice.toStringAsFixed(3)} د.ك",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text("التوصيل ", style: TextStyle(fontSize: 20)),
                    Expanded(child: Container()),
                    Text("${addtocart.totalpricedelivery}",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor))
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(" التكلفة الكلية ", style: TextStyle(fontSize: 20)),
                    Expanded(child: Container()),
                    Text("${addtocart.sumtotalprice.toStringAsFixed(3)}  د.ك ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor))
                  ],
                ),
              ),
            ],
          ),
        ),
        width: mdw - 0.2 * mdw,
        height: 200,
      );
    }));
  }
}

/*
function sendGCM($message, $fcm_id , $p_id, $p_name) {
	//$message = utf8_decode($message);
    $url = 'https://fcm.googleapis.com/fcm/send';
    $fields = array (
            'registration_ids' => array (
                     $fcm_id
            ),
'priority' =>'high',
'content_available' => true,
            'notification' => array (
			"body" =>  $message,
      		"title" =>  "Sale",
			"click_action" => "FCM_PLUGIN_ACTIVITY",
					"sound" => "default"
            ),
			 'data' => array (
					"page_id" => $p_id ,
					"page_name" => $p_name
//			'message' => 'Hello World!'
            )
    );
    $fields = json_encode ( $fields );
    $headers = array (
           // 'Authorization: key=' . "AIzaSyBUuLepXI4xjIuWBO78hagHX9ntj9j_mU4",
		    'Authorization: key=' . "AAAA6G-rtk4:APA91bF8Z5QVsjsIaBYqG1LaCjfaD4nRgpV9WjJYW89XlzlgTS65ZbVum_F1dSrIi8mxroCblGJ2bonirYCOZeOzESPMUVWg9U1ukbPcZ29nThII3DNgxMf_Umj2_QTdxmHVJYoMq1iQ",
            'Content-Type: application/json'
    );
    $ch = curl_init ();
    curl_setopt ( $ch, CURLOPT_URL, $url );
    curl_setopt ( $ch, CURLOPT_POST, true );
    curl_setopt ( $ch, CURLOPT_HTTPHEADER, $headers );
    curl_setopt ( $ch, CURLOPT_RETURNTRANSFER, true );
    curl_setopt ( $ch, CURLOPT_POSTFIELDS, $fields );
    $result = curl_exec ( $ch );
    return $result;
    curl_close ( $ch );
}
*/
