import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
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
  @override
  Widget build(BuildContext context) {
    RefrigeratorProvider refrigeratorProvider = Provider.of(context, listen: true); // Refrigerator Provider 사용

    return ListView(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 4,
          padding: const EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: refrigeratorProvider.userfoodInformation.map((userFoodInfo userfood) { // 내 냉장고에 등록된 식재료 버튼화로 띄우기
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
            onPressed: () {},
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
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(37.898989, 129.362536);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('집근처 식재료 '),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 12.0,
          ),
        ),
        // floatingActionButton: TextButton(onPressed: () {Navigator.pop(context);  }, child: Text('back'),
        //
        // ),
      ),
    );
  }
}

