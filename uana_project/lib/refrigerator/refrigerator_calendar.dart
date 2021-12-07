import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uana_project/provider/refrigerator_provider.dart';
import 'package:uana_project/theme/light_colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math';
import 'dart:core';

class CalendarPage extends StatefulWidget {
  final List<userFoodInfo> refrigerator;

  const CalendarPage({Key? key, required this.refrigerator}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));

    widget.refrigerator.map((userFoodInfo item) {
      meetings.add(Meeting(
          '${item.foodName} 유통 기한 만료',
          item.expiredDate.toDate(),
          item.expiredDate.toDate(),
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.9),
          true));
    }).toList();

    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('유통기한 한 눈에 보기'),
      ),
      body: Container(
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: MeetingDataSource(_getDataSource()),
          todayHighlightColor: Colors.green,
          cellBorderColor: Colors.lightGreen,
          showNavigationArrow: true,
          initialSelectedDate: DateTime.now(),
          selectionDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.lightGreen, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            shape: BoxShape.rectangle,
          ),
          monthViewSettings: const MonthViewSettings(
            showAgenda: true,
            navigationDirection: MonthNavigationDirection.horizontal,
            agendaItemHeight: 40,
            monthCellStyle: MonthCellStyle(
              textStyle:
                  TextStyle(fontFamily: 'DoHyeonRegular', color: Colors.black),
              leadingDatesTextStyle:
                  TextStyle(fontFamily: 'DoHyeonRegular', color: Colors.grey),
              trailingDatesTextStyle:
                  TextStyle(fontFamily: 'DoHyeonRegular', color: Colors.grey),
            ),
            agendaStyle: AgendaStyle(
              dayTextStyle:
                  TextStyle(fontFamily: 'DoHyeonRegular', color: Colors.black, fontSize: 16),
              dateTextStyle:
                  TextStyle(fontFamily: 'DoHyeonRegular', color: Colors.black, fontSize: 16),
              appointmentTextStyle:
                  TextStyle(fontFamily: 'DoHyeonRegular', fontSize: 18),
            ),
          ),
          headerStyle: const CalendarHeaderStyle(
            textStyle: TextStyle(
              fontFamily: 'DoHyeonRegular',
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          viewHeaderStyle: const ViewHeaderStyle(
            dayTextStyle:
                TextStyle(fontFamily: 'DoHyeonRegular', color: Colors.black),
            dateTextStyle:
                TextStyle(fontFamily: 'DoHyeonRegular', color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
