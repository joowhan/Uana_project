import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';
import 'package:location/location.dart';

/*
레시피 provider
 */
class RecipeProvider extends ChangeNotifier {
  RecipeProvider() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    // 전체 레시피 받아옴 (받아오는데 시간 걸려서 Search Page 클릭 후 다른 데 갔다가 오면 다 받아지더라)
    FirebaseAuth.instance.userChanges().listen((user) {
      FirebaseFirestore.instance
          .collection('forUana')
          .orderBy('foodName', descending: false)
          .snapshots()
          .listen((snapshot) {
        _recipeInformation = [];
        _favoriteRecipes = [];
        _myRecipes = [];
        for (final document in snapshot.docs) {
          _recipeInformation.add(
            RecipeInfo(
              detailUrl: document.data()['detailUrl'] as String,
              docId: document.data()['docId'] as String,
              etcMaterial: document.data()['etcMaterial'] as String,
              foodName: document.data()['foodName'] as String,
              ingredient: document.data()['ingredient'] as List<dynamic>,
              kategorie: document.data()['kategorie'] as List<dynamic>,
              like: document.data()['like'] as int,
              likeusers: document.data()['likeusers'] as List<dynamic>,
              name: document.data()['name'] as String,
              path: document.data()['path'] as String,
              processDescription:
                  document.data()['processDescription'] as Map<String, dynamic>,
              processUrl: document.data()['processUrl'] as Map<String, dynamic>,
              timedate: document.data()['timedate'] as String,
              timestamp: document.data()['timestamp'] as int,
              userId: document.data()['userId'] as String,
            ),
          );
          if (document.data()['userId'] as String ==
              FirebaseAuth.instance.currentUser!.uid) {
            _myRecipes.add(
              RecipeInfo(
                detailUrl: document.data()['detailUrl'] as String,
                docId: document.data()['docId'] as String,
                etcMaterial: document.data()['etcMaterial'] as String,
                foodName: document.data()['foodName'] as String,
                ingredient: document.data()['ingredient'] as List<dynamic>,
                kategorie: document.data()['kategorie'] as List<dynamic>,
                like: document.data()['like'] as int,
                likeusers: document.data()['likeusers'] as List<dynamic>,
                name: document.data()['name'] as String,
                path: document.data()['path'] as String,
                processDescription: document.data()['processDescription']
                    as Map<String, dynamic>,
                processUrl:
                    document.data()['processUrl'] as Map<String, dynamic>,
                timedate: document.data()['timedate'] as String,
                timestamp: document.data()['timestamp'] as int,
                userId: document.data()['userId'] as String,
              ),
            );
          }

          if (document
              .data()['likeusers']
              .contains(FirebaseAuth.instance.currentUser!.uid)) {
            _favoriteRecipes.add(
              RecipeInfo(
                detailUrl: document.data()['detailUrl'] as String,
                docId: document.data()['docId'] as String,
                etcMaterial: document.data()['etcMaterial'] as String,
                foodName: document.data()['foodName'] as String,
                ingredient: document.data()['ingredient'] as List<dynamic>,
                kategorie: document.data()['kategorie'] as List<dynamic>,
                like: document.data()['like'] as int,
                likeusers: document.data()['likeusers'] as List<dynamic>,
                name: document.data()['name'] as String,
                path: document.data()['path'] as String,
                processDescription: document.data()['processDescription']
                    as Map<String, dynamic>,
                processUrl:
                    document.data()['processUrl'] as Map<String, dynamic>,
                timedate: document.data()['timedate'] as String,
                timestamp: document.data()['timestamp'] as int,
                userId: document.data()['userId'] as String,
              ),
            );
          }
        }
      });
      print("레시피 받아오기 완료!");

      sortRecipesByLike();
    });
    notifyListeners();
  }

/*
  Future<void> loadFavoriteRecipes() async { // favorite 레시피 받아옴
    _favoriteRecipes = [];
    for(final recipe in _recipeInformation) {
      if(recipe.likeusers.contains(FirebaseAuth.instance.currentUser!.uid)) {
        _favoriteRecipes.add(recipe);
        print(recipe.foodName);
      }
    }
    print('favorite recipe 받아오기 완료!');
    notifyListeners();
  }


 */
  Future<void> updateLike(String docId, int like, bool updating) async {
    // 좋아요 or 좋아요 취소
    if (updating == true) {
      await FirebaseFirestore.instance.collection('forUana').doc(docId).update({
        'like': like + 1,
        'likeusers':
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });
      loadRecipes();
      print('좋아요+1');
    } else {
      await FirebaseFirestore.instance.collection('forUana').doc(docId).update({
        'like': like - 1,
        'likeusers':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      });
      loadRecipes();
      print('좋아요-1');
    }
    //await loadRecipes(); // 전체 받아와서 비효율적
    //loadFavoriteRecipes();

    notifyListeners();
  }

  Future<void> loadWeatherRecipes(Weather? weather) async {
    if (DateTime.now().hour >= 21 && DateTime.now().hour <= 24 || DateTime.now().hour >= 0 && DateTime.now().hour <= 3) {
      FirebaseAuth.instance.userChanges().listen((user) {
        FirebaseFirestore.instance
            .collection('forUana')
            .where('kategorie', arrayContains: '야식')
            .snapshots()
            .listen((snapshot) {
          _weatherRecipes = [];
          for (final document in snapshot.docs) {
            _weatherRecipes.add(
              RecipeInfo(
                detailUrl: document.data()['detailUrl'] as String,
                docId: document.data()['docId'] as String,
                etcMaterial: document.data()['etcMaterial'] as String,
                foodName: document.data()['foodName'] as String,
                ingredient: document.data()['ingredient'] as List<dynamic>,
                kategorie: document.data()['kategorie'] as List<dynamic>,
                like: document.data()['like'] as int,
                likeusers: document.data()['likeusers'] as List<dynamic>,
                name: document.data()['name'] as String,
                path: document.data()['path'] as String,
                processDescription: document.data()['processDescription']
                    as Map<String, dynamic>,
                processUrl:
                    document.data()['processUrl'] as Map<String, dynamic>,
                timedate: document.data()['timedate'] as String,
                timestamp: document.data()['timestamp'] as int,
                userId: document.data()['userId'] as String,
              ),
            );
          }
        });
        print("늦은 시각 야식 요리 다운로드 완료");
      });
    }

    else if (DateTime.now().hour >= 7 && DateTime.now().hour <= 11) {
      FirebaseAuth.instance.userChanges().listen((user) {
        FirebaseFirestore.instance
            .collection('forUana')
            .where('kategorie', arrayContains: '아침')
            .snapshots()
            .listen((snapshot) {
          _weatherRecipes = [];
          for (final document in snapshot.docs) {
            _weatherRecipes.add(
              RecipeInfo(
                detailUrl: document.data()['detailUrl'] as String,
                docId: document.data()['docId'] as String,
                etcMaterial: document.data()['etcMaterial'] as String,
                foodName: document.data()['foodName'] as String,
                ingredient: document.data()['ingredient'] as List<dynamic>,
                kategorie: document.data()['kategorie'] as List<dynamic>,
                like: document.data()['like'] as int,
                likeusers: document.data()['likeusers'] as List<dynamic>,
                name: document.data()['name'] as String,
                path: document.data()['path'] as String,
                processDescription: document.data()['processDescription']
                    as Map<String, dynamic>,
                processUrl:
                    document.data()['processUrl'] as Map<String, dynamic>,
                timedate: document.data()['timedate'] as String,
                timestamp: document.data()['timestamp'] as int,
                userId: document.data()['userId'] as String,
              ),
            );
          }
        });
        print("이른 시각 아침 요리 다운로드 완료");
      });
    }

    else if (DateTime.now().hour >= 11 && DateTime.now().hour <= 20) {
      if (weather!.weatherDescription!.toLowerCase() == "rain") {
        FirebaseAuth.instance.userChanges().listen((user) {
          FirebaseFirestore.instance
              .collection('forUana')
              .where('kategorie', arrayContains: '튀김, 전')
              .snapshots()
              .listen((snapshot) {
            _weatherRecipes = [];
            for (final document in snapshot.docs) {
              _weatherRecipes.add(
                RecipeInfo(
                  detailUrl: document.data()['detailUrl'] as String,
                  docId: document.data()['docId'] as String,
                  etcMaterial: document.data()['etcMaterial'] as String,
                  foodName: document.data()['foodName'] as String,
                  ingredient: document.data()['ingredient'] as List<dynamic>,
                  kategorie: document.data()['kategorie'] as List<dynamic>,
                  like: document.data()['like'] as int,
                  likeusers: document.data()['likeusers'] as List<dynamic>,
                  name: document.data()['name'] as String,
                  path: document.data()['path'] as String,
                  processDescription: document.data()['processDescription']
                      as Map<String, dynamic>,
                  processUrl:
                      document.data()['processUrl'] as Map<String, dynamic>,
                  timedate: document.data()['timedate'] as String,
                  timestamp: document.data()['timestamp'] as int,
                  userId: document.data()['userId'] as String,
                ),
              );
            }
          });
          print("비오는 날 튀김, 전 요리 다운로드 완료");
        });
      }
      else if (weather.tempFeelsLike!.celsius! <= 6.0) {
        FirebaseAuth.instance.userChanges().listen((user) {
          FirebaseFirestore.instance
              .collection('forUana')
              .where('kategorie', arrayContains: '국물')
              .snapshots()
              .listen((snapshot) {
            _weatherRecipes = [];
            for (final document in snapshot.docs) {
              _weatherRecipes.add(
                RecipeInfo(
                  detailUrl: document.data()['detailUrl'] as String,
                  docId: document.data()['docId'] as String,
                  etcMaterial: document.data()['etcMaterial'] as String,
                  foodName: document.data()['foodName'] as String,
                  ingredient: document.data()['ingredient'] as List<dynamic>,
                  kategorie: document.data()['kategorie'] as List<dynamic>,
                  like: document.data()['like'] as int,
                  likeusers: document.data()['likeusers'] as List<dynamic>,
                  name: document.data()['name'] as String,
                  path: document.data()['path'] as String,
                  processDescription: document.data()['processDescription']
                      as Map<String, dynamic>,
                  processUrl:
                      document.data()['processUrl'] as Map<String, dynamic>,
                  timedate: document.data()['timedate'] as String,
                  timestamp: document.data()['timestamp'] as int,
                  userId: document.data()['userId'] as String,
                ),
              );
            }
          });
          print("추운 날씨 국물 요리 다운로드 완료");
        });
      }
      else if (weather.tempFeelsLike!.celsius! >= 27.0) {
        FirebaseAuth.instance.userChanges().listen((user) {
          FirebaseFirestore.instance
              .collection('forUana')
              .where('kategorie', arrayContains: '매운 음식')
              .snapshots()
              .listen((snapshot) {
            _weatherRecipes = [];
            for (final document in snapshot.docs) {
              _weatherRecipes.add(
                RecipeInfo(
                  detailUrl: document.data()['detailUrl'] as String,
                  docId: document.data()['docId'] as String,
                  etcMaterial: document.data()['etcMaterial'] as String,
                  foodName: document.data()['foodName'] as String,
                  ingredient: document.data()['ingredient'] as List<dynamic>,
                  kategorie: document.data()['kategorie'] as List<dynamic>,
                  like: document.data()['like'] as int,
                  likeusers: document.data()['likeusers'] as List<dynamic>,
                  name: document.data()['name'] as String,
                  path: document.data()['path'] as String,
                  processDescription: document.data()['processDescription']
                      as Map<String, dynamic>,
                  processUrl:
                      document.data()['processUrl'] as Map<String, dynamic>,
                  timedate: document.data()['timedate'] as String,
                  timestamp: document.data()['timestamp'] as int,
                  userId: document.data()['userId'] as String,
                ),
              );
            }
          });
          print("더운 날씨 매운 요리 다운로드 완료");
        });
      }

      else {
        FirebaseAuth.instance.userChanges().listen((user) {
          FirebaseFirestore.instance
              .collection('forUana')
              .where('kategorie', arrayContains: '식사')
              .snapshots()
              .listen((snapshot) {
            _weatherRecipes = [];
            for (final document in snapshot.docs) {
              _weatherRecipes.add(
                RecipeInfo(
                  detailUrl: document.data()['detailUrl'] as String,
                  docId: document.data()['docId'] as String,
                  etcMaterial: document.data()['etcMaterial'] as String,
                  foodName: document.data()['foodName'] as String,
                  ingredient: document.data()['ingredient'] as List<dynamic>,
                  kategorie: document.data()['kategorie'] as List<dynamic>,
                  like: document.data()['like'] as int,
                  likeusers: document.data()['likeusers'] as List<dynamic>,
                  name: document.data()['name'] as String,
                  path: document.data()['path'] as String,
                  processDescription: document.data()['processDescription']
                  as Map<String, dynamic>,
                  processUrl:
                  document.data()['processUrl'] as Map<String, dynamic>,
                  timedate: document.data()['timedate'] as String,
                  timestamp: document.data()['timestamp'] as int,
                  userId: document.data()['userId'] as String,
                ),
              );
            }
          });
          print("점심 or 저녁 시간 때 식사 요리 다운로드 완료");
        });
      }
    }
    notifyListeners();
  }

  Future<void> sortRecipesByLike() async {
    // 인기 레시피 정렬
    _popularRecipes = _recipeInformation;
    _popularRecipes.sort((a, b) => b.like.compareTo(a.like)); // 내림차순 정렬
    print('인기 레시피 정렬 완료!');
    notifyListeners();
  }

  List<RecipeInfo> _recipeInformation = [];
  List<RecipeInfo> get recipeInformation => _recipeInformation;

  List<RecipeInfo> _favoriteRecipes = [];
  List<RecipeInfo> get favoriteRecipes => _favoriteRecipes;

  List<RecipeInfo> _weatherRecipes = [];
  List<RecipeInfo> get weatherRecipes => _weatherRecipes;

  List<RecipeInfo> _myRecipes = [];
  List<RecipeInfo> get myRecipes => _myRecipes;

  List<RecipeInfo> _popularRecipes = [];
  List<RecipeInfo> get popularRecipes => _popularRecipes;
}

class RecipeInfo {
  // 레시피 정보를 담는 구조체
  RecipeInfo(
      {required this.detailUrl,
      required this.docId,
      required this.etcMaterial,
      required this.foodName,
      required this.ingredient,
      required this.kategorie,
      required this.like,
      required this.likeusers,
      required this.name,
      required this.path,
      required this.processDescription,
      required this.processUrl,
      required this.timedate,
      required this.timestamp,
      required this.userId});

  final String detailUrl;
  final String docId;
  final String etcMaterial;
  final String foodName;
  final List<dynamic> ingredient;
  final List<dynamic> kategorie;
  final int like;
  final List<dynamic> likeusers;
  final String name;
  final String path;
  final Map<String, dynamic> processDescription;
  final Map<String, dynamic> processUrl;
  final String timedate;
  final int timestamp;
  final String userId;
}
