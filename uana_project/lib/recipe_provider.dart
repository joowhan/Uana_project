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
          .collection('recipes')
          .snapshots()
          .listen((snapshot) {
            _recipeInformation = [];
            for(final document in snapshot.docs) {
              _recipeInformation.add(
                RecipeInfo(
                  cookingTime: document.data()['cooking_time'] as String,
                  description: document.data()['decsription'] as String,
                  detailUrl: document.data()['detail_url'] as String,
                  foodC: document.data()['food_c'] as String,
                  imageUrl: document.data()['image_url'] as String,
                  ingredientMain: document.data()['ingredient_main'] as Map<String, dynamic>,
                  ingredientSauce: document.data()['ingredient_sauce'] as Map<String, dynamic>,
                  ingredientSub: document.data()['ingredient_sub'] as Map<String, dynamic>,
                  level: document.data()['level'] as String,
                  processDescription: document.data()['process_description'] as Map<dynamic, dynamic>,
                  processUrl: document.data()['process_url'] as Map<dynamic, dynamic>,
                  recipeCode: document.data()['recipeCode'] as int,
                  recipeName: document.data()['recipeName'] as String,
                  typeC: document.data()['type_c'] as String,
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
  RecipeInfo({required this.cookingTime, required this.description, required this.detailUrl, required this.foodC,
    required this.imageUrl, required this.ingredientMain, required this.ingredientSauce, required this.ingredientSub,
    required this.level, required this.processDescription, required this.processUrl, required this.recipeCode,
    required this.recipeName, required this.typeC});

  final String cookingTime;
  final String description;
  final String detailUrl;
  final String foodC;
  final String imageUrl;
  final Map<String, dynamic> ingredientMain;
  final Map<String, dynamic> ingredientSauce;
  final Map<String, dynamic> ingredientSub;
  final String level;
  final Map<dynamic, dynamic> processDescription;
  final Map<dynamic, dynamic> processUrl;
  final int recipeCode;
  final String recipeName;
  final String typeC;
}