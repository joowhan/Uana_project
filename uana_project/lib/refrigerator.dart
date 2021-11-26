import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'refrigerator_detail.dart';
import 'refrigerator_provider.dart';
import 'add_refrigerator_detail.dart';
import 'login_provider.dart';
import 'package:provider/provider.dart';
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
/*
    return Column(
      children: [
        Expanded(
          child: GridView.count( // 카드 한 줄에 하나씩 출력 되도록
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 5,
            padding: const EdgeInsets.all(16.0),
            childAspectRatio: 8.0 / 9.0,
            children: refrigeratorProvider.userfoodInformation.map((userFoodInfo userfood) {
              return ElevatedButton(
                  onPressed: () {

                  },
                  child: Text(userfood.foodName)
              );
            }).toList(),
          ),
        ),




      ],
    );
  */
    return ListView(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 5,
          padding: const EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: refrigeratorProvider.userfoodInformation.map((userFoodInfo userfood) { // 내 냉장고에 등록된 식재료 버튼화로 띄우기
            return ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RefrigeratorDetailPage(userfood: userfood), // 내 냉장고에 있는 식재료 디테일 페이지로 연결
                    ),
                  );
                },
                child: Text(userfood.foodName)
            );
          }).toList(),
        ),
        Row(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_refrigerator'); // 내 냉장고에 새로운 식재료 등록하는 페이지로 연결
                },
                child: Text('식재료 등록'),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('식재료 삭제'), // 식재료 삭제 버튼은 구현 안했음
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('레시피 검색'), // 내 냉장고에 있는 재료들로 할 수 있는 레시피 검색, 아직 구현 안함
        ),
      ],
    );
  }
}