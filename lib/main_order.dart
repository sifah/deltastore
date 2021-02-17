import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_thailand_provinces/flutter_thailand_provinces.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'history.dart';
import 'orders/order.dart';
import 'products/product.dart';
import 'setting.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';

//String id, code, appBar = '';
FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
int current = 0, past = 0;
DatabaseReference databaseDataPay, databaseOrders;
String id, code;
FToast fToast;
dynamic token;

class MyHomeApp extends StatelessWidget {
  // This widget is the root of your application.
  Future setFirebase() async {
    token = await FlutterSession().get('token');
    id = token['data']['id_res_auto'];
    code = token['data']['code'];

    databaseDataPay =
        firebaseDatabase.reference().child('${id}_${code}').child('data_pay');

    databaseOrders =
        firebaseDatabase.reference().child('${id}_${code}').child('orders');
  }

  @override
  Widget build(BuildContext context) {
    setFirebase();
    return MaterialApp(
      title: 'Delta Food',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Kanit',
      ),
      home: MyHomePage(),
      // darkTheme: ThemeData(
      //   accentColor: Color.fromRGBO(43, 108, 171, 1),
      //   brightness: Brightness.dark,
      // ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _children = [Order(), Product(), History(), Setting()];

  void loadProvince() async {
    await ThailandProvincesDatabase.init();
    print('load database Province'); // initialize database.
  }

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    loadProvince();
    super.initState();
    setState(() {
      MyHomeApp().setFirebase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          //barBackgroundColor: Color.fromRGBO(43, 108, 171, 1),
          selectedItemBorderColor: Colors.transparent,
          selectedItemBackgroundColor: Color.fromRGBO(90, 147, 204, 1),
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Color.fromRGBO(43, 108, 171, 1),
          unselectedItemIconColor: Colors.blueGrey[400],
          unselectedItemLabelColor: Colors.blueGrey[400],
          showSelectedItemShadow: false,
          barHeight: 55,
        ),
        selectedIndex: _selectedIndex,
        onSelectTab: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.calendar_today,
            label: 'ออร์เดอร์',
          ),
          FFNavigationBarItem(
            iconData: Icons.shopping_basket,
            label: 'สินค้า',
          ),
          FFNavigationBarItem(
            iconData: Icons.history,
            label: 'ประวัติ',
          ),
          FFNavigationBarItem(
            iconData: Icons.settings,
            label: 'ตั้งค่า',
          ),
        ],
      ),
    );
  }
}
