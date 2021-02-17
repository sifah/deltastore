import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditData extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _EditData();

}

class _EditData extends State{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        title: Text('แก้ไข้ข้อมูลส่วนตัว'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(

      )
    );
  }
}