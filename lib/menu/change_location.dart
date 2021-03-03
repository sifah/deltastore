import 'dart:async';
import 'dart:convert';

import 'package:deltastore/api/api.dart';
import 'package:deltastore/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class ChangeLocation extends StatefulWidget {
  @override
  _ChangeLocationState createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  dynamic _listLocation;
  GoogleMapController _controller;
  double lng, lat;
  final GlobalKey scaffoldKey = new GlobalKey();
  BitmapDescriptor _markerIcon;
  Set<Marker> _markers = {};
  LatLng _lastMapPosition;
  Position currentPosition;

  _getCurrentPosition() async {
    final res = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = res;
    });
  }

  Future loadLocation() async {
    final resLocation = await fetchLocation();

    setState(() {
      _listLocation = resLocation;
    });
    if (resLocation['lng'] == '0' && resLocation['lat'] == '0') {
      setState(() {
        lng = currentPosition.longitude;
        lat = currentPosition.latitude;
      });
    } else {
      setState(() {
        lng = _listLocation['lng'];
        lat = _listLocation['lat'];
        _lastMapPosition = LatLng(lat, lng);
      });
    }

    print('lng  ${lng}  lat  ${lat}');
  }

  Future myPosition() async {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 15.0)));
  }

  Future _createMarker(BuildContext context) async {
    if (_markerIcon == null) {
      bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
      String icon = "assets/images/location-pin.png";
      setState(() {
        if (isIOS) {icon = "assets/images/location-pin32.png";}
      });

      ImageConfiguration configuration = ImageConfiguration();
      BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(
          configuration, icon);
      setState(() {
        _markerIcon = bitmapDescriptor;
      });
    }
  }

  void _onMoveMarker() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_listLocation.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: _markerIcon,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    //print(_lastMapPosition);
    _onMoveMarker();
  }

  void _setLocation(String idRes, LatLng latLng) {
    String params = jsonEncode(<String, dynamic>{
      'id_res_auto': idRes,
      'lat': latLng.latitude,
      'lng': latLng.longitude
    });
    http.post('${Config.API_URL}set_location', body: params).then((res) {
      print(res.body);
      if (res.body == '1') {
        Fluttertoast.showToast(
            msg: 'เลือกตำแหน่งสำเร็จ',
            gravity: ToastGravity.CENTER,
            textColor: Colors.white,
            backgroundColor: Colors.black.withOpacity(0.7));
      } else {
        Fluttertoast.showToast(
            msg: 'เลือกตำแหน่งไม่สำเร็จ',
            gravity: ToastGravity.CENTER,
            textColor: Colors.white,
            backgroundColor: Colors.black.withOpacity(0.7));
      }
    });
  }

  Future _alertConfirm(String idRes, LatLng latLng) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ยืนยันการเลือกตำแหน่ง'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ปิด')),
              TextButton(
                  onPressed: () {
                    _setLocation(idRes, latLng);
                    Navigator.of(context).pop();
                  },
                  child: Text('ยืนยัน'))
            ],
          );
        });
  }

  @override
  void initState() {
    _getCurrentPosition();
    loadLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _createMarker(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('สถานที่ที่ตั้งร้านค้า'),
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        centerTitle: true,
      ),
      body: _listLocation == null || currentPosition == null
          ? SpinKitFadingCircle(
              color: Colors.blue
            )
          : Stack(
              children: [
                GoogleMap(
                  mapToolbarEnabled: false,
                  scrollGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  markers: {
                    Marker(
                      // This marker id can be anything that uniquely identifies each marker.
                      markerId: MarkerId(_listLocation.toString()),
                      position: _lastMapPosition,
                      icon: _markerIcon,
                    )
                  },
                  initialCameraPosition:
                      CameraPosition(target: LatLng(lat, lng), zoom: 15.0),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  onCameraMove: _onCameraMove,
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Padding(
                //     padding: EdgeInsets.all(40),
                //     child: RaisedButton(
                //       color: Colors.blue[700],
                //       onPressed: () async {
                //         dynamic token = await FlutterSession().get('token');
                //         _alertConfirm(
                //             token['data']['id_res_auto'], _lastMapPosition);
                //       },
                //       child: Text(
                //         'เลือกตำแหน่งนี้',
                //         style: TextStyle(
                //             color: Colors.white, fontWeight: FontWeight.w400),
                //       ),
                //     ),
                //   ),
                // ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 110, right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 5.0,
                            spreadRadius: 0.5,
                          )
                        ],
                      ),
                      child: ClipOval(
                        child: Material(
                          color: Colors.blue[300], // button color
                          child: InkWell(
                            //splashColor: Colors.orange, // inkwell color
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(
                                Icons.edit_location_outlined,
                                color: Colors.black54,
                                size: 30,
                              ),
                            ),
                            onTap: () async {
                              dynamic token =
                                  await FlutterSession().get('token');
                              _alertConfirm(token['data']['id_res_auto'],
                                  _lastMapPosition);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 40, right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 5.0,
                            spreadRadius: 0.5,
                          )
                        ],
                      ),
                      child: ClipOval(
                        child: Material(
                          color: Colors.white, // button color
                          child: InkWell(
                            //splashColor: Colors.orange, // inkwell color
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(
                                Icons.my_location,
                                color: Colors.black54,
                              ),
                            ),
                            onTap: () {
                              myPosition();
                              //databaseRider.reference().child('528').remove();
                              // ToastMe().showToastCenter(text: 'aaaa',color: Colors.black);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
