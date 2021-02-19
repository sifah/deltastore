import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DateTime _dateTime = new DateTime.now();
  TimeOfDay _timeOfDay = new TimeOfDay.now();

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));

    if (picked != null && picked != _dateTime) {
      print('วันที่ : ${_dateTime.toString()}');
      setState(() {
        _dateTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('ประวัติ'), Text('xxxxx บาท')],
        ),
        bottom: PreferredSize(
          preferredSize: Size(50, 60),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
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
                      Text('เลือก ว/ด/ป'),
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
                ),
              )),
        ),
      ),
      body: DefaultTextStyle(
        style: TextStyle(
            fontFamily: 'Kanit', fontSize: 18, color: Colors.black87),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 5),
            itemCount: 5,
            shrinkWrap: true,
            itemBuilder: (BuildContext context,index){
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
                      // Navigator.push(
                      //     context,
                      //     new CupertinoPageRoute(
                      //         builder: (BuildContext context) =>
                      //             DetailOrder(snapshot.data[index])));
                      // print(orders.orderId);
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
                                          backgroundImage: AssetImage('assets/images/user.png'),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                        EdgeInsets.only(left: 20),
                                        child: Text(
                                          'xxxx บาท ',
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
                                      'เมื่อ: 22:22',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'ระยะทาง : xxx กม.',
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
                                        Text(
                                            'ที่อยู่: -',
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
