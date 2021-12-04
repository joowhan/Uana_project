import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'login_provider.dart';
import 'notification_provider.dart';
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
        centerTitle: true,
        title: Text(widget.userfood.foodName),
        backgroundColor: Colors.grey,
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
        padding: EdgeInsets.all(15.0),
        child: ListView( // 내 냉장고에 등록된 식재료 상세 정보 출력

          children: [
            Text(widget.userfood.foodName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Text('추가된 날짜 : ' + fmt_registerDate), // 변경 필요 Timestamp 형식이라서 손 봐야할 듯
            // Text(DateTime.now().toString()),
            Text('유통 기한 : ' + fmt_expiredDate + ' 까지'), // 변경 필요 Timestamp 형식이라서 손 봐야할 듯
            Row(
              children: [
                Text(diff,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(' 일 남았습니다.')
              ],
            ),
            Text('보관형태 : ${widget.userfood.storageType}'),
          ],
        ),
      ),
    );
  }

}