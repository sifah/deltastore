import 'dart:convert';
import 'dart:io';

import 'package:commons/commons.dart';
import 'package:deltastore/api/toJsonEmployee.dart';
import 'package:deltastore/field/showMyToast.dart';
import 'package:deltastore/main_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import 'employee.dart';

class EditEmployee extends StatefulWidget {
  final Employees dataEmployee;
  final data;

  const EditEmployee({Key key, this.dataEmployee, this.data}) : super(key: key);

  @override
  _EditEmployeeState createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  TextEditingController _name = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _rePassword = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _tel = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  String showImage, showName, idAdmin = '0', base64Image;

  bool checkEmployeeEdit = true, check = false;
  final picker = ImagePicker();
  File _filePhoto;

  //File tmpFile;

  Future chooseImage() async {
    var file = await ImagePicker().getImage(source: ImageSource.gallery);
    if (file == null) return;
      setState(() {
        _filePhoto = File(file.path);
      });
    print(_filePhoto);
    setUpload();
  }

  setUpload() {
    if (_filePhoto == null) return;
    List<int> imageBytes = _filePhoto.readAsBytesSync();
    String fileName = _filePhoto.path.split(".").last;
    base64Image = '$fileName;${base64Encode(imageBytes)}';

    print(base64Image);
  }

  void checkText(String text) {
    if (checkEmployeeEdit) {
      if (text.isNotEmpty) {
        setState(() {
          check = false;
        });
      } else {
        setState(() {
          check = true;
        });
      }
    }
    print(text);
  }

  void onSubmit({String idAdmin = '0', String idRes, String photo = ''}) {
    String params;
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      // if (_password.text.isEmpty) {
      params = jsonEncode(<String, dynamic>{
        'admin_id': idAdmin,
        'name': _name.text,
        'username': _username.text,
        'password': _password.text,
        'tel': _tel.text,
        'email': _email.text,
        'pro_file_url': photo,
        'id_res_auto': idRes
      });
    }
    if (_name.text.isNotEmpty &&
        _username.text.isNotEmpty &&
        _email.text.isNotEmpty &&
        _tel.text.isNotEmpty) {
      if (_password.text.isEmpty) {
        params = jsonEncode(<String, dynamic>{
          'admin_id': idAdmin,
          'name': _name.text,
          'username': _username.text,
          'password': _password.text,
          'tel': _tel.text,
          'email': _email.text,
          'pro_file_url': photo,
          'id_res_auto': idRes
        });
      }
    }

    if (params != null) {
      http.post('${Config.API_URL}upate_user', body: params).then((res) {
        print(res.body);
        if (res.body == '1') {
          showToastBottom(text: 'เพิ่มพนักงานสำเร็จ');
          Navigator.of(context).pop();
        }else{
          showToastBottom(text: 'เพิ่มพนักงานไม่สำเร็จ');
        }
      });
      print(params);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if(widget.data != null){
      idAdmin = widget.data["admin_id"];
      check = true;
      checkEmployeeEdit = false;
      _name.text = widget.data['name'];
      _username.text = widget.data["username"];
      //_tel.text = widget.data.tel;
      _email.text = widget.data['email'];
      showImage = widget.data['pro_file_url'];
      print(widget.data['pro_file_url']);
    }
    if (widget.dataEmployee != null) {
      idAdmin = widget.dataEmployee.adminId;
      check = true;
      checkEmployeeEdit = false;
      _name.text = widget.dataEmployee.name;
      _username.text = widget.dataEmployee.username;
      _tel.text = widget.dataEmployee.tel;
      _email.text = widget.dataEmployee.email;
      showImage = widget.dataEmployee.proFileUrl;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูล'),
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        //centerTitle: true,
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 40),
                      height: 150,
                      width: 230,
                      child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(10)),
                          //color: Colors.grey[300],
                          clipBehavior: Clip.antiAlias,
                          child: checkEmployeeEdit
                              ? _filePhoto != null
                                  ? Image.file(_filePhoto)
                                  : Align(
                                      alignment: Alignment.center,
                                      child: Text('เลือกรูปภาพ'),
                                    )
                              : Image.network(
                                  showImage,
                                  fit: BoxFit.contain,
                                )),
                    ),
                    FractionalTranslation(
                      translation: Offset(-1, 1.1),
                      child: Align(
                        child: IconButton(
                          onPressed: () {
                            checkEmployeeEdit = true;
                            chooseImage();
                            print('แก้ไขรูปภาพ');
                          },
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Colors.blue,
                          ),
                        ),
                        //Icon(Icons.add_a_photo,color: Colors.blue[300], ),
                        alignment: FractionalOffset(0.08, 0.7),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'ชื่อ'),
                  controller: _name,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'กรอกชื่อ';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'ชื่อเข้าใช้งาน'),
                  controller: _username,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'กรอกชื่อเข้าใช้งาน';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'รหัสผ่าน'),
                  obscureText: true,
                  controller: _password,
                  onChanged: checkText,
                  validator: check
                      ? (input) {
                          return null;
                        }
                      : (input) {
                          if (input.isEmpty) {
                            return 'กรอกรหัสผ่าน';
                          }
                          if (input.length < 5) {
                            return 'รหัสผ่านไม่ต่ำกว่า 6 ตัว';
                          }
                          return null;
                        },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'ยืนยันรหัสผ่าน'),
                  obscureText: true,
                  controller: _rePassword,
                  onChanged: checkText,
                  validator: check
                      ? (input) {
                          return null;
                        }
                      : (input) {
                          if (input.isEmpty) {
                            return 'กรอกรหัสผ่าน';
                          }
                          if (input != _password.text) {
                            return 'รหัสผ่านไม่ตรงกัน';
                          }
                          if (input.length < 5) {
                            return 'รหัสผ่านไม่ต่ำกว่า  ตัว';
                          }
                          return null;
                        },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'อีเมล์'),
                  controller: _email,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'กรอกอีเมล์';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'เบอร์โทรศัพท์'),
                  controller: _tel,
                  keyboardType: TextInputType.number,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'กรอกเบอร์โทรศัพท์';
                    }
                    return null;
                  },
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    onPressed: () {
                      onSubmit(
                          idRes: token['data']['id_res_auto'],
                          idAdmin: idAdmin,
                          photo: base64Image);
                    },
                    color: Colors.green,
                    child: Text(
                      'บันทึก',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // bottomNavigationBar: Container(
      //   color: Colors.green,
      //   child: TextButton(
      //     child: Text(
      //       'บันทึก',
      //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //     ),
      //     onPressed: onSubmit,
      //   ),
      // ),
    );
  }
}
