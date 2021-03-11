import 'dart:convert';
import 'dart:io';

import 'package:deltastore/api/toJsonRes.dart';
import 'package:deltastore/config.dart';
import 'package:deltastore/field/showMyToast.dart';
import 'package:deltastore/main_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_thailand_provinces/flutter_thailand_provinces.dart';
import 'package:deltastore/api/api_data.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThailandProvincesDatabase.init();
  runApp(MaterialApp(
    home: EditStore(),
    debugShowCheckedModeBanner: false,
  ));
}

class EditStore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditStore();
}

class _EditStore extends State {
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _nameStoreTH = TextEditingController();
  TextEditingController _nameStoreEN = TextEditingController();
  TextEditingController _locationTH = TextEditingController();
  TextEditingController _locationEN = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  File _file;
  bool check = true;
  String base64Image = '', _photo;

  // List<String> _listProvince = new List();
  // List<String> _listAmphure = new List();
  // List<String> _listDistrict = new List();
  // bool visible = false;
  // List listProvince, listAmphure = [], listDistrict = [];

  // String dropdownValue;
  // String dropdownProvince;
  // String dropdownAmphure;
  // String dropdownDistrict;

  // Future loadProvince(BuildContext context) async {
  //   if (listProvince == null) {
  //     listProvince = await ProvinceProvider.all();
  //     setState(() {});
  //   }
  // }
  //
  // Future loadAmphure(int idProvince) async {
  //   if (listAmphure.isEmpty) {
  //     listAmphure = await AmphureProvider.all(provinceId: idProvince);
  //     setState(() {});
  //   }
  // }
  //
  // Future loadDistrict(int idAmphure) async {
  //   if (listDistrict.isEmpty) {
  //     listDistrict = await DistrictProvider.all(amphureId: idAmphure);
  //     setState(() {});
  //   }
  // }

  void choosePicture() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() {
      _file = File(pickedFile.path);
    });
    print(_file);
    setUpload();
  }

  setUpload() {
    if (_file == null) return;
    List<int> imageBytes = _file.readAsBytesSync();
    String fileName = _file.path.split(".").last;
    base64Image = '$fileName;${base64Encode(imageBytes)}';

    print(base64Image);
  }

  void onSubmit() {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      // String url = 'https://develop.deltafood.co/ci/member_img/';
      // if (base64Image == null) {
      //   var name = _photo.split(url);
      //   base64Image = name[1];
      // }

      String params = jsonEncode(<String, dynamic>{
        'id_res_auto': token['data']['id_res_auto'],
        'name': {'th': _nameStoreTH.text, 'en': _nameStoreEN.text},
        'address': {'th': _locationTH.text, 'en': _locationEN.text},
        'pro_file_url': base64Image
      });

      http.post('${Config.API_URL}/update_res', body: params).then((res) {
        print(res.body);
        if (res.body == '1') {
          showToastBottom(text: 'บันทึกสำเร็จ');
        } else {
          showToastBottom(text: 'บันทึกไม่สำเร็จ');
        }
      });

      print('${params}');
    }
  }

  // void onSave() {}

  void setText(ResName resName) {
    _nameStoreEN.text = resName.name.en;
    _nameStoreTH.text = resName.name.th;
    _locationTH.text = resName.address.th;
    _locationEN.text = resName.address.en;
    _photo = resName.photoUrl;
  }

  @override
  Widget build(BuildContext context) {
    // loadProvince(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        title: Text('แก้ไขข้อมูลร้านอาหาร'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: fetchRes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SpinKitCircle(
                color: Colors.blue,
              );
            }
            ResName resName = snapshot.data;
            setText(resName);
            return SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _formkey,
                    child: Column(
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
                                child: _file != null
                                    ? Image.file(_file)
                                    : resName.photoUrl.isNotEmpty
                                        ? Image.network(
                                            resName.photoUrl,
                                            fit: BoxFit.contain,
                                          )
                                        : Center(
                                            child: Text('No Picture'),
                                          ),
                              ),
                            ),
                            FractionalTranslation(
                              translation: Offset(-1, 1.1),
                              child: Align(
                                child: IconButton(
                                  onPressed: () {
                                    // checkEmployeeEdit = true;
                                    choosePicture();
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
                          controller: _nameStoreTH,
                          decoration: InputDecoration(
                            labelText: 'ชื่อร้าน:',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (input) =>
                              input.isEmpty ? 'กรุณากรอกชื่อร้าน' : null,
                          // onSaved: (input) =>
                          //     _nameStoreTH = input as TextEditingController,
                        ),
                        TextFormField(
                          controller: _nameStoreEN,
                          decoration: InputDecoration(
                            labelText: 'Store name: ',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (input) => input.isEmpty
                              ? 'Please enter your store name.'
                              : null,
                          // onSaved: (input) =>
                          //     _nameStoreEN = input as TextEditingController,
                        ),
                        // TextFormField(
                        //   controller: _phoneNumber,
                        //   keyboardType: TextInputType.number,
                        //   decoration: InputDecoration(
                        //     labelText: 'เบอร์โทรศัพท์:',
                        //     labelStyle: TextStyle(color: Colors.black),
                        //   ),
                        //   validator: (input) => !input.contains('0')
                        //       ? 'กรุณากรอกเบอร์โทรศัพท์'
                        //       : null,
                        //   onSaved: (input) =>
                        //       _phoneNumber = input as TextEditingController,
                        // ),
                        // InputDecorator(
                        //   decoration: InputDecoration(
                        //     filled: false,
                        //     hintText: 'เลือกประเภทร้าน',
                        //     labelText: 'ประเภทร้าน:',
                        //     //errorText: _errorText,
                        //   ),
                        //   isEmpty: dropdownValue == null,
                        //   child: DropdownButtonHideUnderline(
                        //     child: new DropdownButton(
                        //       value: dropdownValue,
                        //       isDense: true,
                        //       onChanged: (newValue) {
                        //         //print('value change');
                        //         print(newValue);
                        //         setState(() {
                        //           dropdownValue = newValue;
                        //         });
                        //       },
                        //       items: <String>[
                        //         'Fast casual',
                        //         'Casual',
                        //         'Fine Dining',
                        //         'Catering',
                        //         'Delivery',
                        //         'Food Truck',
                        //         'Buffet',
                        //       ].map<DropdownMenuItem<String>>((String value) {
                        //         return DropdownMenuItem<String>(
                        //           value: value,
                        //           child: new Text(value),
                        //         );
                        //       }).toList(),
                        //     ),
                        //   ),
                        // ),
                        // InputDecorator(
                        //   decoration: InputDecoration(
                        //     filled: false,
                        //     hintText: 'เลือกจังหวัด',
                        //     labelText: 'จังหวัด:',
                        //     //errorText: _errorText,
                        //   ),
                        //   isEmpty: dropdownProvince == null,
                        //   child: DropdownButtonHideUnderline(
                        //     child: new DropdownButton(
                        //       value: dropdownProvince,
                        //       isDense: true,
                        //       onChanged: (newValue) {
                        //         //print('value change');
                        //         print(newValue);
                        //         setState(() {
                        //           dropdownProvince = newValue;
                        //         });
                        //       },
                        //       items: listProvince.map((value) {
                        //         ProvinceDao province = value;
                        //         return DropdownMenuItem(
                        //           onTap: () {
                        //             setState(() {
                        //               setState(() {
                        //                 loadAmphure(province.id);
                        //               });
                        //             });
                        //           },
                        //           value: province.nameTh,
                        //           child: new Text(province.nameTh),
                        //         );
                        //       }).toList(),
                        //     ),
                        //   ),
                        // ),
                        // InputDecorator(
                        //   decoration: InputDecoration(
                        //     filled: false,
                        //     hintText: 'เลือกอำเภอ',
                        //     labelText: 'อำเภอ:',
                        //     //errorText: _errorText,
                        //   ),
                        //   isEmpty: dropdownAmphure == null,
                        //   child: DropdownButtonHideUnderline(
                        //     child: new DropdownButton(
                        //       value: dropdownAmphure,
                        //       isDense: true,
                        //       onChanged: (newValue) {
                        //         //print('value change');
                        //         print(newValue);
                        //         setState(() {
                        //           dropdownAmphure = newValue;
                        //         });
                        //       },
                        //       items: listAmphure.map((value) {
                        //         AmphureDao amphure = value;
                        //         return DropdownMenuItem(
                        //           onTap: () {
                        //             setState(() {
                        //               loadDistrict(amphure.id);
                        //               dropdownAmphure = null;
                        //             });
                        //           },
                        //           value: amphure.nameTh,
                        //           child: new Text(amphure.nameTh),
                        //         );
                        //       }).toList(),
                        //     ),
                        //   ),
                        // ),
                        // InputDecorator(
                        //   decoration: InputDecoration(
                        //     filled: false,
                        //     hintText: 'เลือกตำบล',
                        //     labelText: 'ตำบล:',
                        //     //errorText: _errorText,
                        //   ),
                        //   isEmpty: dropdownDistrict == null,
                        //   child: DropdownButtonHideUnderline(
                        //     child: new DropdownButton(
                        //       value: dropdownDistrict,
                        //       isDense: true,
                        //       onChanged: (newValue) {
                        //         //print('value change');
                        //         print(newValue);
                        //         setState(() {
                        //           dropdownDistrict = newValue;
                        //         });
                        //       },
                        //       items: listDistrict.map((value) {
                        //         DistrictDao district = value;
                        //         return DropdownMenuItem(
                        //           onTap: () {
                        //             setState(() {});
                        //           },
                        //           value: district.nameTh,
                        //           child: new Text(district.nameTh),
                        //         );
                        //       }).toList(),
                        //     ),
                        //   ),
                        // ),
                        TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          controller: _locationTH,
                          decoration: InputDecoration(
                              labelText: 'ที่อยู่ร้าน',
                              labelStyle: TextStyle(color: Colors.black)),
                          validator: (input) =>
                              input.isEmpty ? 'กรุณากรอกข้อมูล' : null,
                          // onSaved: (input) =>
                          //     _location = input as TextEditingController,
                        ),
                        TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          controller: _locationEN,
                          decoration: InputDecoration(
                              labelText: 'Location Store',
                              labelStyle: TextStyle(color: Colors.black)),
                          validator: (input) =>
                              input.isEmpty ? 'กรุณากรอกข้อมูล' : null,
                          // onSaved: (input) =>
                          //     _location = input as TextEditingController,
                        ),
                        // Visibility(
                        //     visible: visible,
                        //     child: Container(
                        //         margin: EdgeInsets.only(bottom: 30),
                        //         child: CircularProgressIndicator())),
                        // SpinKitCircle(
                        //   color: Colors.blue,
                        // )
                      ],
                    ),
                  )),
            );
          }),
      // bottomNavigationBar: Container(
      //   color: Colors.green,
      //   child: TextButton(
      //     onPressed: onSubmit,
      //     child: Text(
      //       'บันทึก',
      //       style: TextStyle(
      //           fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      //     ),
      //   ),
      // ),
        bottomNavigationBar: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              color: Colors.green,
              onPressed: (){
                onSubmit();
                print('บันทึกข้อมูล');
              },
              child: Text('บันทึก',style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),),
            ),
          ],
        )
    );
  }
}
