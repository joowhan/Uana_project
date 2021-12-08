import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather/weather.dart';
import 'package:location/location.dart';

/*
현재 지역과 날씨 정보 받아오는 provider
 */
class WeatherProvider extends ChangeNotifier {
  WeatherProvider() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
    await getPosition(); // 현재 위치 받아옴
    await getWeather(); // 현재 위치 날씨 정보 받아옴
  }



  Future<void> getPosition() async {
    //_currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
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

    await location.getLocation().then((res) {
      _latitude = res.latitude;
      _longitude = res.longitude;
    });

  }


  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;

  double? _latitude;
  double? get latitude => _latitude;

  double? _longitude;
  double? get longitude => _longitude;


  String key = '2abb81f5b0159189b673ae97a74829ec';

  Weather? _weather;
  Weather? get weather => _weather;

  Future<void> getWeather() async {
    WeatherFactory wf = WeatherFactory(key, language: Language.KOREAN);
    _weather = await wf.currentWeatherByLocation(latitude!, longitude!);

    print(_weather);
  }
}
