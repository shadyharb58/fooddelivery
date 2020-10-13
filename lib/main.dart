import 'package:flutter/material.dart';
import 'package:fooddelivery/pages/homescreen.dart';
import 'package:fooddelivery/pages/items/itemscat.dart';
import 'package:fooddelivery/pages/cart.dart';
import 'package:provider/provider.dart';

// Pages
import 'package:fooddelivery/pages/restaurant.dart';
import 'package:fooddelivery/component/addtocart.dart';
import 'package:fooddelivery/pages/test.dart';
import './pages/login.dart';
import './pages/home.dart';

 

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return AddToCart();
        })
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            // This is the theme of your application.
            // primarySwatch: Colors.blue,
            primaryColor: Color(0xffFE463D),
            textTheme: TextTheme(
              bodyText1: TextStyle(fontSize: 20),
              bodyText2: TextStyle(fontSize: 15),
            )),
        home: Login(),
        routes: {
          "login": (context) => Login(),
          "itemscat" : (context) => ItemsCat() , 
          "home": (context) => HomeScreen(),
          "restaurant": (context) => Restaurant(),
          "cart" : (context) => Cart()
        },
      ),
    );
  }
}
