import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        centerTitle: true,
        title: Text('ประวัติการสังซื้อ'),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        padding: EdgeInsets.all(10),
        child: DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 18,
            color: Colors.black87
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ประวัติ'),
                    Text('รายได้ xxxxxx บาท')
                  ],
                ),
              ),
              Expanded(
                  flex: 0,
                  child: const Divider(
                    color: Colors.black45,
                    thickness: 1,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
