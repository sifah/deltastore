import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:deltastore/config.dart';
import 'package:deltastore/api/api_data.dart';
import 'package:deltastore/api/toJsonPayment.dart';
import 'package:deltastore/field/showMyToast.dart';
import 'package:deltastore/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main_order.dart';
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

  Future<void> _alertPicQr(Payments payments) async {
    return showDialog(
        context: context,
        //barrierDismissible: false,
        barrierColor: Colors.black45,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              content: Container(
                child: Container(
                    width: 200,
                    child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(10),
                  ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                    payments.type2Options,fit: BoxFit.cover,
                  ),
                )),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ปิดออก')),
              ],
            ));
  }

  void onRemove(String payId, BuildContext context) {
    String param = jsonEncode(<String, String>{
      'id_pay_type': payId,
      'id_res_auto': token['data']['id_res_auto']
    });
    print(param);
    http.post('${Config.API_URL}delete_payment', body: param).then((res) {
      print(res.body);
      if (res.body == '1') {
        Navigator.pop(context);
        showToastBottom(text: 'ลบข้อมูล');
        print('success');
      } else {
        showToastBottom(text: 'ลบไม่สำเร็จ');
        print('fail');
      }
    });
  }

  Future _alertRemove(String paymentId) {
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
                    onRemove(paymentId, context);
                  },
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    loadPayment();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ช่องทางการชำระเงิน'),
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.exit_to_app_outlined), onPressed: onLogOut)
        // ],
      ),
      body: FutureBuilder(
          future: listPayment,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SpinKitFadingCircle(
                color: Colors.blue,
              );
            }
            return Container(
              padding: EdgeInsets.only(bottom: 40),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, index) {
                  Payments payments = snapshot.data[index];
                  return Container(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: payments.type2Options == ""
                              ? (){
                            print('aaa');
                          }
                              : () async {
                            _alertPicQr(snapshot.data[index]);
                            },
                          child: Card(
                            margin: EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAlias,
                            color: Colors.blueGrey[50],
                            child: Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: typePayment(
                                          data: snapshot.data[index])),
                                  Container(
                                    //width: 125,
                                    //height: 200,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        FractionalTranslation(
                                          translation: payments.type == '1'
                                              ? Offset(0.3, -1.14)
                                              : Offset(0.3, -0.76),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                              ),
                                              color: payments.status == '0'
                                                  ? Colors.black.withOpacity(0.3)
                                                  : Colors.green,
                                            ),
                                            child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    15, 3, 15, 3),
                                                child: Text(
                                                  payments.status == '0'
                                                      ? 'ซ่อน'
                                                      : 'แสดง',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
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
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: const Text(
                                                    'แก้ไข',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () {
                                                    _editBanking(
                                                            payments: snapshot
                                                                .data[index])
                                                        .whenComplete(
                                                            () => loadPayment());
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
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: const Text('ลบ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white)),
                                                  onPressed: () {
                                                    _alertRemove(
                                                            payments.idPayType)
                                                        .whenComplete(
                                                            () => loadPayment());
                                                    print('delete');
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _editBanking().whenComplete(() => loadPayment());
          print('เพิ่มข้อมูล');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget typePayment({Payments data}) {
    String textType, name, nameBank, numBank;
    switch (data.type) {
      case '1':
        {
          textType = 'บัญชีธนาคาร';
          name = data.type1Options.name;
          numBank = data.type1Options.number;
          nameBank = data.type1Options.bank;
        }
        break;
      case '5':
        {
          textType = 'พร้อมเพย์';
          name = data.acountName;
          numBank = data.acountNumber;
        }
        break;
    }
    return data.type == '5'
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textType,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                numBank,
                style: TextStyle(fontSize: 14),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textType,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                numBank,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                nameBank,
                style: TextStyle(fontSize: 14),
              )
            ],
          );
  }
}
