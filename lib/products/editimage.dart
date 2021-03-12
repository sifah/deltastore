import 'dart:convert';
import 'package:deltastore/products/addproduct.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'package:deltastore/api/api.dart';
import 'package:deltastore/api/toJsonGroup_product.dart';
import 'package:deltastore/api/toJsonProduct.dart';
import 'package:deltastore/products/store_photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main_order.dart';

class EditImage extends StatefulWidget {
  final Product product;

  const EditImage({Key key, this.product}) : super(key: key);

  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  TextEditingController nameProduct = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController detailProduct = TextEditingController();

  List<String> _productStatus = ['หมด', 'ซ่อน', 'แสดง'];
  String _photoUrl, selectValue, dropDownValue, picId = '';
  String productId = '0';
  List<GroupProduct> listGroup = [];
  String selectGroup, groupId;
  bool checkGroup = true;
  bool load = true;
  int indexGroup;

  void getGroup() async {
    load = true;
    final res = await fetchGroupProduct();
    setState(() {
      listGroup = res;
      if(widget.product != null){
        indexGroup = res.indexWhere((element) => element.fgId == widget.product.groupId);
        print(res.indexWhere((element) => element.fgId == widget.product.groupId));
      }
    });

    if (widget.product != null) {
      nameProduct.text = widget.product.name;
      price.text = widget.product.price;
      detailProduct.text = widget.product.detail;
      _photoUrl = widget.product.picUrl;
      selectValue = widget.product.status;
      if (indexGroup != -1) {
        selectGroup = widget.product.groupName;
      } else {
        checkGroup = false;
      }
      dropDownValue = _productStatus[int.parse(widget.product.status)];
      picId = widget.product.picId;
      productId = widget.product.fId;
      groupId = widget.product.groupId;
    }
    load = false;
    print(indexGroup);
  }

  void onSave({String idRes, String productID}) {
    FocusScope.of(context).requestFocus(new FocusNode());
    String params = jsonEncode(<String, String>{
      'f_id': productID,
      'id_res_auto': idRes,
      'name': nameProduct.text,
      'group_id': groupId,
      'status': selectValue,
      'price': price.text,
      'detail': detailProduct.text,
      'pic_id': picId,
      //'pic_url': _photoUrl.split('/').last
    });

    print(params);

    // http.post('${Config.API_URL}update_food', body: params).then((res) {
    //   print(res.body);
    //
    //   if (res.body == '1') {
    //     Navigator.pop(context);
    //     setState(() {
    //       check = 0;
    //     });
    //     print('success');
    //   } else {
    //     print('fail');
    //   }
    // });
  }

  void refresh() async {
    setState(() {
      if (photoUrl != null) {
        _photoUrl = photoUrl;
        picId = photoId;
      }
    });
    print('1');
  }

  // Product product;
  //
  // _EditImageState(this.product);

  @override
  void initState() {
    getGroup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('แก้ไขสินค้า'),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        ),
        body: load
            ? SpinKitFadingCircle(
                color: Colors.blue,
              )
            : SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(10),
                  //width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 40),
                            height: 150,
                            width: 230,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(10)),
                              //color: Colors.grey[300],
                              clipBehavior: Clip.antiAlias,
                              child: _photoUrl == null
                                  ? Center(
                                      child: Text('กรุณาเพิ่มรูปภาพ'),
                                    )
                                  : Image.network(
                                      _photoUrl,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          FractionalTranslation(
                            translation: Offset(-1.3, 1.7),
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        StorePhotoPage(
                                          function: refresh,
                                        )));
                                print('แก้ไขรูปภาพ');
                              },
                              child: CircleAvatar(
                                maxRadius: 15,
                                child: Icon(Icons.add_a_photo,size: 20,),
                                // child:
                                // Center(
                                //   child: IconButton(
                                //     onPressed: () {
                                //       Navigator.of(context).push(
                                //           MaterialPageRoute(
                                //               builder: (BuildContext context) =>
                                //                   StorePhotoPage(
                                //                     function: refresh,
                                //                   )));
                                //       print('แก้ไขรูปภาพ');
                                //     },
                                //     icon: Icon(
                                //       Icons.add_a_photo,
                                //       color: Colors.blue,size: 20,
                                //     ),
                                //   ),
                                // ),
                                backgroundColor: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: DefaultTextStyle(
                          style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              checkGroup
                                  ? Container()
                                  : Center(
                                      child: Text(
                                        '* กลุ่มสินค้านี้ถูกลบแล้ว',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                              fieldText('ชื่อสินค้า:', nameProduct),
                              Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('กลุ่มสินค้า :'),
                                      DropdownButtonFormField(
                                        hint: Text('เลือกกลุ่ม'),
                                        value: selectGroup,
                                        items: listGroup.map((value) {
                                          GroupProduct group = value;
                                          return DropdownMenuItem(
                                              onTap: () {
                                                setState(() {
                                                  groupId = group.fgId;
                                                });
                                                // print(selectIDGroup);
                                              },
                                              value: group.name,
                                              child: Text('${group.name}'));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectGroup = newValue;
                                            //   valGroup =
                                            //   '${listGroup.length}';
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                              Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('สถานะ :'),
                                      DropdownButtonFormField(
                                        hint: Text('เลือกสถานะ'),
                                        value: dropDownValue,
                                        items: _productStatus.map((value) {
                                          return DropdownMenuItem(
                                              value: value, child: Text(value));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            dropDownValue = newValue;
                                            selectValue =
                                                '${_productStatus.indexOf(newValue)}';
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                              fieldText('ราคา:', price),
                              fieldDetail('รายละเอียด:', detailProduct)
                              // Container(
                              //     padding: EdgeInsets.only(top: 10),
                              //     child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Text('รายละเอียด :'),
                              //         TextField(
                              //           minLines: 1,
                              //           maxLines: 10,
                              //           // decoration: InputDecoration(
                              //           //   hintText: '${widget.product.detail}',
                              //           // ),
                              //           controller: detailProduct,
                              //         ),
                              //       ],
                              //     )),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.green,
              onPressed: () {
                onSave(
                    idRes: token['data']['id_res_auto'], productID: productId);
                //Navigator.pop(context);
                print('บันทึกข้อมูล');
              },
              child: Text(
                'บันทึก',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ));
  }

  Widget fieldText(String txt, controller) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: TextFormField(
        minLines: 1,
        maxLines: 2,
        decoration: InputDecoration(
            labelText: txt,
            labelStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        controller: controller,
      ),
    );
  }

  Widget fieldDetail(String text, con) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: TextFormField(
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
            labelText: text,
            labelStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        controller: con,
      ),
    );
  }
}
