import 'package:flutter/material.dart';
import 'package:fooddelivery/component/alert.dart';
import 'package:fooddelivery/component/valid.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferMoney extends StatefulWidget {
  final balance  ; 
  final userid ; 
  TransferMoney({Key key , this.balance , this.userid}) : super(key: key);

  @override
  _TransferMoneyState createState() => _TransferMoneyState();
}

class _TransferMoneyState extends State<TransferMoney> {
  Crud crud = new Crud();
  var units;
  var phone;
 
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  transferMoney() async {
    var formdata = formstate.currentState;
    if (formdata.validate()){
      formdata.save();
      if (double.parse(widget.balance) < double.parse(units)) {
        showdialogall(context, "تنبيه"  , "رصيدك الحالي ${widget.balance} غير كافي ") ; 
      }else {
          Map data = {"phone": phone, "units": units, "userid": widget.userid};
      var responsbody = await crud.writeData("transfermoney", data);
      if (responsbody['status'] == "success") {
            SharedPreferences prefs =  await SharedPreferences.getInstance();
            List usersaftercheckout = await crud.readDataWhere("users", widget.userid);
                              prefs.setString(
                                "balance", usersaftercheckout[0]['user_balance'].toString() 
                              );
        Navigator.of(context).pushNamed("home");
      } else {
        showdialogall(context, "تنبيه", "هذا المستخدم غير موجود");
      }
      }
    }  
  }
 

  @override
  void initState() {
    super.initState();
     
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('تحويل الاموال'),
          ),
          body: WillPopScope(child: Form(
            autovalidate: true,
            key: formstate,
            child: Column(
              children: [
                buildTextForm("ادخل الرصيد الذي تريد تحويله",
                    Icon(Icons.monetization_on), "units"),
                buildTextForm("ادخل رقم الذي تريد التحويل له",
                    Icon(Icons.phone), "phone"),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () {
                    transferMoney();
                  },
                  color: Colors.blue,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: Text(
                      " تحويل ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ), onWillPop: (){
            Navigator.of(context).pushNamed("home") ; 
          }),
        ));
  }

  TextFormField buildTextForm(String label, Icon icons, [type]) {
    return TextFormField(
        onSaved: (val) {
          if (type == "units") {
            units = val;
          }
          if (type == "phone") {
            phone = val;
          }
        },
        validator: (val) {
          if (type == "units") {
            return validInput(val, 0, 6, "يكون تحويل الرصيد " , "number");
          }
          if (type == "phone") {
            return validInput(val, 0, 20, "يكون رقم الهاتف", "phone");
          }
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: icons));
  }
}
