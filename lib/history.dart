import 'package:commons/commons.dart';
import 'package:deltastore/api/toJsonDetailHis.dart';
import 'package:deltastore/config.dart';
import 'package:deltastore/detailHistory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'api/toJsonHistory.dart';
import 'main_order.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime _dateTime = new DateTime.now();

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat dateFormatA = DateFormat('yyyy-MM-dd');

  List listHistory;
  int count = 0;

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(_dateTime.year - 10),
        lastDate: DateTime(_dateTime.year + 5));

    if (picked != null && picked != _dateTime) {
      //print('วันที่ : ${_dateTime.toString()}');
      setState(() {
        _dateTime = picked;
        print(dateFormatA.format(_dateTime.date));
      });
      String idStore = token['data']['id_res_auto'];
      String date = dateFormatA.format(_dateTime.date);
      final res = await http.get("${Config.API_URL}get_history/$idStore/$date");
      print("${Config.API_URL}get_history/$idStore/$date");
      if (res.statusCode != 200) {
        print(res.statusCode);
      }
      setState(() {
        listHistory = historyFromJson(res.body);
        sumPrice();
      });
    }
  }

  void sumPrice() {
    if (listHistory != null) {
      count = 0;
      listHistory.forEach((element) {
        History history = element;
        count += int.parse(history.sumPrice);
      });
    }
  }

  void loadHistory() async {
    String idStore = token['data']['id_res_auto'];
    String date = dateFormatA.format(_dateTime.date);
    final res = await http.get("${Config.API_URL}get_history/$idStore/$date");
    print("${Config.API_URL}get_history/$idStore/$date");
    if (res.statusCode != 200) {
      print(res.statusCode);
    }
    setState(() {
      listHistory = historyFromJson(res.body);

      sumPrice();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(listHistory);
    print(count);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        title: Text('ประวัติการขาย'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size(50, 60),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: Colors.white,
              child: DefaultTextStyle(
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontSize: 18,
                ),
                child: Container(
                  ////////////////////////padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'เลือก ว/ด/ป',
                            style: TextStyle(fontSize: 12),
                          ),
                          Container(
                              child: InkWell(
                            onTap: () async {
                              selectDate(context);
                            },
                            child: Row(
                              children: [
                                Text(dateFormat.format(_dateTime)),
                                Icon(
                                  Icons.date_range_sharp,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          ))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 18),
                        child: Text('รายได้ ' ' ${count.toString()} บาท'),
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
      body: listHistory == null || listHistory.isEmpty
          ? SpinKitFadingCircle(
              color: Colors.blue,
            )
          : DefaultTextStyle(
              style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 18,
                  color: Colors.black87
              ),
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 5),
                  itemCount: listHistory.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    History history = listHistory[index];
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
                                        HistoryDetail(
                                          orderID: history,
                                          orderResID: history,
                                        )));
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
                                                backgroundColor:
                                                    Colors.blueGrey[300],
                                                child: history.sumTable.isEmpty
                                                    ? Icon(
                                                        Icons.delivery_dining)
                                                    : Icon(Icons.store),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Text(
                                                'Order ID: ${history.orderIdRes}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
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
                                          Text(
                                              'ราคารวม ${history.sumPrice} บาท',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                              )),
                                        ],
                                      )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}
