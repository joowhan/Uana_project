import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uana_project/refrigerator/refrigerator_calendar.dart';
import '../search/search_from_refri.dart';
import 'refrigerator_detail.dart';
import '../provider/refrigerator_provider.dart';
import 'add_refrigerator_detail.dart';
import '../provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:core';

class RefrigeratorPage extends StatefulWidget {
  const RefrigeratorPage({Key? key}) : super(key: key);

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
    RefrigeratorProvider refrigeratorProvider =
        Provider.of(context, listen: true); // Refrigerator Provider 사용
    toSearch = [];
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 냉장고'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 4,
                  padding: const EdgeInsets.all(16.0),
                  childAspectRatio: 8.0 / 9.0,
                  children: refrigeratorProvider.userfoodInformation
                      .map((userFoodInfo userfood) {
                    // 내 냉장고에 등록된 식재료 버튼화로 띄우기
                    if (!toSearch.contains(userfood.foodName)) {
                      toSearch.add(userfood.foodName);
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RefrigeratorDetailPage(
                                  userfood:
                                      userfood), // 내 냉장고에 있는 식재료 디테일 페이지로 연결
                            ),
                          );
                        },
                        child: Text(
                          userfood.foodName,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        /* style: ElevatedButton.styleFrom(
                          primary: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.9),
                        ),

                        */
                      ),
                    );
                  }).toList(),
                ),

                /*
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
                 */
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context,
                      '/add_refrigerator'); // 내 냉장고에 새로운 식재료 등록하는 페이지로 연결
                },
                child: const Icon(Icons.add),
                //backgroundColor: Colors.green,
              ),
            ),
          ),
          Row(
            children: [
              /*
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/add_refrigerator'); // 내 냉장고에 새로운 식재료 등록하는 페이지로 연결
                    },
                    child: const Text(
                        '식재료 등록',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                    ),
                  ),
                ),
              ),
               */
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CalendarPage(
                                refrigerator:
                                    refrigeratorProvider.userfoodInformation)),
                      );
                    },
                    icon: const FaIcon(FontAwesomeIcons.calendarCheck),
                    label: const Text(
                      '유통기한',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    /*
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                    ),

                     */
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchFromRefriPage(userRefriInfo: toSearch)),
                      );
                    },
                    child: const Text(
                      '레시피 검색',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ), // 내 냉장고에 있는 재료들로 할 수 있는 레시피 검색, 아직 구현 안함
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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

final places =
    GoogleMapsPlaces(apiKey: "AIzaSyAuNt_UmAPhv0KVmz9RxjeWOPp3IC4d3x0");

class googleMapPage extends StatefulWidget {
  @override
  _googleMapPageState createState() => _googleMapPageState();
}

class _googleMapPageState extends State<googleMapPage> {
  late Future<Position> _currentLocation;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _currentLocation = Geolocator.getCurrentPosition();
  }

  Future<void> _retrieveNearbyRestaurants(LatLng _userLocation) async {
    PlacesSearchResponse _response = await places.searchNearbyWithRadius(
        Location(lat: _userLocation.latitude, lng: _userLocation.longitude),
        10000,
        type: 'bank');

    if (_response.results.isEmpty) {
      print('무야호');
    }
    _response.results.map((result) {
      print('result name : ${result.name}');
    });

    Set<Marker> _restaurantMarkers = _response.results
        .map((result) => Marker(
            markerId: MarkerId(result.name),
            // Use an icon with different colors to differentiate between current location
            // and the restaurants
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(
                title: result.name,
                snippet:
                    "Ratings: " + (result.rating?.toString() ?? "Not Rated")),
            position: LatLng(
                result.geometry!.location.lat, result.geometry!.location.lng)))
        .toSet();

    setState(() {
      _markers.addAll(_restaurantMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _currentLocation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // The user location returned from the snapshot
              Position snapshotData = snapshot.data as Position;
              LatLng _userLocation =
                  LatLng(snapshotData.latitude, snapshotData.longitude);

              //if (_markers.isEmpty) {
              _retrieveNearbyRestaurants(_userLocation);
              print('먹히나???');
              //}

              return GoogleMap(
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _userLocation,
                  zoom: 12,
                ),
                markers: _markers
                  ..add(Marker(
                      markerId: MarkerId("User Location"),
                      infoWindow: InfoWindow(title: "User Location"),
                      position: _userLocation)),
              );
            } else {
              return Center(child: Text("Failed to get user location."));
            }
          }
          // While the connection is not in the done state yet
          return Center(child: CircularProgressIndicator());
        });
  }
}
