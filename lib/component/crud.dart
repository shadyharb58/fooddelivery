import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'dart:io';

class Crud {
  // var server_name = "talabpay.com/api";
  var server_name = "10.0.2.2:8080/food";

  readData(String type) async {
    var url;
    if (type == "categories") {
      url = "http://${server_name}/categories/categories.php";
    }
    if (type == "restaurants") {
      url = "http://${server_name}/restaurants/restaurants.php";
    }
    if (type == "items") {
      url = "http://${server_name}/items/items.php";
    }
    if (type == "countall") {
      url = "http://${server_name}/countall.php";
    }
    if (type == "restaurantstopselling") {
      url = "http://${server_name}/restaurants/restaurantstopselling.php";
    }
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      var responsebody = jsonDecode(response.body);
      return responsebody;
    } else {
      print("page not found");
    }
  }

  readDataWhere(String type, String value) async {
    var url;
    var data;
    if (type == "restaurants") {
      url = "http://${server_name}/restaurants/restaurants.php";
      data = {"resapprove": value};
    }
    if (type == "settings") {
      url = "http://${server_name}/settings/settings.php";
      data = {"id": value};
    }
    if (type == "items") {
      url = "http://${server_name}/items/items.php";
      data = {"resid": value};
    }
    if (type == "users") {
      url = "http://${server_name}/users/users.php";
      data = {"userid": value};
    }
    if (type == "orders") {
      url = "http://${server_name}/orders/ordersusers.php";
      data = {"userid": value};
    }
    if (type == "orderdetails") {
      url = "http://${server_name}/orders/orders_details.php";
      data = {"orderid": value};
    } if (type == "searchcats") {
       url = "http://${server_name}/categories/searchcateories.php" ; 
       data  = {"search" : value} ; 
    } if (type == "searchrestaurants") {
       url = "http://${server_name}/restaurants/searchrestaurants.php" ; 
       data  = {"search" : value} ; 
    }
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      print(response.body);
      var responsebody = jsonDecode(response.body);
      return responsebody;
    } else {
      print("page not found");
    }
  }

  writeData(String type, var data) async {
    var url;

    if (type == "items") {
      url = "http://${server_name}/items/items.php";
    }
    if (type == "login") {
      url = "http://${server_name}/auth/login.php";
    }
    if (type == "signup") {
      url = "http://${server_name}/auth/signup.php";
    }
    if (type == "transfermoney") {
      url = "http://${server_name}/money/transfermoneyusers.php";
    }if (type == "searchitems") {
       url = "http://${server_name}/items/searchitems.php" ; 
    }
    print(data) ; 
    var response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      // print(response.body);
      var responsebody = jsonDecode(response.body);
      return responsebody;
    } else {
      print("page Not found");
    }
  }

  addOrders(String type, var data) async {
    var url = "http://${server_name}/orders/checkout.php";
    var response = await http.post(url, body: json.encode(data));
    if (response.statusCode == 200) {
      print(response.body);
      var responsebody = response.body;
      return responsebody;
    } else {
      print("page Not found");
    }
  }

  Future addUsers(email, password, username, phone, File imagefile) async {
    var stream = new http.ByteStream(imagefile.openRead());
    stream.cast();
    var length = await imagefile.length();
    var uri = Uri.parse("http://${server_name}/auth/signup.php");
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile("file", stream, length,
        filename: basename(imagefile.path));
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["username"] = username;
    request.fields["phone"] = phone;
    request.files.add(multipartFile);
    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);
    if (myrequest.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
  }

  Future editUsers(username, email, password, phone, id, bool issfile,
      [File imagefile]) async {
    var uri = Uri.parse("http://${server_name}/users/editusers.php");

    var request = new http.MultipartRequest("POST", uri);
    if (issfile == true) {
      var stream = new http.ByteStream(imagefile.openRead());
      stream.cast();
      var length = await imagefile.length();
      var multipartFile = new http.MultipartFile("file", stream, length,
          filename: basename(imagefile.path));
      request.files.add(multipartFile);
    }
    request.fields["username"] = username;
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["userid"] = id;
    request.fields["phone"] = phone;
    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);
    if (myrequest.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
  }
}
