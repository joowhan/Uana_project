import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'login_provider.dart';
import 'refrigerator_provider.dart';
import 'dart:core';

class RefrigeratorDetailPage extends StatefulWidget {
  final userFoodInfo userfood;

  const RefrigeratorDetailPage ({Key? key, required this.userfood}) : super(key: key);

  @override
  _RefrigeratorDetailPageState createState() => _RefrigeratorDetailPageState();
}
/*
자신의 냉장고에 물품 상세 페이지 또는 삭제 페이지
 */
class _RefrigeratorDetailPageState extends State<RefrigeratorDetailPage> {


  @override
  Widget build(BuildContext context) {
    RefrigeratorProvider refrigeratorProvider = Provider.of(context, listen: true); // Refrigerator Provider 사용
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userfood.foodName),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.delete,
              semanticLabel: 'delete',
            ),
            onPressed: () async {
              Navigator.pop(context);
              refrigeratorProvider.deleteUserFood(widget.userfood); // 내 냉장고에서 해당 식재료 삭제
            },
          ),
        ],
      ),

      body: ListView( // 내 냉장고에 등록된 식재료 상세 정보 출력
        children: [
          Text(widget.userfood.foodName),

          Text('추가된 날짜 : ${widget.userfood.registerDate}'), // 변경 필요 Timestamp 형식이라서 손 봐야할 듯
          Text('유통 기한 ${widget.userfood.expiredDate}}'), // 변경 필요 Timestamp 형식이라서 손 봐야할 듯
          Text('보관형태 : ${widget.userfood.storageType}'),
        ],
      ),
    );
  }

}