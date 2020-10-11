import 'package:flutter/material.dart';
import 'package:fooddelivery/crud.dart';
import 'package:fooddelivery/pages/categories.dart';
import 'package:fooddelivery/pages/home.dart';
import 'package:fooddelivery/pages/myinformation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  Crud crud = new Crud();

  Future getCategories() async {
    var responsebody = await crud.readData("categories");
    return responsebody;
  }

  Future getRestaurants() async {
    var responsebody = await crud.readData("restaurants");
    return responsebody;
  }

  int _pageIndex = 0;
  List<Widget> tabPages = [

    Home() , 
    Categories() , 
    MyInformation()
    
      
  ];

 

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void initState() {
  
    _pageController = PageController(initialPage: _pageIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
   
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _pageIndex,
            onTap: onTabTapped,
            backgroundColor: Theme.of(context).primaryColor,
            fixedColor: Colors.white,
            unselectedItemColor: Colors.black87,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text("الرئيسية")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), title: Text("الاقسام")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text("معلوماتي")),
            ]),
        body: PageView(
          children: tabPages,
          onPageChanged: onPageChanged,
          controller: _pageController,
        ),
      ),
    );
  }
 
} 