import 'dart:convert';
import 'dart:math';
import 'package:deltastore/api/toJsonReason.dart';
import 'package:deltastore/api/order_api.dart';
import 'package:deltastore/api/reasonOrder_api.dart';
import 'package:deltastore/api/toJsonDetailOrders.dart';
import 'package:deltastore/api/toJsonOrder.dart';
import 'package:deltastore/config.dart';
import 'package:deltastore/main_order.dart';
import 'package:deltastore/orders/cencel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'html.dart';

List<Reason> listReason;
String changeOut;

class DetailOrder extends StatefulWidget {
  final Orders data;

  DetailOrder(this.data);

  @override
  _DetailOrder createState() => _DetailOrder(data);
}

class _DetailOrder extends State<DetailOrder> {
  Orders data;

  _DetailOrder(this.data);

  int click = 0;
  int count = 0;
  var numRandom = new Random();

  void confirmOrders(String orderID, String adminID) {
    String params =
        jsonEncode(<String, String>{'order_id': orderID, 'admin_id': adminID});
    http.post('${Config.API_URL}confirm_order', body: params).then((res) {
      print(res.body);
      if (res.body == '1') {
        databaseOrders
            .reference()
            .child("$orderID")
            .set(numRandom.nextInt(100));
        databaseDataPay.set(numRandom.nextInt(100));
        databaseSendRider.set(numRandom.nextInt(100));
        databaseNotifyRider.set("$orderID");
        Fluttertoast.showToast(
            msg: 'ยืนยันแล้ว',
            textColor: Colors.white,
            backgroundColor: Colors.black87);
        Navigator.pop(context, 'ยืนยันแล้ว');
      }
    });
  }

  void sendOrders(String orderID, String adminID) {
    String params =
        jsonEncode(<String, String>{'order_id': orderID, 'admin_id': adminID});
    http.post('${Config.API_URL}send_order', body: params).then((res) {
      print(res.body);
      if (res.body == '1') {
        databaseOrders
            .reference()
            .child("$orderID")
            .set(numRandom.nextInt(100));
        databaseDataPay.set(numRandom.nextInt(100));
        databaseSendRider.set(numRandom.nextInt(100));
        databaseNotifyRider.set("$orderID");
        Fluttertoast.showToast(
            msg: 'ยืนยันแล้ว',
            textColor: Colors.white,
            backgroundColor: Colors.black87);
        Navigator.pop(context, 'ยืนยันแล้ว');
      }
    });
  }

  Future<void> _alertConfirm(orderId) async {
    return showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) => Center(
          child: SingleChildScrollView(
                child: AlertDialog(
                  title: new Text(
                    'ยืนยันออเดอร์',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  content: new Text(
                    'คุณไม่สามารถยกเลิกออเดอร์ได้',
                    style: TextStyle(color: Colors.black45),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('ปิดออก')),
                    TextButton(
                        onPressed: () async {
                          dynamic token = await FlutterSession().get('token');
                          confirmOrders(orderId, token['data']['admin_id']);
                          Navigator.pop(context);
                        },
                        child: Text('ยืนยัน'))
                  ],
                ),
              ),
        ));
  }

  Future<void> _alertPicPayment(DetailOrders ordersPay) async {
    return showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) => Center(
          child: SingleChildScrollView(
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  content: Container(
                    child: Image.network(data.slip['img_url']),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('ปิดออก')),
                  ],
                ),
              ),
        ));
  }

  Future<void> _alertSend(orderId) async {
    return showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) => Center(
          child: SingleChildScrollView(
            child: AlertDialog(
                  // title: new Text(
                  //   'ยืนยันออเดอร์',
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  content: new Text(
                    'ทำอาหารเสร็จแล้วใช่หรือไม่?',
                    style: TextStyle(color: Colors.black45),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('ไม่ใช่')),
                    TextButton(
                        onPressed: () async {
                          dynamic token = await FlutterSession().get('token');
                          sendOrders(orderId, token['data']['admin_id']);
                          Navigator.pop(context);
                        },
                        child: Text('ใช่'))
                  ],
                ),
          ),
        ));
  }

  Future _alertCanCle(orderId) async {
    listReason = await fetchReason();
    //print('reason_id ${listReason.length}');
    return showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) => 
            SingleChildScrollView(
                child: AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  title: new Text(
                    'ยืนยันยกเลิกออเดอร์',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
                  content: CancelBody(orderId),
            )));
  }

  // @override
  // void initState() {
  //   loadData();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        title: Text(
          'Order ID: ${data.orderIdRes}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: fetchDetailOrders(data.orderId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DetailOrders detailOrders = snapshot.data;
            List<Item> item = detailOrders.items;

            return SingleChildScrollView(
              child: Container(
                // height: double.maxFinite,
                // width: double.maxFinite,
                //color: Colors.blueGrey[50],

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'Kanit'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      NetworkImage(data.member.picUrl),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    '${data.member.mmName}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                                flex: -1,
                                child: const Divider(
                                  color: Colors.black12,
                                  height: 20,
                                  thickness: 1,
                                )),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                    //alignment: Alignment.centerLeft,
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'จัดส่ง: ${data.address.distance}'
                                      '  ${data.address.duration}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      maxLines: 1,
                                    ),
                                    data.comment == null
                                        ? Padding(padding: EdgeInsets.zero)
                                        : Text(
                                            '${data.comment}',
                                            maxLines: 1,
                                          ),
                                    Text(
                                      '${data.address.address}',
                                      //maxLines: 2,
                                      overflow: click == 1
                                          ? null
                                          : TextOverflow.ellipsis,
                                    ),
                                  ],
                                )),
                                InkWell(
                                  onTap: () {
                                    if (count == 0) {
                                      setState(() {
                                        click = 1;
                                        count++;
                                      });
                                    } else {
                                      setState(() {
                                        count = 0;
                                        click = 0;
                                      });
                                    }
                                  },
                                  child: Icon(Icons.add),
                                ),
                              ],
                            ),
                            Expanded(
                                flex: -1,
                                child: const Divider(
                                  color: Colors.black12,
                                  height: 20,
                                  thickness: 1,
                                )),
                            Row(
                              children: [
                                Text(
                                  'ช้อนส้อม:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      color: data.memberGiveaway == '0'
                                          ? Colors.blueGrey
                                          : Colors.green[400]),
                                  child: Text(
                                    data.memberGiveaway == '0'
                                        ? 'ไม่รับช้อนส้อม'
                                        : 'รับช้อนซ่อม',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                                flex: -1,
                                child: const Divider(
                                  color: Colors.black12,
                                  height: 20,
                                  thickness: 1,
                                )),
                            Row(
                              children: [
                                Text(
                                  'สถานะ:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                data.status == '2'
                                    ? Container(
                                        margin: EdgeInsets.only(left: 10),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.green),
                                        child: Text(
                                          'ยืนยันแล้ว',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      )
                                    : data.status == '3'
                                        ? Container(
                                            margin: EdgeInsets.only(left: 10),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: Colors.blueGrey),
                                            child: Text(
                                              'ยังไม่ยืนยัน',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : data.status == '4'
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.green),
                                                child: Text(
                                                  'กำลังจัดส่ง',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              )
                                            : Padding(padding: EdgeInsets.zero)
                              ],
                            ),
                            Expanded(
                                flex: -1,
                                child: const Divider(
                                  color: Colors.black12,
                                  height: 20,
                                  thickness: 1,
                                )),
                            Container(
                              //padding: EdgeInsets.only(top: 10),
                              height: 50,
                              //width: double.maxFinite,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: data.paymentType == '0'
                                      ? Colors.red[400]
                                      : Colors.amber[400]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data.paymentType == '0'
                                        ? 'ชำระเงินปลายทาง'
                                        : 'โอนเงินแล้ว',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            data.paymentType == "0"
                                ? Padding(padding: EdgeInsets.zero)
                                : Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height:
                                          MediaQuery.of(context).size.width -
                                              150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        // color: Colors.blueGrey[50]
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          _alertPicPayment(snapshot.data);
                                          print('ggg');
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          clipBehavior: Clip.antiAlias,
                                          child: Image(
                                            image: NetworkImage(
                                                data.slip['img_url']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.blueGrey[100],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(0, 3),
                                    )
                                  ]),
                              child: Container(
                                  //color: Colors.green[300],
                                  alignment: Alignment.center,
                                  //padding: EdgeInsets.all(10),
                                  child: Column(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        //height: 200,
                                        //width: 500,
                                        padding: EdgeInsets.all(10),
                                        //color: Colors.white24,
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: item.length,
                                            shrinkWrap: true,
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              Item dataItem = item[index];
                                              // Topping topping = dataItem.toppings as Topping;
                                              String _comment =
                                                  dataItem.comments;
                                              // int _price = int.parse(dataItem.price) ;
                                              //  String _count = dataItem.count;
                                              //  String sum = _count*_price;
                                              return DefaultTextStyle(
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Kanit',
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                            fit: FlexFit.tight,
                                                            child: Text(
                                                              'x${dataItem.count}   ${dataItem.name.th}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )),
                                                        Text(
                                                            '${dataItem.price} บาท'),
                                                      ],
                                                    ),
                                                    Container(
                                                      //padding: EdgeInsets.only(left: 30),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            child: Column(),
                                                          ),
                                                          dataItem.html.isEmpty
                                                              ? Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                )
                                                              : HtmlDetail(
                                                                  dataItem),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 30),
                                                            child: Row(
                                                              children: [
                                                                _comment.isEmpty
                                                                    ? Padding(
                                                                        padding:
                                                                            EdgeInsets.zero)
                                                                    : Text(
                                                                        '${dataItem.comments}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14),
                                                                      ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 0,
                                                        child: const Divider(
                                                          color: Colors.white54,
                                                          thickness: 1,
                                                        )),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      DefaultTextStyle(
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 17,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w600),
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 5, 5, 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('ค่าอาหารรวม :  '),
                                                      Text(
                                                          '${data.priceFood} บาท '),
                                                    ]),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('ค่าจัดส่ง :  '),
                                                      Text(
                                                          '${data.priceSend} บาท ')
                                                    ]),
                                                Expanded(
                                                    flex: 0,
                                                    child: const Divider(
                                                      color: Colors.black26,
                                                      thickness: 1,
                                                    )),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('ราคารวม :  '),
                                                    Text(
                                                        '${data.sumPrice} บาท ')
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ))
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return SpinKitFadingCircle(
            color: Colors.blue,
          );
        },
      ),
      bottomNavigationBar: ButtonBar(
        //color: Colors.green,
        alignment: MainAxisAlignment.center,
        children: [
          Container(
            //margin: EdgeInsets.all(10),
            child: data.status == '2'
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green),
                    child: TextButton(
                      child: Text(
                        'เสร็จแล้ว',
                        style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      onPressed: () {
                        _alertSend(data.orderId);
                        print('ทำอาหารเสร็จแล้ว');
                      },
                    ),
                  )
                : data.status == '3'
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: double.maxFinite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.green),
                              child: TextButton(
                                child: Text(
                                  'ยืนยัน',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                onPressed: () async {
                                  _alertConfirm(data.orderId);
                                  print("ยืนยันรับงาน");
                                },
                              ),
                            ),
                            Container(
                              // width: 150,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.red[500]),
                              child: TextButton(
                                child: Text(
                                  'ปฏิเสธ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  _alertCanCle(data.orderId).then((value) {
                                    if (changeOut == '1') {
                                      Navigator.pop(context);
                                    }
                                  });
                                  print('ไม่รับงาน');
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    : data.status == '4'
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                            child: TextButton(
                              child: Text(
                                'กำลังจัดส่ง',
                                style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                _alertConfirm(data.orderId);
                                print('กำลังจัดส่ง');
                              },
                            ),
                          )
                        : Padding(padding: EdgeInsets.zero),
          ),
        ],
      ),
    );
  }
}
