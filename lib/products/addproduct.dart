import 'package:deltastore/api/api.dart';
import 'package:deltastore/api/product.dart';
import 'package:deltastore/products/addimageproduct.dart';
import 'package:deltastore/products/editimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PageAddProduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageAddProduct();
}

class _PageAddProduct extends State {
  Future<void> _alertPic(Product product) async {
    return showDialog(
        context: context,
        //barrierDismissible: false,
        barrierColor: Colors.black45,
        builder: (BuildContext context) => AlertDialog(
              // backgroundColor: Colors.blueGrey[50],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Text(
                    '${product.name}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              content: Container(
                height: 370,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 150,
                            width: 230,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                product.picUrl,
                                fit: BoxFit.cover,
                              ),
                            )),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'รายละเอียด :',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 230,
                            height: 45,
                            //color: Colors.blueGrey,
                            child: product.detail.isEmpty
                                ? Padding(padding: EdgeInsets.zero)
                                : SingleChildScrollView(
                                    //physics: NeverScrollableScrollPhysics(),
                                    child: Container(
                                      height: 180,
                                      child: Text(product.detail),
                                    ),
                                  ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Row(children: [
                              Text(
                                'กลุ่มสินค้า : ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Text('ชื่อกลุ่ม'),
                              )
                            ]),
                          ), //ชื่อกลุ่ม
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            child: Row(
                              children: [
                                Text('หมวดหมู่ :',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Text('ชื่อหมวด'),
                                )
                              ],
                            ),
                          ), //ชื่อหมวด
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            child: Row(
                              children: [
                                Text(
                                  'สถานะ :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                product.status == '3'
                                    ? Container(
                                        margin: EdgeInsets.only(left: 10),
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        height: 25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  5),
                                          color: Colors.red[300],
                                        ),
                                        child: Text(
                                          'หมด',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      )
                                    : product.status == '2'
                                        ? Container(
                                            margin: EdgeInsets.only(left: 10),
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            height: 25,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadiusDirectional
                                                        .circular(5),
                                                color: Colors.green[400]),
                                            child: Text(
                                              'แสดง',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(left: 10),
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            height: 25,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadiusDirectional
                                                        .circular(5),
                                                color: Colors.grey[300]),
                                            child: Text(
                                              'หมด',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                              ],
                            ),
                          ), //สถานะ
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            child: Row(
                              children: [
                                Text(
                                  'ราคา :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  height: 25,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(5),
                                      color: Colors.blue[300]),
                                  child: Text(
                                    '${product.price} บาท',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ), //ราคา
                        ],
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ปิดออก')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EditImage(product)));
                    },
                    child: Text('แก้ไข'))
              ],
            ));
  }

  Future alertRemove(int index) {
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
                    //onSaveDistance(idRes, index: index);
                    Navigator.of(context).pop();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: FutureBuilder(
              future: fetchProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      padding: EdgeInsets.only(bottom: 40),
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        Product product = snapshot.data[index];
                        return Container(
                            height: 85,
                            width: double.maxFinite,
                            margin: EdgeInsets.only(bottom: 1),
                            //padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                            ),
                            child: InkWell(
                              onTap: () async {
                                print('edit = $index');
                                _alertPic(snapshot.data[index]);
                              },
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                      height: 85,
                                      width: double.maxFinite,
                                      color: Colors.blueGrey[50],
                                      child: Row(
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(5),
                                                  height: 80,
                                                  width: 80,
                                                  child: Card(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadiusDirectional
                                                                .circular(5)),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: Image.network(
                                                      product.picUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        top: 5,
                                                        left: 10,
                                                        bottom: 5),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${product.name}',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          maxLines: 1,
                                                        ),
                                                        Flexible(
                                                          child: Container(
                                                            width: 200,
                                                            child: Text(
                                                              '${product.detail}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: false,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 2,
                                                                  right: 2),
                                                          height: 20,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                          .blue[
                                                                      400],
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      spreadRadius:
                                                                          2,
                                                                      color: Colors
                                                                              .blue[
                                                                          400],
                                                                    )
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5))),
                                                          child: Text(
                                                            '${product.price} บาท',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white70),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    //margin: EdgeInsets.all(10),
                                                    child: SizedBox(
                                                      height: 30,
                                                      width: 40,
                                                      child: RawMaterialButton(
                                                        fillColor:
                                                            Colors.red[300],
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                        child: const Text('ลบ',
                                                            style: TextStyle(
                                                                //fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white)),
                                                        onPressed: () {
                                                          alertRemove(index);
                                                          print('delete');
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ])),
                                ],
                              ),
                            ));
                      });
                }
                return SpinKitCircle(
                  color: Colors.blue,
                );
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => AddImage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
