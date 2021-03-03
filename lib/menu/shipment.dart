import 'dart:async';
import 'dart:convert';

import 'package:deltastore/api/api_data.dart';
import 'package:deltastore/api/toJsonDistance.dart';
import 'package:deltastore/config.dart';
import 'package:deltastore/field/showMyToast.dart';
import 'package:deltastore/main_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Shipment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Shipment();
}

class _Shipment extends State {
  final _distance = TextEditingController();
  final _shippingCost = TextEditingController();
  String idRes = token['data']['id_res_auto'];
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String distanceValue;
  Future listDistance;
  int selectValue, checkAlert;
  bool bank, home, alert;
  List listDatum;

  Future loadDistance() async {
    var list = fetchDistance();
    var res = await fetchDistance();
    // Before calling setState check if the state is mounted.
    // เมื่อ State ถูกจัดการด้วย BuildContext State จะมีสถานะที่เรียกว่า mounted
    if (mounted) {
      setState(() {
        listDistance = list;
        home = res.destination;
        bank = res.transfer;
        listDatum = res.data;
        alert = false;
      });
    } else {
      return;
    }
    print(listDatum.length);
  }

  Future onSubmit() async {
    if (_formKey.currentState.validate()) {
      listDatum.add(Datum.fromJson({
        "number": int.parse(_distance.text),
        "price": int.parse(_shippingCost.text)
      }));
      onSaveDistance(idRes);
    }
  }

  Future onSaveDistance(String idRes, {int index}) async {
    //print(Datum.fromJson({"number": 1, "price": 1}).toJson());
    var success;
    if (index != null) {
      listDatum.removeAt(index);
    }

    listDatum.sort((a, b) => a.number.compareTo(b.number));

    FocusScope.of(context).requestFocus(new FocusNode());
    var sendOption = {
      'data': listDatum.toList(),
      'destination': bank,
      'transfer': home
    };
    String params = jsonEncode(
        <String, dynamic>{'id_res_auto': idRes, 'send_options': sendOption});

    print(params);

    final res =
        await http.post('${Config.API_URL}update_send_options', body: params);
    print(res.body);
    if (res.body == '1') {
      setState(() {
        alert = true;
        checkAlert = 1;
      });
      showToastBottom(text: 'บันทึกข้อมูลสำเร็จ');
      _shippingCost.clear();
      _distance.clear();
    } else {
      showToastBottom(text: 'บันทึกข้อมูลไม่สำเร็จ');
      //Navigator.of(context).pop();
    }
  }

  Future alertRemove(int index) {
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
                    onSaveDistance(idRes, index: index);
                    Navigator.of(context).pop();
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
    loadDistance();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    loadDistance();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('การจัดส่ง'),
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.exit_to_app_outlined), onPressed: onLogOut)
        // ],
        bottom: PreferredSize(
          preferredSize: Size(50, 50),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: [
                  Checkbox(
                    onChanged: (bool value) {
                      setState(() {
                        bank = value;
                        onSaveDistance(idRes);
                      });
                    },
                    value: bank == null ? false : bank,
                  ),
                  Text('โอนเข้าบัญชี'),
                ]),
                Row(children: [
                  Checkbox(
                    onChanged: (bool value) {
                      setState(() {
                        home = value;
                        onSaveDistance(idRes);
                      });
                    },
                    value: home == null ? false : home,
                  ),
                  Text('เก็บเงินปลายทาง'),
                ]),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: listDistance,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Distance distance = snapshot.data;
            List listData = distance.data;
            return Container(
              padding: EdgeInsets.all(5),
              child: ListView.builder(
                  itemCount: listData.length + 1,
                  itemBuilder: (BuildContext context, index) {
                    if (index < listData.length) {
                      Datum datum = listData[index];
                      if (index == 0) {
                        return cardPrice(
                            text: 'ตั้งแต่ 0 - ${datum.number}  กม.',
                            price: '${datum.price}',
                            index: index);
                      }
                      Datum before = listData[index - 1];
                      return cardPrice(
                          text:
                              'มากกว่า ${before.number} - ${datum.number}  กม.',
                          price: '${datum.price}',
                          index: index);
                    }
                    Datum last = listData[listData.length - 1];
                    return cardPrice(
                        text: 'มากกว่า ${last.number} กม เป็นต้นไป');
                  }),
            );
          }

          return SpinKitFadingCircle(
            color: Colors.blue,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('เพิ่มข้อมูล');
          _asyncInputDialog().whenComplete(() => loadDistance());
        },
        child: Icon(Icons.add),
      ),
      // bottomNavigationBar: Container(
      //   height: 55,
      //   color: Colors.green,
      //   child: TextButton(
      //     onPressed: () {
      //       print('บัททึก');
      //     },
      //     child: Text(
      //       'บันทึก',
      //       style: TextStyle(
      //           fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      //     ),
      //   ),
      // ),
    );
  }

  Future _asyncInputDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        // dialog is dismissible with a tap on the barrier
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'เพิ่มระยะทาง',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Form(
              key: _formKey,
              child: Container(
                //width: 230,
                //height: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      controller: _distance,
                      decoration: new InputDecoration(
                          hintText: 'ระยะทางน้อยกว่า',
                          hintStyle: TextStyle(fontSize: 14)),
                      // onChanged: (value) {
                      //   distance = value;
                      // },
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'กรอกระยะทาง';
                        }
                        return null;
                      },
                    ),
                    new TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      controller: _shippingCost,
                      decoration: new InputDecoration(
                          hintText: 'ค่าจัดส่ง',
                          hintStyle: TextStyle(fontSize: 14)),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'กรอกค่าจัดส่ง';
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
            ),
            actions: [
              FlatButton(
                child: Text('ยกเลิก'),
                //color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'บันทึก',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                //color: Colors.blue,
                onPressed: () {
                  onSubmit().then((value) {
                    if (_formKey.currentState.validate()) {
                      Timer(Duration(seconds: 2), () {
                        Navigator.of(context).pop();
                      });
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  Widget cardPrice({String text, String price = '', @required int index}) {
    return Container(
      padding: EdgeInsets.all(5),
      height: 85,
      width: double.maxFinite,
      child: Card(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${text}'),
                    price.isEmpty
                        ? Text('ไม่จัดส่ง')
                        : Text('ราคา  $price  บาท')
                  ],
                ),
              ),
              price.isEmpty
                  ? Container()
                  : Container(
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
                      alertRemove(index).whenComplete(() => loadDistance());
                      print('delete');
                    },
                  ),
                ),
              )
              // Container(
              //         height: 35,
              //         width: 45,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.all(Radius.circular(5)),
              //           border: Border.all(color: Colors.red),
              //         ),
              //         child: TextButton(
              //           onPressed: () {
              //             alertRemove(index).whenComplete(() => loadDistance());
              //             print('ลบ');
              //           },
              //           child: Text(
              //             'ลบ',
              //             style: TextStyle(
              //                 fontWeight: FontWeight.bold, color: Colors.red),
              //           ),
              //         ),
              //       )
            ],
          ),
        ),
        elevation: 2,
      ),
    );
  }
}

//Column(
//children: [
// DropdownButtonFormField(
//   decoration: InputDecoration(
//       labelText: 'รูปแบบการจัดส่ง',
//       labelStyle: TextStyle(color: Colors.black),
//       contentPadding: EdgeInsets.all(10)),
//   value: distanceValue,
//   validator: (value) =>
//   value == null ? 'กรุณาเลือกรูปแบบระยะทาง' : null,
//   onChanged: (String newValue) {
//     // This set state is trowing an error
//     setState(() {
//       distanceValue = newValue;
//     });
//   },
//   items: <String>[
//     'ตามระยะทาง',
//     'ตามจำนวน',
//     'ตามราคารวม',
//   ].map<DropdownMenuItem<String>>((String value) {
//     return DropdownMenuItem<String>(
//       value: value,
//       child: new Text(value),
//       onTap: () {},
//     );
//   }).toList(),
// ),

// Container(
//   padding: EdgeInsets.all(5),
//   height: 75,
//   width: double.maxFinite,
//   child: Card(
//     child: Container(
//       padding: EdgeInsets.only(left: 10, right: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text('มากกว่าระยะทาง'),
//           Container(
//             height: 35,
//             width: 45,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(5)),
//               border: Border.all(color: Colors.red),
//             ),
//             child: TextButton(
//               onPressed: () {
//                 print('ลบ');
//               },
//               child: Text(
//                 'ลบ',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.red),
//               ),
//             ),
//           )
//         ],
//       ),
//       //child: ค่าระยะทางที่รับมา>ค่าแรก ? Text(' ${ระยะทาง} กม. หรือน้อยกว่า ${ราคา} บาท')
//       //: Text('มากกว่า ${ระยะทาง} - ${ระยะทาง} กม. ${ราคา} บาท')
//     ),
//     elevation: 2,
//   ),
// ),
//   RaisedButton(
//     onPressed: () async {
//       final String addDistance =
//           await _asyncInputDialog(context);
//     },
//     color: Colors.blue,
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadiusDirectional.circular(5)),
//     child: Text(
//       'เพิ่ม',
//       style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.white),
//     ),
//   )
// ],
// ),
