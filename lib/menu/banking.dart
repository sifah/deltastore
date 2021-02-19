import 'package:deltastore/api/api_data.dart';
import 'package:deltastore/api/toJsonPayment.dart';
import 'package:deltastore/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'editBank.dart';

class BankMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BankMenu();
}

enum ConfirmAction { CANCEL, ACCEPT }

class _BankMenu extends State {
  String nameP, bankName, bankNum = '';

  Future listPayment;

  Future loadPayment() async {
    Future list = fetchPayment();
    setState(() {
      listPayment = list;
    });
  }

  Future _editBanking({Payments payments}) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        // dialog is dismissible with a tap on the barrier
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 1),
            title: Text(
              'การชำระเงิน',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: EditBank(
              payments: payments,
            ),
            //actions: [],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadPayment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ช่องทางการชำระเงิน'),
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.exit_to_app_outlined), onPressed: onLogOut)
        // ],
      ),
      body: FutureBuilder(
          future: listPayment,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SpinKitCircle(
                color: Colors.blue,
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, index) {
                Payments payments = snapshot.data[index];
                return Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(10),
                        ),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10)),
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: typePayment(
                                          data: snapshot.data[index])),
                                  Container(
                                    width: 125,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        FractionalTranslation(
                                          translation: Offset(0.3, -0.7),
                                          child: Card(
                                            //elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                            ),
                                            color: payments.status == '0'
                                                ? Colors.black12
                                                : Colors.green,
                                            child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    15, 5, 20, 1),
                                                child: Text(
                                                  payments.status == '0'
                                                      ? 'ซ่อน'
                                                      : 'แสดง',
                                                  style: TextStyle(fontWeight: FontWeight.bold,
                                                      color: Colors.white),
                                                )),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 5),
                                              child: SizedBox(
                                                height: 35,
                                                width: 60,
                                                child: RawMaterialButton(
                                                  fillColor: Colors.amber,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10))),
                                                  child: const Text(
                                                    'แก้ไข',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  onPressed: () {
                                                    _editBanking(
                                                        payments: snapshot.data[index]).whenComplete(() => loadPayment());
                                                  },
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: SizedBox(
                                                height: 35,
                                                width: 45,
                                                child: RawMaterialButton(
                                                  fillColor: Colors.red[300],
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10))),
                                                  child: const Text('ลบ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white)),
                                                  onPressed: () {
                                                    //alertRemove(index).whenComplete(() => loadDistance());
                                                    print('delete');
                                                  },
                                                ),
                                              ),
                                            )
                                            // Container(
                                            //   margin: EdgeInsets.only(right: 5),
                                            //   decoration: BoxDecoration(
                                            //       border: Border.all(
                                            //           color: Colors.red,
                                            //           width: 2),
                                            //       borderRadius:
                                            //           BorderRadius.all(
                                            //               Radius.circular(10))),
                                            //   child: SizedBox(
                                            //     height: 30,
                                            //     width: 35,
                                            //     child: RawMaterialButton(
                                            //       //fillColor: Colors.amber,
                                            //       shape: RoundedRectangleBorder(
                                            //         borderRadius:
                                            //             BorderRadius.all(
                                            //           Radius.circular(15),
                                            //         ),
                                            //       ),
                                            //       child: const Text(
                                            //         'ลบ',
                                            //         style: TextStyle(
                                            //             fontSize: 16,
                                            //             fontWeight:
                                            //                 FontWeight.bold,
                                            //             color: Colors.red),
                                            //       ),
                                            //       onPressed: () {
                                            //         print('delete');
                                            //       },
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _editBanking().whenComplete(() => loadPayment());
          print('เพิ่มข้อมูล');
        },
        child: Icon(Icons.add),
      ),
      // bottomNavigationBar: Container(
      //   height: 55,
      //   color: Colors.blue,
      //   child: TextButton(
      //     onPressed: (){
      //       _editBanking(context, '', '', '');
      //       print('เพิ่มข้อมูล');
      //     },
      //     child: Text('เพิ่ม',style: TextStyle(
      //         fontSize: 20,
      //         fontWeight: FontWeight.bold,
      //         color: Colors.white
      //     ),),
      //   ),
      // )
    );
  }

  Widget typePayment({Payments data}) {
    String textType, name, nameBank;
    switch (data.type) {
      case '1':
        {
          textType = 'บัญชีธนาคาร';
          name = data.type1Options.name;
          nameBank = data.type1Options.bank;
        }
        break;
      case '5':
        {
          textType = 'พร้อมเพย์';
          name = data.acountNumber;
          nameBank = data.acountName;
        }
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textType,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          name,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          nameBank,
          style: TextStyle(fontSize: 14),
        )
      ],
    );
  }
}
