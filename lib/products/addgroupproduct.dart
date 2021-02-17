
import 'package:deltastore/api/api.dart';
import 'package:deltastore/api/group_product.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'edit_store_body.dart';

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

  Future _addProduct({GroupProduct groupProduct}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        // dialog is dismissible with a tap on the barrier
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'กลุ่มสินค้า',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: EditBody(
              groupProduct: groupProduct,
            ),
          );
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
                                            _addProduct(
                                                groupProduct:
                                                    snapshot.data[index]).whenComplete(() => loadGroup());
                                            print('edit');
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
                                            print('delete');
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
                return SpinKitCircle(
                  color: Colors.blue,
                );
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _addProduct().whenComplete(() => loadGroup());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
