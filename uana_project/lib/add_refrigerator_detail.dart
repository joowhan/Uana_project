import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'login_provider.dart';
import 'refrigerator_provider.dart';
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
          data: ThemeData.light(),
          child: child!,
        );
      }
    );

    selectedDate.then((dateTime) {
      setState(() {
        _selectedTime = dateTime; // 유통기한
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    RefrigeratorProvider refrigeratorProvider = Provider.of(context, listen: true); // Refrigerator Provider 사용
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.foodName),
      ),

      body: ListView(
        children: [
          Text(widget.food.foodName),

          Text('추가된 날짜 : ${DateTime.now().year}. ${DateTime.now().month}. ${DateTime.now().day}'), // 오늘 날짜

          Row(
            children: [
              Expanded(
                child: Text('유통 기한'),
              ),

              Expanded(
                child: Text('${_selectedTime!.year}. ${_selectedTime!.month}. ${_selectedTime!.day}'), // 유통 기한
              ),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    showDatePickerPop(); // Date picker 띄우기
                  },
                  child: const Text('날짜 선택'),
                ),
              ),
            ],
          ),

          Text('보관형태'),

          ToggleButtons( // 냉장 / 냉동 / 실온 토글버튼
            color: Colors.black.withOpacity(0.60),
            selectedColor: Colors.blue,
            selectedBorderColor: Colors.blue,
            fillColor: Colors.blue.withOpacity(0.08),
            splashColor: Colors.blue.withOpacity(0.12),
            hoverColor: Colors.blue.withOpacity(0.04),
            borderRadius: BorderRadius.circular(4.0),

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
              Text('냉장'),
              Text('냉동'),
              Text('실온'),
            ],
          ),

          ElevatedButton( // 식재료 등록 버튼
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
              await refrigeratorProvider.uploadUserFoods(widget.food, _selectedTime!, storageType); // Firebase에 내 냉장고에 식재료 등록
              Navigator.pop(context);
            },
            child: Text('식재료 등록'),
          ),

        ],
      ),
    );
  }

}