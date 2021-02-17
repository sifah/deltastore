import 'package:deltastore/main.dart';
import 'package:flutter/material.dart';

class AddImage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AddImage();

}

class _AddImage extends State{

  void onLogOut() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มสินค้า'),
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app_outlined), onPressed: onLogOut)
        ],
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
                      child: Image.asset('assets/images/food2.jpg')
                      ),
                    ),
                  FractionalTranslation(
                    translation: Offset(-1, 1.1),
                    child: Align(
                      child: IconButton(
                        onPressed: () {
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
                      color: Colors.black
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ชื่อสินค้า :'),
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'ชื่อรูปภาพ'
                        ),
                      ),
                      Text('กลุ่มสินค้า :'),
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'ชื่อกลุ่ม'
                        ),
                      ),
                      Text('หมดหมู่ :'),
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'หมวดหมู่'
                        ),
                      ),
                      Text('ราคา :'),
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'xxxx บาท'
                        ),
                      ),
                      Text('รายละเอียด :'),
                      TextField(
                        minLines: 1,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: 'รายละเอียด',
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
      bottomNavigationBar: Container(
        height: 55,
        color: Colors.green,
        child: TextButton(
          onPressed: (){
            print('บันทึกข้อมูล');
          },
          child: Text('บันทึก',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),),
        ),
      )
      );

  }
}

