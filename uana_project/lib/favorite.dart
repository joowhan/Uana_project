import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'login_provider.dart';
import 'package:provider/provider.dart';
import 'dart:core';

/*
Favorite 레시피 관리하는 페이지
 */
class FavoritePage extends StatefulWidget {
  const FavoritePage ({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text('Favorite'),
      ],
    );
  }
}