import 'package:deltastore/products/addgroupproduct.dart';
import 'package:deltastore/products/addproduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/material/popup_menu.dart';

class Product extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Product();
}

class _Product extends State<Product> {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      //backgroundColor: Colors.grey[200],
      length: 2,
      child: Scaffold(
          appBar: new AppBar(
            toolbarHeight: 55,
            bottom: TabBar(
              unselectedLabelStyle: TextStyle(fontFamily: 'Kanit'),
              unselectedLabelColor: Colors.grey[300],
              indicatorColor: Colors.blue,
              labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Kanit'),
              tabs: [
                Tab(text: "สินค้า"),
                Tab(text: "กลุ่มสินค้า"),
              ],
            ),
            backgroundColor: Color.fromRGBO(43, 108, 171, 1),
          ),
          body: TabBarView(
            children: [PageAddProduct(), PageAddGroupProduct()],
          )
        //
      ),
    );
  }
}
