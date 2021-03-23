import 'dart:convert';

import 'package:commons/commons.dart';
import 'package:deltastore/api/toJsonGroup_product.dart';
import 'package:deltastore/products/addgroupproduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../main_order.dart';

class EditGroup extends StatefulWidget {
  final GroupProduct groupProduct;

  const EditGroup({Key key, this.groupProduct}) : super(key: key);

  @override
  _EditGroupState createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {
  final _groupName = TextEditingController();
  List<String> _listStatus = ['หมด', 'ซ่อน', 'แสดง'];
  String selectValue, dropDownValue;
  String groupId = '0';
  int indexStatus;

  void onSubmit({String idRes, String groupID}) {
    FocusScope.of(context).requestFocus(new FocusNode());
    String params = jsonEncode(<String, String>{
      'group_id': groupID,
      'id_res_auto': idRes,
      'name': _groupName.text,
      'status': selectValue,
    });

    print(params);

    http.post('${Config.API_URL}edit_group', body: params).then((res) {
      print(res.body);

      if (res.body == '1') {
        Navigator.pop(context);
        print('success');
      } else {
        print('fail');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.groupProduct != null) {
      _groupName.text = widget.groupProduct.name;
      // selectValue = widget.groupProduct.status;
      groupId = widget.groupProduct.fgId;
      indexStatus = int.parse(widget.groupProduct.status);
      selectValue = widget.groupProduct.status;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(selectValue);
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 1),
            child: Column(
              children: [
                new TextField(
                  autofocus: true,
                  controller: _groupName,
                  decoration: new InputDecoration(
                      hintText: 'ชื่อกลุ่มสินค้า',
                      hintStyle: TextStyle(fontSize: 14)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text('สถานะ')),
                      DropdownButton(
                        hint:  Text('เลือกสถานะ'),
                        value: dropDownValue,
                        items: _listStatus.map((value) {
                          return DropdownMenuItem(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            dropDownValue = newValue;
                            selectValue = '${_listStatus.indexOf(newValue)}';
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          ButtonBar(
            mainAxisSize: MainAxisSize.max,
            alignment: MainAxisAlignment.end,
            buttonMinWidth: 10,
            children: [
              FlatButton(
                //color: Colors.green,
                child: Text('ปิดออก'),
                //color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                //color: Colors.red,
                child: Text(
                  'บันทึก',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                //color: Colors.blue,
                onPressed: () {
                  onSubmit(idRes: token['data']['id_res_auto'], groupID: groupId);
                },
              ),
            ],
          )
        ]);
  }
}
