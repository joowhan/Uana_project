import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

/*
레시피 provider
 */
class RefrigeratorProvider extends ChangeNotifier {
  RefrigeratorProvider() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
    downloadFoods();
    downloadUserFoods();
  }

  Future<void> downloadFoods() async { // 전체 식재료 받아옴 (받아오는데 시간 걸려서 클릭 후 다른 데 갔다가 오면 다 받아지더라)

    FirebaseAuth.instance.userChanges().listen((user) {
      FirebaseFirestore.instance
          .collection('food')
          .snapshots()
          .listen((snapshot) {
        _foodInformation = [];
        for(final document in snapshot.docs) {
          _foodInformation.add(
            FoodInfo(
              foodCode: document.data()['foodCode'] as int,
              foodName: document.data()['foodName'] as String,
            ),
          );
        }
      });
      print("냉장고 전체 식재료 받아오기 완료!");
    });
    notifyListeners();
  }

  Future<void> downloadUserFoods() async { // 유저의 냉장고에 있는 식재료를 받아옴
    FirebaseAuth.instance.userChanges().listen((user) {
      FirebaseFirestore.instance
          .collection('refrigerator')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get().then((value) {
            _userfoodInformation = [];
            value.data()!['foods'].forEach((element) {
              _userfoodInformation.add(
                userFoodInfo(
                  foodCode: element['foodCode'] as int,
                  foodName: element['foodName'] as String,
                  registerDate: element['registerDate'] as Timestamp,
                  expiredDate: element['expiredDate'] as Timestamp,
                  storageType: element['storageType'] as String,
                ),
              );
            });
      });
      print("유저 냉장고 식재료 받아오기 완료!");
    });
    notifyListeners();
  }

  Future<void> uploadUserFoods(FoodInfo food, DateTime expiredDate, String storageType) async { // 유저의 냉장고에 하나의 식재료 등록
    await FirebaseFirestore.instance
        .collection('refrigerator')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(<String, dynamic>{
          'foods': FieldValue.arrayUnion([{
          'foodCode': food.foodCode,
          'foodName': food.foodName,
          'registerDate': DateTime.now(),
          'expiredDate': expiredDate,
          'storageType': storageType,
        }]),
    }, SetOptions(merge: true));
    //downloadUserFoods();
    notifyListeners();
  }

  Future<void> deleteUserFood(userFoodInfo userfood) async { // 유저의 냉장고에 있는 하나의 식재료 삭제
    await FirebaseFirestore.instance
        .collection('refrigerator')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
          'foods': FieldValue.arrayRemove([{
          'foodCode': userfood.foodCode,
          'foodName': userfood.foodName,
          'registerDate': userfood.registerDate,
          'expiredDate': userfood.expiredDate,
          'storageType': userfood.storageType,
      }]),
    });
    //downloadUserFoods();
    notifyListeners();
  }

  List<FoodInfo> _foodInformation = []; // 냉장고 식재료 전체 후보
  List<FoodInfo> get foodInformation => _foodInformation;

  List<userFoodInfo> _userfoodInformation = []; // 유저의 냉장고에 등록되어 있는 식재료만
  List<userFoodInfo> get userfoodInformation => _userfoodInformation;
}

class FoodInfo { // 냉장고 식재료 전체 후보
  FoodInfo({required this.foodCode, required this.foodName});

  final int foodCode;
  final String foodName;
}

class userFoodInfo { // 유저의 냉장고에 있는 식재료들
  userFoodInfo({required this.foodCode, required this.foodName,
  required this.registerDate, required this.expiredDate, required this.storageType});

  final int foodCode;
  final String foodName;
  final Timestamp registerDate;
  final Timestamp expiredDate;
  final String storageType;
}