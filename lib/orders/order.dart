import 'dart:typed_data';

import 'package:deltastore/api/order_api.dart';
import 'package:deltastore/orders/detailOrder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../api/toJsonOrder.dart';
import '../main_order.dart';

dynamic token;
FlutterLocalNotificationsPlugin flutterNotification =
    FlutterLocalNotificationsPlugin();
int current = 0, past = 0;

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  // sendNotification(title, body) async {
  //   final Int64List vibrationPattern = new Int64List(4);
  //   vibrationPattern[0] = 0;
  //   vibrationPattern[1] = 1000;
  //   vibrationPattern[2] = 500;
  //   vibrationPattern[3] = 2000;
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     '1000',
  //     'FLUTTER_NOTIFICATION_CHANNEL',
  //     'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     vibrationPattern: vibrationPattern,
  //   );
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       android: androidPlatformChannelSpecifics,
  //       iOS: iOSPlatformChannelSpecifics);
  // }
  //
  // String channelId = "1000";
  // String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  // String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";
  //
  // String _status;

  @override
  void initState() {
    // TODO: implement initState
    databaseDataPay =
        firebaseDatabase.reference().child('${id}_${code}').child('data_pay');

    databaseOrders =
        firebaseDatabase.reference().child('${id}_${code}').child('orders');

    // flutterNotification.initialize(
    //     initializationSettings, onSelectNotification: (payload) {
    //   print("onSelectNotification called.");
    //   setState(() {
    //     message = payload;
    //   });
    //   return;
    // });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    MyHomeApp().setFirebase();
    databaseDataPay.onValue.listen((event) {
      //sendNotification("title", "body");
      print('pay  ${event.snapshot.value}');
    });
    // databaseOrders.onValue.listen((event) {
    //   print(event.snapshot.key);
    //   print(event.snapshot.value);
    // });
    // databaseSendRider.onValue.listen((event) { print(event.snapshot.value);});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(43, 108, 171, 1),
          centerTitle: true,
          title: Text('รายการที่ลูกค้าสั่ง'),
        ),
        body: StreamBuilder(
          stream: databaseDataPay.onValue.asyncExpand((event) => getOrders()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (current == past) {
                current = snapshot.data.length;
              } else {
                past = current;
              }
              if (past == 0 && snapshot.data.length > 0) {
                past = snapshot.data.length;
              }
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    Orders orders = snapshot.data[index];
                    // _status = orders.status;
                    // if (past < current) {
                    //   sendNotification('ออเดอรใหม่',
                    //       'จาก ${orders.member.picUrl} ${orders.orderId} ราคา ${orders.sumPrice}');
                    //   past = current;
                    // }
                    return Container(
                      child: Container(
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(20),
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5.0,
                                  spreadRadius: -3)
                            ]),
                        child: InkWell(
                          onTap: () async {
                            Navigator.push(
                                context,
                                new CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailOrder(snapshot.data[index])));
                            print(orders.orderId);
                          },
                          child: Card(
                            color: Colors.blueGrey[50],
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Material(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(
                                                    '${orders.member.picUrl}'),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Text(
                                                '${orders.sumPrice} บาท ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'เมื่อ: ${orders.timeStart}',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            'ระยะทาง : ${orders.address.distance}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  tileColor: Color.fromRGBO(0, 0, 0, 0.07),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, left: 10, right: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          orders.comment == null
                                              ? Padding(
                                                  padding: EdgeInsets.zero)
                                              : Text(
                                                  '${orders.comment}',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                ),
                                          Text(
                                              'ที่อยู่: ${orders.address.address}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                              )),
                                        ],
                                      )),
                                      Container(
                                        //margin: EdgeInsets.only(top: 15,bottom: 15),
                                        margin: EdgeInsets.only(top: 10),
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: orders.status == '3'
                                                ? Colors.blueGrey
                                                : Colors.green[400]),
                                        child: FlatButton(
                                          onPressed: () {
                                            print('ยังไม่ยืนยัน');
                                          },
                                          child: Text(
                                            orders.status == '3'
                                                ? 'ยังไม่ยืนยัน'
                                                : 'ยืนยันแล้ว',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
            return SpinKitCircle(
              color: Colors.blue,
            );
          },
        ));
  }
}
