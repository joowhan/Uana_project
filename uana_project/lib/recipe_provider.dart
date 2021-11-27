import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> loadRecipes() async { // 전체 레시피 받아옴 (받아오는데 시간 걸려서 Search Page 클릭 후 다른 데 갔다가 오면 다 받아지더라)
    FirebaseAuth.instance.userChanges().listen((user) {
      FirebaseFirestore.instance
          .collection('forUana')
          .snapshots()
          .listen((snapshot) {
            _recipeInformation = [];
            for(final document in snapshot.docs) {
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
                  processDescription: document.data()['processDescription'] as Map<String, dynamic>,
                  processUrl: document.data()['processUrl'] as Map<String, dynamic>,
                  timedate: document.data()['timedate'] as String,
                  timestamp: document.data()['timestamp'] as int,
                  userId: document.data()['userId'] as String,
                ),
              );
            }
      });
      print("레시피 받아오기 완료!");
    });
    notifyListeners();
  }

  List<RecipeInfo> _recipeInformation = [];
  List<RecipeInfo> get recipeInformation => _recipeInformation;
}

class RecipeInfo { // 레시피 정보를 담는 구조체
  RecipeInfo({required this.detailUrl, required this.docId, required this.etcMaterial, required this.foodName,
              required this.ingredient, required this.kategorie, required this.like, required this.likeusers,
              required this.name, required this.path, required this.processDescription, required this.processUrl,
              required this.timedate, required this.timestamp, required this.userId});

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