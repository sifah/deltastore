import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:deltastore/config.dart';
import 'package:deltastore/api/api.dart';
import 'package:deltastore/api/toJsonEmployee.dart';
import 'package:deltastore/field/showMyToast.dart';
import 'package:deltastore/menu/edit_employee.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main_order.dart';


class Employee extends StatefulWidget {
  @override
  _EmployeeState createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  var text1 = TextStyle(
      color: Colors.black.withOpacity(0.9), fontWeight: FontWeight.w500);
  var text2 = TextStyle(
      color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.w500);
  var textBody1 = const TextStyle(color: Colors.black);
  var textBody2 = TextStyle(color: Colors.black.withOpacity(0.7));

  Future listEmployee;

  void onClick({Employees data}) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => EditEmployee(
                  dataEmployee: data,
                )))
        .whenComplete(() => loadEmployee());
  }

  void loadEmployee() async {
      Future res = fetchEmployee();
      setState(() {
        listEmployee = res;
      });

  }

  void onRemove(String adminId,BuildContext context) {
    String param = jsonEncode(<String, String>{
      'admin_id': adminId,
      'id_res_auto': token['data']['id_res_auto']
    });
    print(param);
    http.post('${Config.API_URL}delete_employee', body: param).then((res) {
      print(res.body);
      if(res.body == '1'){
        Navigator.pop(context);
        showToastBottom(text: 'ลบข้อมูล');
        print('success');
      }else{
        showToastBottom(text: 'ลบไม่สำเร็จ');
        print('fail');
      }
    });
  }

  Future _alertRemove(String employeeId) {
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
                    onRemove(employeeId,context);
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
    loadEmployee();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    loadEmployee();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('พนักงาน'),
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: listEmployee,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SpinKitFadingCircle(
                color: Colors.blue,
              );
            }
            return ListView.builder(
                padding: EdgeInsets.only(bottom: 60),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, index) {
                  Employees employee = snapshot.data[index];
                  return Container(
                    margin: EdgeInsets.only(top: 5),
                    //height: 60,
                    //color: Colors.lightGreen,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5,
                      color: index.isEven
                          ? Colors.white
                          : Colors.blueGrey[50],
                      child: Column(
                        children: [
                          ListTile(
                            tileColor: index.isOdd
                                ? Colors.white.withOpacity(0.3)
                                : Colors.black.withOpacity(0.04),
                            leading: CircleAvatar(
                              backgroundImage: employee.proFileUrl.isNotEmpty
                                  ? NetworkImage(employee.proFileUrl)
                                  : AssetImage('assets/images/user.png'),
                            ),
                            title: Text(employee.name),
                            trailing: FractionalTranslation(
                              translation: Offset(0.25, -0.45),
                              child: Container(
                                //padding: EdgeInsets.only(top: 5),
                                child: Card(
                                  //elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10)),
                                  ),
                                  color: employee.active == '0'
                                      ? Color.alphaBlend(
                                          Colors.red.withOpacity(0.8),
                                          Colors.white)
                                      : Colors.green,
                                  child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 5, 20, 1),
                                      child: Text(
                                        employee.active == '0'
                                            ? 'ไม่ใช้งาน'
                                            : 'ใช้งาน',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'ชื่อผู้ใช้งาน   ',
                                          style: index.isOdd ? text1 : text2,
                                        ),
                                        Flexible(
                                            child: Text(
                                          employee.username,
                                          style: index.isOdd
                                              ? textBody1
                                              : textBody2,
                                        ))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'เบอร์โทรศัพท์   ',
                                          style: index.isOdd ? text1 : text2,
                                        ),
                                        Flexible(
                                            child: Text(
                                          employee.tel,
                                          style: index.isOdd
                                              ? textBody1
                                              : textBody2,
                                        ))
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 4),
                                      child: RawMaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          constraints: BoxConstraints(
                                              minWidth: 40, minHeight: 30),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          fillColor: Colors.amber,
                                          child: Text('แก้ไข',
                                              style: TextStyle(
                                                  color: Colors.black,fontWeight: FontWeight.bold)),
                                          onPressed: () {
                                            onClick(
                                                data: snapshot.data[index]);
                                            print('edit');
                                          }),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 4),
                                      child: RawMaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                          ),
                                          constraints: BoxConstraints(
                                              minWidth: 40, minHeight: 30),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          fillColor: Colors.red[300],
                                          child: Text('ลบ',
                                              style: TextStyle(
                                                  color: Colors.white,fontWeight: FontWeight.bold)),
                                          onPressed: () {
                                            _alertRemove(employee.adminId).whenComplete(() => loadEmployee());
                                            print('delete');
                                          }),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
      //bottomNavigationBar: SizedBox(height: 50,),
      floatingActionButton: FloatingActionButton(
        //backgroundColor: Colors.transparent,
        onPressed: () async {
          onClick();
        },
        child: Icon(Icons.add),
      ),
    );
  }
  Widget buttonClick(color1,txt,color2, {Function function}){
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: RawMaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0),
          ),
          constraints: BoxConstraints(
              minWidth: 40, minHeight: 30),
          padding: EdgeInsets.only(
              left: 10, right: 10),
          fillColor: color1,
          child: Text(txt,
              style: TextStyle(
                  color: color2,fontWeight: FontWeight.bold)),
          onPressed: function()),
    );
  }
}
