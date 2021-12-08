import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uana_project/provider/recipe_provider.dart';
import 'package:uana_project/theme/light_colors.dart';
import 'add_recipe.dart';
import 'provider/weather_provider.dart';
import 'provider/login_provider.dart';
import 'dart:core';
import 'refrigerator/refrigerator.dart';
import 'search/search.dart';
import 'profile/favorite.dart';
import 'profile/profile.dart';

/*
Home 화면
 */
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const RefrigeratorPage(),
    const SearchPage(),
    const ProfilePage()
  ]; // 하단 네비게이션바 목록

  void _onTap(int index) {
    // 네이버게이션바 눌릴 때 이동
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.home), // 홈화면
              text: '홈',
              //height: 15.0,
            ),
            Tab(
              icon: Icon(FontAwesomeIcons.box), // 나의 냉장고 화면
              text: '냉장고',
            ),
            Tab(
              icon: Icon(Icons.fastfood), // 전체 레시피 화면
              text: '레시피',
            ),
            Tab(
              icon: Icon(Icons.person), // profile 화면 (로그아웃 가능)
              text: '내 정보',
            ),
          ],
          indicatorColor: Colors.transparent,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.lightGreen,
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
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of(context, listen: true);
    WeatherProvider weatherProvider = Provider.of(context, listen: true);
    return Column(
      children: [
        SizedBox(height: 30.0),
        Container(
          margin: EdgeInsets.fromLTRB(20, 30, 160, 0),
          child: Stack(
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  primary: LightColors.weatherRecipe,
                ),
                child: Container(
                  width: 180,
                  height: 180,
                  //margin: EdgeInsets.fromLTRB(0, 20, 30, 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Text(
                    '오늘 뭐 먹지?',
                    style:
                    TextStyle(fontSize: 28, color: LightColors.weatherfont),
                  ),
                ),
                onPressed: () async {
                  await recipeProvider
                      .loadWeatherRecipes(weatherProvider.weather);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Navigator.pushNamed(context, '/weather_recipe');
                  });
                },
              ),
              Positioned(
                top: 0,
                bottom: 120,
                left: 65,
                child: Container(
                    height: 75,
                    width: 75,
                    child: Image.asset('assets/cooking.png')
                ),
              ),
            ],
          ),
        ),
        // Container(
        //
        //     height: 30,
        //     width: 30,
        //     child: Image.asset('assets/onion2.png')
        // ),

        // IconButton(
        //   icon: Image.asset('assets/onion2.png'),
        //   iconSize: 50,
        //   onPressed: () async{
        //     await recipeProvider.loadWeatherRecipes(weatherProvider.weather);
        //     await Navigator.pushNamed(context, '/weather_recipe');
        //   },
        // ),

        Container(
          margin: EdgeInsets.fromLTRB(170, 5, 0, 0),
          child: Stack(
            children: <Widget> [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  primary: LightColors.myrecipe,
                ),
                child: Container(
                  width: 170,
                  height: 170,
                  //margin: EdgeInsets.fromLTRB(0, 20, 30, 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Text(
                    '나만의 레시피',
                    style: TextStyle(fontSize: 28, color: LightColors.myrecipefont),
                  ),
                ),
                onPressed: () {
                  recipeProvider.loadRecipes();
                  Navigator.pushNamed(context, '/my_recipe');
                },
              ),
              Positioned(
                top: 0,
                bottom: 100,
                left: 40,
                child: Container(
                    height: 75,
                    width: 75,
                    child: Image.asset('assets/cooking2.png')
                ),
              ),
            ],
          ),
        ),

        // ElevatedButton(
        //   onPressed: () {
        //     recipeProvider.loadRecipes();
        //     Navigator.pushNamed(context, '/my_recipe');
        //   },
        //   child: Text('나만의 레시피'),
        // ),

        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 140, 0),
          child: Stack(
            children: <Widget> [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  primary: LightColors.popular,
                ),
                child: Container(
                  width: 160,
                  height: 160,
                  //margin: EdgeInsets.fromLTRB(0, 20, 30, 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Text(
                    '인기 레시피',
                    style: TextStyle(fontSize: 28, color: LightColors.popularfont),
                  ),
                ),
                onPressed: () {
                  recipeProvider.loadRecipes();
                  Navigator.pushNamed(context, '/popular_recipe');
                },
              ),
              Positioned(
                top: 0,
                bottom: 100,
                left: 30,
                child: Container(
                    height: 75,
                    width: 75,
                    child: Image.asset('assets/egg.png')
                ),
              ),
              Positioned(
                top: 0,
                bottom: 100,
                left: 80,
                child: Container(
                    height: 75,
                    width: 75,
                    child: Image.asset('assets/onion1.png')
                ),
              ),
            ],
          ),

        ),
        //const SizedBox(height: 30.0),

        // ElevatedButton(
        //   onPressed: () {
        //     recipeProvider.loadRecipes();
        //     Navigator.pushNamed(context, '/popular_recipe');
        //   },
        //   child: Text('인기 레시피'),
        // ),

        //const SizedBox(height: 30.0),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'add_recipe.dart';
// import 'weather_provider.dart';
// import 'login_provider.dart';
// import 'dart:core';
// import 'refrigerator.dart';
// import 'search.dart';
// import 'favorite.dart';
// import 'profile.dart';
//
// /*
// Home 화면
//  */
// class HomePage extends StatefulWidget {
//   const HomePage ({Key? key}) : super(key: key);
//   //final UserInformation users;
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _pages = [const HomeScreen(), const RefrigeratorPage(), const SearchPage(),
//     const FavoritePage(), const ProfilePage()]; // 하단 네비게이션바 목록
//
//   void _onTap(int index) { // 네이버게이션바 눌릴 때 이동
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       initialIndex: 0,
//       length: 5,
//       child: Scaffold(
//         bottomNavigationBar: const TabBar(
//           tabs: [
//             Tab(
//               icon: Icon(Icons.home) // 홈화면
//             ),
//             Tab(
//                 icon: Icon(FontAwesomeIcons.box) // 나의 냉장고 화면
//             ),
//             Tab(
//                 icon: Icon(Icons.search) // 전체 레시피 화면
//             ),
//             Tab(
//                 icon: Icon(Icons.star) // Favorite 레시피 화면
//             ),
//             Tab(
//                 icon: Icon(Icons.person) // profile 화면 (로그아웃 가능)
//             ),
//           ],
//           indicatorColor: Colors.transparent,
//           unselectedLabelColor: Colors.grey,
//           labelColor: Colors.black,
//         ),
//         body: TabBarView(
//           children: _pages,
//         ),
//       ),
//     );
//   }
// }
//
// /*
// HomeScreen은 네비게이션바가 Home이 선택됐을 때 별도로 띄우는 화면
// 그냥 HomePage 띄우면 화면 이상하게 나와요
//  */
// class HomeScreen extends StatefulWidget {
//   const HomeScreen ({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     LoginProvider loginProvider = Provider.of(context, listen: true);
//
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Firebase Meetup'),
//       // ),
//         body: Container(
//           child: Column(
//             children: <Widget> [
//               ClipOval(
//                 child: Material(
//                   color: Colors.blue, // Button color
//                   child: InkWell(
//                     splashColor: Colors.red, // Splash color
//                     onTap: () {},
//                     child: SizedBox(width: 150, height: 150, child: Icon(Icons.menu)),
//                   ),
//                 ),
//               ),
//               ClipOval(
//                 child: Material(
//                   color: Colors.blue, // Button color
//                   child: InkWell(
//                     splashColor: Colors.red, // Splash color
//                     onTap: () {},
//                     child: SizedBox(width: 150, height: 150, child: Text('식재료')),
//                   ),
//                 ),
//               ),
//               ClipOval(
//                 child: Material(
//                   color: Colors.blue, // Button color
//                   child: InkWell(
//                     splashColor: Colors.red, // Splash color
//                     onTap: () {},
//                     child: Container(
//                         width: 150,
//                         height: 150,
//
//                         child: const Text(
//                           '식재료',
//                           style:TextStyle(
//                             color: Colors.white,
//                             fontSize: 30,
//                           ),
//                           textAlign: TextAlign.center,
//                         )
//                     ),
//                   ),
//                 ),
//               )
//
//             ],
//
//           ),
//           //const SizedBox(height: 30.0),
//
//
//
//           //const SizedBox(height: 30.0),
//         ),
//     );
//   }
// }