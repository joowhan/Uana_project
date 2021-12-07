import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/login_provider.dart';
import '../provider/notification_provider.dart';
import '../provider/refrigerator_provider.dart';
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
    NotificationProvider notificationProvider = Provider.of(context, listen: true); // Notification Provider 사용

    var registerdate = DateTime.fromMicrosecondsSinceEpoch(widget.userfood.registerDate.seconds * 1000000);
    var fmt_registerDate = DateFormat.yMMMMEEEEd().format(registerdate);

    var expireddate = DateTime.fromMicrosecondsSinceEpoch(widget.userfood.expiredDate.seconds * 1000000);
    var fmt_expiredDate = DateFormat.yMMMMEEEEd().format(expireddate);

    var diff = expireddate.difference(DateTime.now()).inDays.toString(); // 오늘 날짜부터 유통기한 계산

    if(int.parse(diff) < 100) {
      //_showNotification();
    }
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
              notificationProvider.cancelNotification(widget.userfood.foodCode); // 알림 삭제
              refrigeratorProvider.deleteUserFood(widget.userfood); // 내 냉장고에서 해당 식재료 삭제
              refrigeratorProvider.downloadUserFoods();
            },
          ),
        ],
      ),

      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView( // 내 냉장고에 등록된 식재료 상세 정보 출력
          children: [
            const SizedBox(height: 30.0),

            SizedBox(
              height: MediaQuery.of(context).size.height * (1 / 6),
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.userfood.foodName,
                style: const TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),


            Text(
              '추가된 날짜 : $fmt_registerDate',
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ), // 오늘 날짜

            const SizedBox(height: 30.0),

            Text(
              '유통 기한 : $fmt_expiredDate 까지',
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ), // 오늘 날짜

            const SizedBox(height: 30.0),

            Row(
              children: [
                Text(diff,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const Text(' 일 남았습니다.',
                style: TextStyle(
                    fontSize: 20.0,
                ),
              ),
              ],
            ),

            const SizedBox(height: 30.0),

            Text('보관형태 : ${widget.userfood.storageType}',
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

}