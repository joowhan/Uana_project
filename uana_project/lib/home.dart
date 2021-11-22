import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'login_provider.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import 'refrigerator.dart';
import 'search.dart';
import 'favorite.dart';
import 'profile.dart';

/*
Home 화면
 */
class HomePage extends StatefulWidget {
  const HomePage ({Key? key}) : super(key: key);
  //final UserInformation users;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [const HomeScreen(), const RefrigeratorPage(), const SearchPage(),
    const FavoritePage(), const ProfilePage()]; // 하단 네비게이션바 목록

  void _onTap(int index) { // 네이버게이션바 눌릴 때 이동
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.home) // 홈화면
            ),
            Tab(
                icon: Icon(FontAwesomeIcons.box) // 나의 냉장고 화면
            ),
            Tab(
                icon: Icon(Icons.search) // 전체 레시피 화면
            ),
            Tab(
                icon: Icon(Icons.star) // Favorite 레시피 화면
            ),
            Tab(
                icon: Icon(Icons.person) // profile 화면 (로그아웃 가능)
            ),
          ],
          indicatorColor: Colors.transparent,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
        ),
        body: TabBarView(
          children: _pages,
        ),
      ),
    );
  }
}

/*
HomeScreen은 네비게이션바가 Home이 선택됐을 때 별도로 띄우는 화면
그냥 HomePage 띄우면 화면 이상하게 나와요
 */
class HomeScreen extends StatefulWidget {
  const HomeScreen ({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Firebase Meetup'),
      // ),
        body: Container(
          child: Column(
            children: <Widget> [
              ClipOval(
                child: Material(
                  color: Colors.blue, // Button color
                  child: InkWell(
                    splashColor: Colors.red, // Splash color
                    onTap: () {},
                    child: SizedBox(width: 150, height: 150, child: Icon(Icons.menu)),
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colors.blue, // Button color
                  child: InkWell(
                    splashColor: Colors.red, // Splash color
                    onTap: () {},
                    child: SizedBox(width: 150, height: 150, child: Text('식재료')),
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colors.blue, // Button color
                  child: InkWell(
                    splashColor: Colors.red, // Splash color
                    onTap: () {},
                    child: Container(
                        width: 150,
                        height: 150,

                        child: const Text(
                          '식재료',
                          style:TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        )
                    ),
                  ),
                ),
              )

            ],

          ),
          //const SizedBox(height: 30.0),



          //const SizedBox(height: 30.0),
        ),
    );
  }
}