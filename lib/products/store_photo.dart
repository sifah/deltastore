import 'package:deltastore/api/api_data.dart';
import 'package:deltastore/api/toJsonPicture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class StorePhotoPage extends StatefulWidget {
  @override
  _StorePhotoPageState createState() => _StorePhotoPageState();
}

class _StorePhotoPageState extends State<StorePhotoPage> {
  Future fetchPhoto;
  List list;

  void loadPicture() async {
    Future res = fetchAllPicture();
    setState(() {
      fetchPhoto = res;
    });
  }

  void selectPhoto() {
    var file = ImagePicker().getImage(source: ImageSource.gallery);
  }

  Future alertDelete() {
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
                  child: Text('ปิดออก')),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadPicture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
   // print(deviceWidth);
    return Scaffold(
      // backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        title: Text('คลังรูปภาพ'),
        // bottom: PreferredSize(
        //   preferredSize: Size(50, 50),
        //   child: ButtonBar(
        //     alignment: MainAxisAlignment.center,
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       RaisedButton(
        //         color: Colors.green,
        //         child: Row(
        //           children: [
        //             Icon(Icons.upload_outlined),
        //             Container(
        //               margin: EdgeInsets.only(left: 5),
        //               child: Text('อัพโหลดรูปจากเครื่อง'),
        //             )
        //           ],
        //         ),
        //         onPressed: () {},
        //       ),
        //     ],
        //   ),
        // ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchPhoto,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SpinKitCircle(
              color: Colors.blue
            );
          }
          return Container(
              margin: EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (deviceWidth < 400)
                        ? 3
                        : (deviceWidth < 800)
                        ? 6
                        : 9,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0),
                itemBuilder: (BuildContext context, int index) {
                  return framePhoto(snapshot.data[index]);
                },
              ));
        },
      ),
      // persistentFooterButtons: [
      //   RaisedButton(
      //     color: Colors.green,
      //     child: Row(
      //       children: [
      //         Icon(Icons.upload_outlined),
      //         Container(
      //           margin: EdgeInsets.only(left: 5),
      //           child: Text('อัพโหลดรูปจากเครื่อง'),
      //         )
      //       ],
      //     ),
      //     onPressed: () {},
      //   )
      // ],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.upload_outlined),
        onPressed: selectPhoto,
      ),
    );
  }

  Widget framePhoto(StorePhoto storePhoto) {
    return InkWell(
      child: Card(
        color: Colors.black.withOpacity(0.05),
        child: Container(
          padding: EdgeInsets.all(2),
          child: Stack(
            //mainAxisSize: MainAxisSize.min,
            children: [
              Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(storePhoto.name),
                  fit: BoxFit.fill
                )
              ),
                  // alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 20),
                  // child: Image.network(
                  //   images[index],
                  //   fit: BoxFit.fill,
                  // )
        ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Text('${storePhoto.title}'),
                ),
              )
            ],
          ),
        ),
      ),
      onLongPress: () {
        alertDelete();
        print('delete');
      },
    );
  }
}
