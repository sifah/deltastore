import 'package:deltastore/api/api.dart';
import 'package:deltastore/config.dart';
import 'package:deltastore/menu/edit_employee.dart';
import 'package:flutter/cupertino.dart';

import 'main_order.dart';
import 'menu/menu_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {


  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          //title: Text('ตั้งค่า'),
          //centerTitle: true,
          backgroundColor: Color.fromRGBO(43, 108, 171, 1),
          toolbarHeight: 90,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(top: 15, left: 15),
            //centerTitle: true,
            title: userProfile(),
          ),
        ),
        body: MenuList(),
      ),
    );
  }
}

Container userProfile() {
  return Container(
      //margin: EdgeInsets.only(top: 10),
      width: double.maxFinite,
      height: double.maxFinite,
      child: Row(children: [
        FutureBuilder(
          future: FlutterSession().get('token'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              dynamic data = snapshot.data;
              return Row(children: [
                CircleAvatar(
                  radius: 37,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                      radius: 35.0,
                      backgroundImage:
                          NetworkImage('${data['data']['pro_file_url']}')),
                ),
                Container(
                    padding: EdgeInsets.only(top: 18, left: 10),
                    child: DefaultTextStyle(
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshot.hasData
                                ? data['data']['name'].toString()
                                : 'Loading..'),
                            Text(
                              snapshot.hasData
                                  ? data['data']['email'].toString()
                                  : 'Loading...',
                              style: TextStyle(fontSize: 14),
                            ),
                            Container(
                                width: 110,
                                height: 25,
                                margin: EdgeInsets.only(top: 5),
                                child: FlatButton(
                                    onPressed: () {
                                      print(token);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  EditEmployee(data: token['data'],)));
                                      print('แก้ไขข้อมูล');
                                    },
                                    color: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'แก้ไขข้อมูล',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        )
                                      ],
                                    )))
                          ],
                        )))
              ]);
            }
            return Padding(padding: EdgeInsets.zero);
          },
        ),
      ]));
}
