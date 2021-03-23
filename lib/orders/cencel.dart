import 'dart:convert';
import 'dart:math';

import 'package:deltastore/api/reasonOrder_api.dart';
import 'package:deltastore/api/toJsonReason.dart';
import 'package:deltastore/main_order.dart';
import 'package:deltastore/orders/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import 'detailOrder.dart';


class CancelBody extends StatefulWidget {
  String orderId;

  CancelBody(this.orderId);

  @override
  _CancelBodyState createState() => _CancelBodyState(orderId);
}

class _CancelBodyState extends State<CancelBody> {
  // List<Reason> listReason = new List();
  String orderId;

  _CancelBodyState(this.orderId);

  //_CancelBodyState(this.listReason);

  var numRandom = new Random();
  String _reasonID;
  TextEditingController _reasonText = new TextEditingController();

  void _handleRadioValueChanged(value) {
    setState(() {
      _reasonID = value;
      print('ok ${_reasonID.toString()}');
    });
  }

  void addReason(String idStore, String adminId) {
    String params = jsonEncode(<String, String>{
      'title': _reasonText.text,
      'id_res_auto': idStore,
      'admin_id': adminId
    });

    http.post('${Config.API_URL}add_reason_order', body: params).then((res) {
      print(res.body);
      if (res.body == '1') {
        loadData();
        Fluttertoast.showToast(
            msg: 'เพิ่มข้อมูลสำเร็จ',
            backgroundColor: Colors.black87,
            textColor: Colors.white);
        _reasonText.clear();
        loadData();
      } else {
        Fluttertoast.showToast(
            msg: 'เพิ่มข้อมูลไม่สำเร็จ',
            backgroundColor: Colors.black87,
            textColor: Colors.white);
      }
    });
  }

  Future<void> _alertConfirmRemove(String reasonId) async {
    return showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
                title: new Text(
                  'ยืนยันการลบ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                // content: new Text(
                //   'คุณไม่สามารถยกเลิกออเดอร์ได้',
                //   style: TextStyle(color: Colors.black45),
                // ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('ปิดออก')),
                  TextButton(
                      onPressed: () {
                        removeReason(reasonId);
                      },
                      child: Text('ยืนยัน'))
                ],
              ),
        );
  }

  Future cancelOrder(String orderID, String adminID) async {
    String params = jsonEncode(<String, String>{
      'reason_id': _reasonID,
      'order_id': orderID,
      'admin_id': adminID
    });
    print(params);
    http.post('${Config.API_URL}cancel_order', body: params).then((res) {
      print(res.body);

      if (res.body == '1') {
        databaseDataPay.set(numRandom.nextInt(100));
        setState(() {
          changeOut = '1';
        });
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: 'ยกเลิกออร์เดอร์สำเร็จ',
            backgroundColor: Colors.black87,
            gravity: ToastGravity.CENTER,
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg: 'ยกเลิกออร์เดอร์ไม่สำเร็จ',
            textColor: Colors.white,
            backgroundColor: Colors.black87);
      }
    });
  }

  void removeReason(String reasonID) {
    print(reasonID);
    //print('${Config.API_URL}remove_reason');
    String params = jsonEncode(<String, String>{"reason_id": "$reasonID"});
    http.post('${Config.API_URL}remove_reason', body: params).then((res) {
      print(res.body);
      if (res.body == '1') {
        Fluttertoast.showToast(
            msg: 'ลบข้อมูลสำเร็จ',
            backgroundColor: Colors.black87,
            textColor: Colors.white);
        loadData();
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: 'ลบข้อมูลไม่สำเร็จ',
            backgroundColor: Colors.black87,
            textColor: Colors.white);
      }
    });
  }

  Future loadData() async {
    List<Reason> list = await fetchReason();
    print('load Data22  ${listReason.length}');

    setState(() {
      listReason = list;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(listReason.length);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10))),
      padding: EdgeInsets.only(top: 10),
      height: 400,
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(bottom: 120),
                child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: listReason
                  .map((reason) => InkWell(
                        onLongPress: () {
                          _alertConfirmRemove(reason.reasonId);
                          print('remove  ${reason.reasonId}');
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: reason.reasonId,
                              groupValue: _reasonID,
                              onChanged: _handleRadioValueChanged,
                              activeColor: Colors.blueAccent,
                            ),
                            Text('${reason.title}'),
                          ], //mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ))
                  .toList(),
            ),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //clipBehavior: Clip.antiAlias,
                  color: Color.alphaBlend(
                      Colors.black.withOpacity(0.1), Colors.white),
                  padding: EdgeInsets.only(right: 5),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          onChanged: (value) {},
                          minLines: 1,
                          maxLines: 5,
                          controller: _reasonText,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              hintText: 'กรอกเหตุผล....'),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.black12,
                        radius: 30,
                        focusColor: Colors.black12,
                        hoverColor: Colors.black12,
                        highlightColor: Colors.black12,
                        onTap: () async {
                          dynamic token = await FlutterSession().get('token');
                          String idStore = token['data']['id_res_auto'];
                          String adminId = token['data']['admin_id'];
                          addReason(idStore, adminId);
                          print(listReason.length);
                          print('add reason');
                        },
                        child: Icon(Icons.arrow_upward),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: ButtonBar(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('ปิดออก')),
                      TextButton(
                          onPressed: () async {
                            dynamic token = await FlutterSession().get('token');
                            cancelOrder(orderId, token['data']['admin_id']);
                          },
                          child: Text('ปฏิเสธ')),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
