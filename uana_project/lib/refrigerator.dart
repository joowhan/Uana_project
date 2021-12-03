import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uana_project/search_from_refri.dart';
import 'refrigerator_detail.dart';
import 'refrigerator_provider.dart';
import 'add_refrigerator_detail.dart';
import 'login_provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:core';

class RefrigeratorPage extends StatefulWidget {
  const RefrigeratorPage ({Key? key}) : super(key: key);

  @override
  _RefrigeratorPageState createState() => _RefrigeratorPageState();
}
/*
자신의 냉장고 현황 관리하는 페이지
 */
class _RefrigeratorPageState extends State<RefrigeratorPage> {
  List<String> toSearch = [];
  @override
  Widget build(BuildContext context) {
    RefrigeratorProvider refrigeratorProvider = Provider.of(context, listen: true); // Refrigerator Provider 사용
    toSearch=[];
    return ListView(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 4,
          padding: const EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: refrigeratorProvider.userfoodInformation.map((userFoodInfo userfood) { // 내 냉장고에 등록된 식재료 버튼화로 띄우기
            if(!toSearch.contains(userfood.foodName)){
              toSearch.add(userfood.foodName);
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RefrigeratorDetailPage(userfood: userfood), // 내 냉장고에 있는 식재료 디테일 페이지로 연결
                      ),
                    );
                  },
                  child: Text(
                    userfood.foodName,
                    style: const TextStyle(
                      fontSize: 10,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_refrigerator'); // 내 냉장고에 새로운 식재료 등록하는 페이지로 연결
                },
                child: Text('식재료 등록'),
              ),
            ),
            /*
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('식재료 삭제'), // 식재료 삭제 버튼은 구현 안했음
              ),
            ),
             */
          ],
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SearchFromRefriPage(userRefriInfo: toSearch)),
              );
            },
            child: Text('레시피 검색'), // 내 냉장고에 있는 재료들로 할 수 있는 레시피 검색, 아직 구현 안함
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => googleMapPage()),
              );
            },
            child: Text('Map'), // 내 냉장고에 있는 재료들로 할 수 있는 레시피 검색, 아직 구현 안함
          ),
        ),
      ],
    );
  }
}

// class GeoLocatorService {
//   Future<Position> getLocation() async {
//     Position position =
//     await getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
//     return position;
//   }
// }

class googleMapPage extends StatefulWidget {
  @override
  _googleMapPageState createState() => _googleMapPageState();
}



class _googleMapPageState extends State<googleMapPage> {
  late double lat=0;
  late double lng=0;
  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late GoogleMapController mapController;
  Set <Marker> _markers = {};
  //Completer<GoogleMapController> _controller = Completer();
  LatLng _center=const LatLng(0, 0);
  _locateMe() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.getLocation().then((res) {
      setState(() {
        lat = res.latitude!;
        lng = res.longitude!;
        _center = LatLng(lat, lng);

        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _center, zoom: 15),
          ),
        );
      });
    });


  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geolocation"),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapToolbarEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15,
                ),
                markers: _markers..add(Marker(
                    markerId: MarkerId("Google Plex"),
                    infoWindow: InfoWindow(title: "Google Plex"),
                    position: _center)),
              ),

            ),
            /*
            Container(
              width: double.infinity,
              child: ElevatedButton(
                child: Text("Locate Me"),
                onPressed: () async {
                  await _locateMe();
                },
              ),
            ),

             */
          ],
        ),
      ),
    );
  }
}

