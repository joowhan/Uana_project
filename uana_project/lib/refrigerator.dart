import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
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
    return ListView(
      children: [
        Text('Refrigerator'),
      ],
    );
  }
}