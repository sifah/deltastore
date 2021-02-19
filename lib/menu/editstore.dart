
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_thailand_provinces/dao/amphure_dao.dart';
import 'package:flutter_thailand_provinces/dao/district_dao.dart';
import 'package:flutter_thailand_provinces/dao/province_dao.dart';
import 'package:flutter_thailand_provinces/flutter_thailand_provinces.dart';
import 'package:flutter_thailand_provinces/provider/amphure_provider.dart';
import 'package:flutter_thailand_provinces/provider/district_provider.dart';
import 'package:flutter_thailand_provinces/provider/province_provider.dart';

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
  TextEditingController _location = TextEditingController();


  final _formkey = GlobalKey<FormState>();
  List<String> _listProvince = new List();
  List<String> _listAmphure = new List();
  List<String> _listDistrict = new List();
  bool visible = false;
  List listProvince, listAmphure = [], listDistrict = [];

  String dropdownValue;
  String dropdownProvince;
  String dropdownAmphure;
  String dropdownDistrict;

  Future loadProvince(BuildContext context) async {
    if (listProvince == null) {
      listProvince = await ProvinceProvider.all();
      setState(() {});
    }
  }

  Future loadAmphure(int idProvince) async {
    if (listAmphure.isEmpty) {
      listAmphure = await AmphureProvider.all(provinceId: idProvince);
      setState(() {});
    }
  }

  Future loadDistrict(int idAmphure) async {
    if (listDistrict.isEmpty) {
      listDistrict = await DistrictProvider.all(amphureId: idAmphure);
      setState(() {});
    }
  }

  void onSubmit() {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
    }
    print('${_location.text}');
  }




  void onSave() {}

  @override
  void initState() {
    //dropdownProvince = 'กาฬสินธุ์';
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    //loadAmphure(listProvince.indexOf(dropdownProvince));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    loadProvince(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        title: Text('แก้ไขข้อมูลร้านค้า'),
        centerTitle: true,
      ),
      body: listProvince == null
          ? SpinKitCircle(
              color: Colors.blue,
            )
          : SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue
                          ),
                        ),
                        TextFormField(
                          controller: _nameStoreTH,
                          decoration: InputDecoration(
                            labelText: 'ชื่อร้าน:',
                            labelStyle: TextStyle(color: Colors.black),

                          ),
                          validator: (input) =>
                              !input.contains('0') ? 'กรุณากรอกชื่อร้าน' : null,
                          onSaved: (input) =>
                              _nameStoreTH = input as TextEditingController,
                        ),
                        TextFormField(
                          controller: _nameStoreEN,
                          decoration: InputDecoration(
                            labelText: 'Store name: ',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (input) => !input.contains('0')
                              ? 'Please enter your store name.'
                              : null,
                          onSaved: (input) =>
                              _nameStoreEN = input as TextEditingController,
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
                        InputDecorator(
                          decoration: InputDecoration(
                            filled: false,
                            hintText: 'เลือกประเภทร้าน',
                            labelText: 'ประเภทร้าน:',
                            //errorText: _errorText,
                          ),
                          isEmpty: dropdownValue == null,
                          child: DropdownButtonHideUnderline(
                            child: new DropdownButton(
                              value: dropdownValue,
                              isDense: true,
                              onChanged: (newValue) {
                                //print('value change');
                                print(newValue);
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>[
                                'Fast casual',
                                'Casual',
                                'Fine Dining',
                                'Catering',
                                'Delivery',
                                'Food Truck',
                                'Buffet',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
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
                          controller: _location,
                          decoration: InputDecoration(
                              labelText: 'ที่อยู่ร้าน',
                              labelStyle: TextStyle(color: Colors.black)),
                          validator: (input) =>
                              !input.contains('0') ? 'กรุณากรอกข้อมูล' : null,
                          onSaved: (input) =>
                              _location = input as TextEditingController,
                        ),
                        // Visibility(
                        //     visible: visible,
                        //     child: Container(
                        //         margin: EdgeInsets.only(bottom: 30),
                        //         child: CircularProgressIndicator())),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          height: 40,
                          width: MediaQuery.of(context).size.width-20,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                            ),
                            color: Colors.green,
                            onPressed: onSubmit,
                            child: Text(
                              'บันทึก',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        // SpinKitCircle(
                        //   color: Colors.blue,
                        // )
                      ],
                    ),
                  )),
            ),
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
    );
  }
}
