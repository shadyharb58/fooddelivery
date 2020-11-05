import 'package:flutter/material.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/pages/editaccount.dart';
import 'package:fooddelivery/pages/transfermoney.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class MyInformation extends StatefulWidget {
  MyInformation({Key key}) : super(key: key);

  @override
  _MyInformationState createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> {
  Crud crud = new Crud();
  var username, id, email, balance, phone, password;

 
  getCurrentUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     id = prefs.getString("id");
    var responsebody = await crud.readDataWhere("users", id);
    email = responsebody[0]['email'];
    username = responsebody[0]['username'];
    balance = responsebody[0]['user_balance'];
    password = responsebody[0]['password'];
    phone = responsebody[0]['user_phone'];
    if (this.mounted) {
      setState(() {
            
          });
    }
  }

  checkSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("id") == null) {
      Navigator.of(context).pushReplacementNamed("login");
    }
  }

  @override
  void initState() {
    getCurrentUserInformation();
    checkSignIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
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

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: WillPopScope(child: ListView(
            children: [
              Stack(children: <Widget>[
                buildTopRaduis(mdw),
                buildTopText(mdw),
                Container(
                  margin: EdgeInsets.only(top: 200),
                  child: Column(
                    children: [
                      buildListTile(
                          "حسابي", Icons.perm_identity, "editaccount"),
                      buildListTile(
                          "الطلبات", Icons.directions_car, "myorders"),
                      buildListTile(
                          "تحويل الرصيد", Icons.attach_money, "sendmoney"),
                      buildListTile("الاعدادات", Icons.settings),
                      buildListTile(
                          "تسجيل الخروج", Icons.exit_to_app, "logout"),
                    ],
                  ),
                )
              ])
            ],
          ), onWillPop: onWillPop),
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
              Text("TalabPay",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              Expanded(child: Container()),
     
            ],
          ),
          Row(
            children: [
              CircleAvatar(
                maxRadius: 30,
                minRadius: 30,
                child: Text(
                  "${username != null ? username[0].toString().toUpperCase() : username}",
                  style: TextStyle(color: Colors.red, fontSize: 30),
                ),
                backgroundColor: Colors.white,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "   ${username}",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "   ${email}",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      "${username != null ? username[0].toString().toUpperCase() : username}  ${balance}",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text("الرصيد", style: TextStyle(color: Colors.white))
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  InkWell buildListTile(String text, IconData icon, [type]) {
    return InkWell(
      onTap: () async {
        if (type == "logout") {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove("username");
          preferences.remove("email");
          preferences.remove("id");
          preferences.remove("balance");
          preferences.remove("phone");
          Navigator.of(context).pushNamed("login");
        } else if (type == "myorders") {
          Navigator.of(context).pushNamed("myorders");
        } else if (type == "editaccount") {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return EditAccount(
              email: email,
              password: password,
              phone: phone,
              userid: id,
              username: username,
            );
          }));
        } else if (type == "sendmoney") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
            return  TransferMoney(balance: balance,userid: id); 
          }));
        }
      },
      child: Container(
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.black, width: .3))),
          child: ListTile(
            title: Text(
              " ${text} ",
              style: TextStyle(color: Color(0xff444444), fontSize: 20),
            ),
            leading: Icon(
              icon,
              color: Color(0xff444444),
              size: 30,
            ),
          )),
    );
  }
}
