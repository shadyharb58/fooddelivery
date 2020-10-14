import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyInformation extends StatefulWidget {
  MyInformation({Key key}) : super(key: key);

  @override
  _MyInformationState createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> {
  var username, id, email;

  getCurrentUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    id = prefs.getString("id");
    email = prefs.getString("email");
    username = prefs.getString("username");
    setState(() {});
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

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: ListView(
            children: [
              Stack(children: <Widget>[
                buildTopRaduis(mdw),
                buildTopText(mdw),
                Container(
                  margin: EdgeInsets.only(top: 200),
                  child: Column(
                    children: [
                      buildListTile("حسابي", Icons.perm_identity),
                      buildListTile("الطلبات", Icons.directions_car , "myorders"),
                      buildListTile("الفواتير والدفعات", Icons.receipt),
                      buildListTile("الاعدادات", Icons.settings),
                      buildListTile(
                          "تسجيل الخروج", Icons.exit_to_app, "logout"),
                    ],
                  ),
                )
              ])
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
          Row(
            children: [
              CircleAvatar(
                maxRadius: 30,
                minRadius: 30,
                child: Text(
                  "N",
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
                      "N 11,500",
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
          Navigator.of(context).pushNamed("login");
        } else if (type == "myorders") {
          Navigator.of(context).pushNamed("myorders");
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
