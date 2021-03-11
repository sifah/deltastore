import 'package:deltastore/api/history_api.dart';
import 'package:deltastore/api/toJsonDetailHis.dart';
import 'package:deltastore/api/toJsonHistory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HistoryDetail extends StatefulWidget {
  final History orderID;

  const HistoryDetail({Key key, this.orderID})
      : super(key: key);

  @override
  _HistoryDetailState createState() => _HistoryDetailState(orderID);
}

class _HistoryDetailState extends State<HistoryDetail> {
  History orderID;
  String dateTime;

  _HistoryDetailState(this.orderID);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายละเอียด',
          //style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchDetailHistory(orderID.orderId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DetailHistory detail = snapshot.data;
            List<Datum> detailList = detail.data;
            List<End> endPrice = detail.end;
            return DefaultTextStyle(
              style: TextStyle(
                  fontSize: 16, fontFamily: 'Kanit', color: Colors.black),
              child: ListView(
                padding: EdgeInsets.all(5),
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  container('Order ID : ', Text('${detail.orderIdRes}')),
                  container('เมื่อ : ', Text('${detail.date}')),
                  //container(Text('orderID: ${detail.orderId}')),
                  detail.table == '-'
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: container('เดลิเวอรี่', Text('')))
                      : container('โต๊ะ : ', Text('${detail.table}')),
                  container('พนักงาน : ', Text('${detail.by}')),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: detailList.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, index) {
                                  Datum dataItem = detailList[index];
                                  return DefaultTextStyle(
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Kanit',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          //margin: EdgeInsets.only(top: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  fit: FlexFit.tight,
                                                  child: Text(
                                                    'x${dataItem.number}   ${dataItem.text}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                              Text(
                                                  '${dataItem.sum.split('.').first} บาท '),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          indent: 8,
                                          endIndent: 8,
                                          color: Colors.black12
                                        )
                                      ],
                                    ),
                                  );
                                }),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                  color: Colors.white.withOpacity(0.3)),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: endPrice.length,
                                itemBuilder: (BuildContext context, index) {
                                  End _endPrice = endPrice[index];
                                  return DefaultTextStyle(
                                      style: TextStyle(
                                          color: Colors.indigo,
                                          fontSize: 17,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w600),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            //margin: EdgeInsets.only(top: 10),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                      '${_endPrice.text}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
                                                Text(
                                                    '${_endPrice.sum.split('.').first} บาท '),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ));
                                },
                              ),
                            )
                          ],
                        )),
                  )
                ],
              ),
            );
          }
          return SpinKitFadingCircle(
            color: Colors.blue,
          );
        },
      ),
    );
  }
}

Widget container(String text1, Text text2) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        //margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        child: Row(
          children: [
            Text(
              text1,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            text2
          ],
        ),
      ),
      Divider(
        indent: 1,
        endIndent: 1,
        color: Colors.black12,
        thickness: 1,
      )
    ],
  );
}

// }
