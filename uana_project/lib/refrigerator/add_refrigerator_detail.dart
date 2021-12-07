import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/login_provider.dart';
import '../provider/notification_provider.dart';
import '../provider/refrigerator_provider.dart';
import 'dart:core';

class AddRefrigeratorDetailPage extends StatefulWidget {
  final FoodInfo food;

  const AddRefrigeratorDetailPage ({Key? key, required this.food}) : super(key: key);

  @override
  _AddRefrigeratorDetailPageState createState() => _AddRefrigeratorDetailPageState();
}
/*
자신의 냉장고에 물품 추가하는 페이지 (Detail)
 */
class _AddRefrigeratorDetailPageState extends State<AddRefrigeratorDetailPage> {

  DateTime? _selectedTime = DateTime.now(); // 등록 일자 오늘
  List<bool> isSelected = [true, false, false]; // 냉장 / 냉동 / 실온
  String storageType = "냉장"; // 보관 형태 디폴트값 냉장

  void showDatePickerPop() { // DatePicker 유통기한 선택시 띄움
    Future<DateTime?> selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(), // 초기값
      firstDate: DateTime(2021), // 시작일
      lastDate: DateTime(2025), // 마지막일
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green,
            ),
          ),
          child: child!,
        );
      }
    );

    selectedDate.then((dateTime) {
      setState(() {
        _selectedTime = dateTime!; // 유통기한
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    RefrigeratorProvider refrigeratorProvider = Provider.of(context, listen: true); // Refrigerator Provider 사용
    NotificationProvider notificationProvider = Provider.of(context, listen: true); // Notification Provider 사용
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.foodName),
      ),

      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  SizedBox(height: 30.0),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * (1 / 6),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      widget.food.foodName,
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),


                  Text(
                    '추가된 날짜 : ${DateTime.now().year}. ${DateTime.now().month}. ${DateTime.now().day}',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ), // 오늘 날짜

                  SizedBox(height: 30.0),

                  Row(
                    children: [
                      Expanded(
                        child: Text('유통 기한 : ',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Text(
                          '${_selectedTime!.year}. ${_selectedTime!.month}. ${_selectedTime!.day}',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ), // 유통 기한
                      ),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            showDatePickerPop(); // Date picker 띄우기
                          },
                          child: const Text('날짜 선택',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30.0),

                  const Text(
                    '보관형태',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),

                  SizedBox(height: 30.0),

                  ToggleButtons( // 냉장 / 냉동 / 실온 토글버튼
                    onPressed: (int index) {
                      setState(() {
                        for(int i = 0; i < isSelected.length; i++) { // 세 개 중 하나만 선택되도록 (라디오 버튼 처럼)
                          if(index == i) {
                            isSelected[i] = true;
                          }
                          else {
                            isSelected[i] = false;
                          }
                        }
                      });
                    },
                    isSelected: isSelected,

                    children: const [
                      Text(
                        '냉장',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        '냉동',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        '실온',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton( // 식재료 등록 버튼
                    onPressed: () async {
                      if(isSelected[0] == true) {
                        storageType = "냉장";
                      }
                      if(isSelected[1] == true) {
                        storageType = "냉동";
                      }
                      else {
                        storageType = "실온";
                      }

                      Navigator.pop(context);
                      refrigeratorProvider.uploadUserFoods(widget.food, _selectedTime!, storageType); // Firebase에 내 냉장고에 식재료 등록


                      var diff = _selectedTime!.difference(DateTime.now()).inDays.toString(); // 오늘 날짜부터 유통기한 계산
                      notificationProvider.expiredNotification(widget.food.foodCode, widget.food.foodName, diff); // 유통기한 일주일 전 알림 등록
                      refrigeratorProvider.downloadUserFoods();
                    },
                    child: const Text(
                      '식재료 등록',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
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