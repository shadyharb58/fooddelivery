import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fooddelivery/pages/editaccount.dart';
import 'package:fooddelivery/pages/homescreen.dart';
import 'package:fooddelivery/pages/items/itemscat.dart';
import 'package:fooddelivery/pages/myinformation.dart';
import 'package:fooddelivery/pages/orders/cart.dart';
import 'package:fooddelivery/pages/orders/myorders.dart';
import 'package:fooddelivery/pages/resetpassword/resetpassword.dart';
import 'package:provider/provider.dart';

// Pages
import 'package:fooddelivery/pages/restaurants/restaurant.dart';
import 'package:fooddelivery/component/addtocart.dart';

import './pages/login.dart';
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
        ..maxConnectionsPerHost = 5;
  }
}
void main(){ 
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return AddToCart();
        })
      ],
      child: MaterialApp(
        
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
          
        theme: ThemeData(
          fontFamily: 'Cairo' , 
    
            primaryColor: Color(0xffFE463D),
            textTheme: TextTheme(
              headline1: TextStyle(fontSize:10 , color: Colors.red),
              headline2: TextStyle(fontSize:20 , color: Colors.red , fontWeight: FontWeight.w600),
              headline3: TextStyle(fontSize:23 , color: Colors.red , fontWeight: FontWeight.w600),
              bodyText1: TextStyle(fontSize: 20),
             
              bodyText2: TextStyle(fontSize: 13),
            )
            ),
        home: Login(),
        routes: {
          "login": (context) => Login(),
          "itemscat": (context) => ItemsCat(),
          "home": (context) => HomeScreen(),
          "restaurant": (context) => Restaurant(),
          "cart": (context) => Cart(),
          "myorders": (context) => MyOrders() , 
          "myinformation" : (context) => MyInformation() , 
          "editaccount"  :(context) => EditAccount() ,
          "resetpassword" : (context) => ResetPassword()  , 
        },
      ),
    );
  }
}
