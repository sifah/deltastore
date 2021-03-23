import 'dart:convert';

import 'package:deltastore/config.dart';
import 'package:deltastore/main.dart';
import 'package:deltastore/main_order.dart';
import 'package:deltastore/menu/banking.dart';
import 'package:deltastore/menu/change_location.dart';
import 'package:deltastore/menu/changpass.dart';
import 'package:deltastore/menu/employee.dart';
import 'package:deltastore/menu/shipment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;

import 'editstore.dart';

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  String url = 'http://delivery.deltafood.co/deltafood';

  void onShare(BuildContext context, String url) {
    final RenderBox box = context.findRenderObject();
    final String text = url;

    Share.share(text,
        subject: url,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void onLocation() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new ChangeLocation()));
  }

  void onLogout() {
    String params = jsonEncode(<String, dynamic>{
      'uuid': deviceData['uuid'],
      'admin_id': token['data']['admin_id']
    });
    print(params);

    http.post('${Config.API_URL}logout',body: params).then((value) {
      print(value.body);
      if(value.body == '1'){
        FlutterSession().set('token', '');
        Navigator.of(context).pop();
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) => new MyApp()));
      }
    });


  }

  void onEditStore() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new EditStore()));
  }

  void onShipment() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new Shipment()));
  }

  void onBanking() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new BankMenu()));
  }

  // void onChangPass(){
  //   Navigator.push(context,
  //       new MaterialPageRoute(builder: (BuildContext context) => new ChangPass()));
  // }

  void onEmployee() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new Employee()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: TextStyle(fontSize: 10, color: Colors.red),
        child: ListView(
          children: [
            urlList(),
            editFood(function: onEditStore),
            location(function: onLocation),
            send(function: onShipment),
            credit(function: onBanking),
            //changePassword(function: onChangPass),
            employee(function: onEmployee),
            logout(function: onLogout)
          ],
        ));
  }

  Container urlList() {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
        BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: -3)
      ]),
      child: Card(
        child: InkWell(
          onTap: () => onShare(context, url),
          child: ListTile(
            leading: Icon(Icons.language),
            title: Text('$url'),
          ),
        ),
      ),
    );
  }
}

Container editFood({Function function}) {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
      BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: -3)
    ]),
    child: Card(
      child: InkWell(
        onTap: function,
        child: ListTile(
          leading: Icon(
            Icons.restaurant,
          ),
          title: Text(
            'แก้ไขข้อมูลร้าน',
          ),
        ),
      ),
    ),
  );
}

Container location({Function function}) {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
      BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: -3)
    ]),
    child: Card(
      child: InkWell(
        onTap: function,
        child: ListTile(
          leading: Icon(
            Icons.location_pin,
          ),
          title: Text('สถานที่ตั้งร้าน'),
        ),
      ),
    ),
  );
}

Container send({Function function}) {
  return Container(
      decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
        BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: -3)
      ]),
      child: Card(
        child: InkWell(
          onTap: function,
          child: ListTile(
            leading: Icon(
              Icons.delivery_dining,
            ),
            title: Text('การจัดส่ง'),
          ),
        ),
      ));
}

Container credit({Function function}) {
  return Container(
      decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
        BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: -3)
      ]),
      child: Card(
        child: InkWell(
          onTap: function,
          child: ListTile(
            leading: Icon(
              Icons.payments,
            ),
            title: Text('การชำระเงิน'),
          ),
        ),
      ));
}

Container changePassword({Function function}) {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
      BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: -3)
    ]),
    child: Card(
      child: InkWell(
        onTap: function,
        child: ListTile(
          leading: Icon(
            Icons.lock_outline_rounded,
          ),
          title: Text('เปลี่ยนรหัส'),
        ),
      ),
    ),
  );
}

Container employee({Function function}) {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
      BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: -3)
    ]),
    child: Card(
      child: InkWell(
        onTap: function,
        child: ListTile(
          leading: Icon(
            Icons.group,
          ),
          title: Text(
            'พนักงาน',
          ),
        ),
      ),
    ),
  );
}

Container logout({Function function}) {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
      BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: -3)
    ]),
    child: Card(
      child: InkWell(
        onTap: function,
        child: ListTile(
          leading: Icon(
            Icons.logout,
          ),
          title: Text('ออกจากระบบ'),
        ),
      ),
    ),
  );
}
