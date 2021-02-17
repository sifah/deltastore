import 'package:deltastore/main.dart';
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
  TextEditingController _nameStore = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _email = TextEditingController();

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
  }

  void onLogOut() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => MyApp()));
  }

  Future webCall() async {
    // Showing CircularProgressIndicator using State.
    setState(() {
      visible = true;
    });
  }

  void onSave() {}

  @override
  void initState() {
    dropdownProvince = 'กาฬสินธุ์';
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
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app_outlined), onPressed: onLogOut)
        ],
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
                        TextFormField(
                          controller: _nameStore,
                          decoration: InputDecoration(
                            labelText: 'ชื่อร้าน',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (input) =>
                              !input.contains('0') ? 'กรุณากรอกชื่อร้าน' : null,
                          onSaved: (input) =>
                              _nameStore = input as TextEditingController,
                        ),
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            labelText: 'อีเมล',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (input) => !input.contains('0')
                              ? 'กรุณากรอกอีเมลให้ถูกต้อง'
                              : null,
                          onSaved: (input) =>
                              _email = input as TextEditingController,
                        ),
                        TextFormField(
                          controller: _phoneNumber,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'เบอร์โทรศัพท์',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (input) => !input.contains('0')
                              ? 'กรุณากรอกเบอร์โทรศัพท์'
                              : null,
                          onSaved: (input) =>
                              _email = input as TextEditingController,
                        ),
                        InputDecorator(
                          decoration: InputDecoration(
                            filled: false,
                            hintText: 'เลือกประเภทร้าน',
                            labelText: 'ประเภทร้าน',
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
                        InputDecorator(
                          decoration: InputDecoration(
                            filled: false,
                            hintText: 'เลือกจังหวัด',
                            labelText: 'จังหวัด',
                            //errorText: _errorText,
                          ),
                          isEmpty: dropdownProvince == null,
                          child: DropdownButtonHideUnderline(
                            child: new DropdownButton(
                              value: dropdownProvince,
                              isDense: true,
                              onChanged: (newValue) {
                                //print('value change');
                                print(newValue);
                                setState(() {
                                  dropdownProvince = newValue;
                                });
                              },
                              items: listProvince.map((value) {
                                ProvinceDao province = value;
                                return DropdownMenuItem(
                                  onTap: () {
                                    setState(() {
                                      setState(() {
                                        loadAmphure(province.id);
                                      });
                                    });
                                  },
                                  value: province.nameTh,
                                  child: new Text(province.nameTh),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        InputDecorator(
                          decoration: InputDecoration(
                            filled: false,
                            hintText: 'เลือกอำเภอ',
                            labelText: 'อำเภอ',
                            //errorText: _errorText,
                          ),
                          isEmpty: dropdownAmphure == null,
                          child: DropdownButtonHideUnderline(
                            child: new DropdownButton(
                              value: dropdownAmphure,
                              isDense: true,
                              onChanged: (newValue) {
                                //print('value change');
                                print(newValue);
                                setState(() {
                                  dropdownAmphure = newValue;
                                });
                              },
                              items: listAmphure.map((value) {
                                AmphureDao amphure = value;
                                return DropdownMenuItem(
                                  onTap: () {
                                    setState(() {
                                      loadDistrict(amphure.id);
                                      dropdownAmphure = null;
                                    });
                                  },
                                  value: amphure.nameTh,
                                  child: new Text(amphure.nameTh),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        InputDecorator(
                          decoration: InputDecoration(
                            filled: false,
                            hintText: 'เลือกตำบล',
                            labelText: 'ตำบล',
                            //errorText: _errorText,
                          ),
                          isEmpty: dropdownDistrict == null,
                          child: DropdownButtonHideUnderline(
                            child: new DropdownButton(
                              value: dropdownDistrict,
                              isDense: true,
                              onChanged: (newValue) {
                                //print('value change');
                                print(newValue);
                                setState(() {
                                  dropdownDistrict = newValue;
                                });
                              },
                              items: listDistrict.map((value) {
                                DistrictDao district = value;
                                return DropdownMenuItem(
                                  onTap: () {
                                    setState(() {});
                                  },
                                  value: district.nameTh,
                                  child: new Text(district.nameTh),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _location,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'บ้านเลขที่/หมู่บ้าน',
                              labelStyle: TextStyle(color: Colors.black)),
                          validator: (input) =>
                              !input.contains('0') ? 'กรุณากรอกข้อมูล' : null,
                          onSaved: (input) =>
                              _email = input as TextEditingController,
                        ),
                        Visibility(
                            visible: visible,
                            child: Container(
                                margin: EdgeInsets.only(bottom: 30),
                                child: CircularProgressIndicator())),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: RaisedButton(
                            color: Colors.green,
                            onPressed: onSubmit,
                            child: Text(
                              'บันทึก',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
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
