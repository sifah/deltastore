
import 'dart:convert';

import 'package:deltastore/api/api.dart';
import 'package:deltastore/api/toJsonGroup_product.dart';
import 'package:deltastore/field/showMyToast.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../config.dart';
import '../main_order.dart';
import 'edit_group.dart';

class PageAddGroupProduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageAddGroupProduct();
}

class _PageAddGroupProduct extends State {
  Future group;

  void loadGroup() async {
    Future future = fetchGroupProduct();
    setState(() {
      group = future;
    });
  }

  Future _showGroupProduct({GroupProduct groupProduct}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        // dialog is dismissible with a tap on the barrier
        builder: (BuildContext context) {
          return  Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'กลุ่มสินค้า',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  content:  EditGroup(
                      groupProduct: groupProduct,
                    ),
                ),
            ),
          )
          ;
        });
  }

  Future alertRemove(String foodGroup) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            title: Text('ยืนยันการลบ'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ยกเลิก')),
              TextButton(
                  onPressed: () {
                    onRemove(foodGroup, context);
                  },
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
          );
        });
  }

  void onRemove(String groupId,BuildContext context) {
    String param = jsonEncode(<String, String>{
      'fg_id': groupId,
      'id_res_auto': token['data']['id_res_auto']
    });
    print(param);
    http.post('${Config.API_URL}delete_group', body: param).then((res) {
      print(res.body);
      if(res.body == '1'){
        Navigator.pop(context);
        showToastBottom(text: 'ลบสินค้าสำเร็จ');
        print('success');
      }else{
        showToastBottom(text: 'ลบไม่สำเร็จ');
        print('fail');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      group = fetchGroupProduct();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(bottom: 30),
          child: FutureBuilder(
              future: group,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      padding: EdgeInsets.only(bottom: 40),
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        GroupProduct groupProduct = snapshot.data[index];
                        return new Container(
                          height: 50,
                          width: double.maxFinite,
                          margin: EdgeInsets.only(top: 1),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey[50],
                                )
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${groupProduct.name}',
                                style: TextStyle(fontSize: 16),
                                maxLines: 1,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: SizedBox(
                                        height: 25,
                                        width: 40,
                                        child: RawMaterialButton(
                                          fillColor: Colors.amber,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: const Text(
                                            'แก้ไข',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            _showGroupProduct(
                                                groupProduct:
                                                    snapshot.data[index]).whenComplete(() => loadGroup());

                                            print('edit $index');
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: SizedBox(
                                        height: 25,
                                        width: 30,
                                        child: RawMaterialButton(
                                          fillColor: Colors.red[300],
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: const Text('ลบ',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white70)),
                                          onPressed: () {
                                            alertRemove(groupProduct.fgId).whenComplete(() => loadGroup());
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      });
                }
                return SpinKitFadingCircle(
                  color: Colors.blue,
                );
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showGroupProduct().whenComplete(() => loadGroup());
          showToastBottom(text: 'บันทึกสำเร็จ');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
