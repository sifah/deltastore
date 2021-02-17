import 'dart:convert';

import 'package:deltastore/api/toJsonPayment.dart';
import 'package:deltastore/config.dart';
import 'package:deltastore/field/showMyToast.dart';
import 'package:deltastore/main_order.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditBank extends StatefulWidget {
  final Payments payments;

  const EditBank({Key key, this.payments}) : super(key: key);

  @override
  _EditBankState createState() => _EditBankState();
}

class _EditBankState extends State<EditBank> {
  Color buttonTypeChance = Colors.blue.shade400;
  TextStyle styleTypeChance = TextStyle(color: Colors.white);

  Color buttonType = Colors.black.withAlpha(5);
  TextStyle styleType = TextStyle(color: Colors.black);

  final _bankName = TextEditingController();
  final _bankNum = TextEditingController();
  final _nameP = TextEditingController();

  //TextEditingController _promtPay = TextEditingController();
  String type, status, idPayType = '0';

  void selectStatus(value) {
    setState(() {
      status = value;
    });
  }

  void selectRadio(value) {
    if(widget.payments != null){
      if (value == '1') {
        _bankNum.text = widget.payments.type1Options.bank;
        _bankName.text = widget.payments.type1Options.name;
        _nameP.text = widget.payments.type1Options.name;
      } else if (value == '5') {
        _bankNum.text = widget.payments.acountNumber;
        _bankName.text = widget.payments.acountName;
      }
    }else{
      _nameP.clear();
      _bankName.clear();
      _bankNum.clear();
    }
    setState(() {
      type = value;
    });
  }

  //id_pay_type ,bank,type,id_res_auto,status{1 show,0 hide},type1_options,acount_number
  // type1_options = {number,bank,name}// type = 1
  void onSaveBank({String idPayType, String idRes}) {
    FocusScope.of(context).requestFocus(new FocusNode());
    var typeOne = {};
    String accountNumber, accountName;
    if (type == '1') {
      typeOne = {
        'number': _bankNum.text,
        'bank': _bankName.text,
        'name': _nameP.text
      };
     accountNumber = _bankNum.text;
    } else {
      accountNumber = _bankNum.text;
      accountName = _bankName.text;
showToastBottom(text: '');
    }

    String params = jsonEncode(<String, dynamic>{
      'id_pay_type': idPayType,
      'bank': _bankName.text,
      'type': type,
      'status': status,
      'type1_options': typeOne,
      'account_number': accountNumber,
      'id_res_auto': idRes,
    });
    print(params);
    http.post('${Config.API_URL}update_payment', body: params).then((res) {
      print(res.body);
      if (res.body == '1') {
        showToastBottom(text: 'บันทึกสำเร็จ');
        Navigator.of(context).pop();
      } else {
        showToastBottom(text: 'บันทึกไม่สำเร็จ');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.payments != null) {
      if (widget.payments.type == '1') {
        _bankName.text = widget.payments.type1Options.bank;
        _bankNum.text = widget.payments.type1Options.number;
        _nameP.text = widget.payments.type1Options.name;
      } else {
        _bankNum.text = widget.payments.acountNumber;
      }
      type = widget.payments.type;
      idPayType = widget.payments.idPayType;
      status = widget.payments.status;
      print(type);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        selectRadio('1');
                      },
                      child: Text(
                        'บัญชีธนาคาร',
                        style: type == '1' ? styleTypeChance : styleType,
                      ),
                      color: type == '1' ? buttonTypeChance : buttonType,
                    ),
                    RaisedButton(
                      onPressed: () {
                        selectRadio('5');
                      },
                      child: Text(
                        'พร้อมเพย์',
                        style: type == '5' ? styleTypeChance : styleType,
                      ),
                      color: type == '5' ? buttonTypeChance : buttonType,
                    )
                    // Radio(value: '1', groupValue: type, onChanged: selectRadio),
                    // Text('บัญชีธนาคาร'),
                    // Radio(value: '5', groupValue: type, onChanged: selectRadio),
                    // Text('พร้อมเพย์')
                  ],
                ),
              ),
              type == '1'
                  ? bankTypeOne()
                  : type == '5'
                      ? bankTypeFive()
                      : Center(
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                'โปรดเลือกประเภทการชำระเงิน',
                                style: TextStyle(color: Colors.black87),
                              )),
                        ),
            ],
          ),
        ),
        persistentFooterButtons: [
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
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
                  onSaveBank(
                      idPayType: idPayType,
                      idRes: token['data']['id_res_auto']);
                  //Navigator.of(context).pop();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget bankStatus() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('สถานะ'),
          Radio(value: '1', groupValue: status, onChanged: selectStatus),
          Text('แสดง'),
          Radio(value: '0', groupValue: status, onChanged: selectStatus),
          Text('ซ่อน')
        ],
      ),
    );
  }

  Widget bankTypeFive() {
    return Container(
      child: Column(
        children: [
          TextField(
            autofocus: true,
            controller: _bankName,
            decoration: new InputDecoration(
                hintText: 'ชื่อพร้อมเพย์', hintStyle: TextStyle(fontSize: 14)),
            // onChanged: (value) {
            //   bankNum = value;
            // },
          ),
          TextField(
            autofocus: true,
            controller: _bankNum,
            decoration: new InputDecoration(
                hintText: 'หมายเลขพร้อมเพย์',
                hintStyle: TextStyle(fontSize: 14)),
            // onChanged: (value) {
            //   bankNum = value;
            // },
          ),
          bankStatus()
        ],
      ),
    );
  }

  Widget bankTypeOne() {
    return Container(
      child: Column(children: [
        new TextField(
          autofocus: true,
          controller: _bankNum,
          decoration: new InputDecoration(
              hintText: 'เลขบัญชี', hintStyle: TextStyle(fontSize: 14)),
          // onChanged: (value) {
          //   bankNum = value;
          // },
        ),
        new TextField(
          autofocus: true,
          controller: _nameP,
          decoration: new InputDecoration(
              hintText: 'ชื่อเจ้าของบัญชี', hintStyle: TextStyle(fontSize: 14)),
          // onChanged: (value) {
          //   nameP = value;
          // },
        ),
        new TextField(
          autofocus: true,
          controller: _bankName,
          decoration: new InputDecoration(
              hintText: 'ธนาคาร', hintStyle: TextStyle(fontSize: 14)),
          // onChanged: (value) {
          //   bankName = value;
          // },
        ),
        bankStatus(),
      ]),
    );
  }
}
