import 'package:deltastore/api/product.dart';
import 'package:deltastore/products/store_photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditImage extends StatefulWidget {
  final Product product;

  EditImage(this.product);

  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  TextEditingController nameProduct = TextEditingController();
  TextEditingController nameGroup = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();

  // Product product;
  //
  // _EditImageState(this.product);

  @override
  void initState() {
    // TODO: implement initState
    nameProduct.text = widget.product.name;
    //type.text = widget.product.type;
    price.text = widget.product.price;
    description.text = widget.product.detail;
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
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            width: double.maxFinite,
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
                            borderRadius: BorderRadiusDirectional.circular(10)),
                        //color: Colors.grey[300],
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          widget.product.picUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    FractionalTranslation(
                      translation: Offset(-1, 1.1),
                      child: Align(
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    StorePhotoPage()));
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
                        Text('ชื่อสินค้า :'),
                        TextField(
                          decoration: InputDecoration(
                              hintText: '${widget.product.name}'),
                          controller: nameProduct,
                        ),
                        Text('กลุ่มสินค้า :'),
                        TextField(
                          decoration: InputDecoration(hintText: 'ชื่อกลุ่ม'),
                          controller: nameGroup,
                        ),
                        Text('หมดหมู่ :'),
                        TextField(
                          decoration: InputDecoration(hintText: 'หมวดหมู่'),
                          controller: type,
                        ),
                        Text('ราคา :'),
                        TextField(
                          decoration: InputDecoration(
                              hintText: '${widget.product.price} บาท'),
                          controller: price,
                        ),
                        Text('รายละเอียด :'),
                        TextField(
                          minLines: 1,
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: '${widget.product.detail}',
                          ),
                          controller: description,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                color: Colors.green,
                                child: Text('บันทึก'),
                                onPressed: (){},
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        // bottomNavigationBar: Container(
        //   height: 55,
        //   color: Colors.green,
        //   child: TextButton(
        //     onPressed: () {
        //       print('บันทึกข้อมูล');
        //     },
        //     child: Text(
        //       'บันทึก',
        //       style: TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //           color: Colors.white),
        //     ),
        //   ),
        // )
    );
  }
}
