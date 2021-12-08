import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uana_project/homepage/popular_recipe.dart';
import 'package:uana_project/provider/recipe_provider.dart';
import 'package:uana_project/provider/refrigerator_provider.dart';
import 'package:uana_project/refrigerator/refrigerator_calendar.dart';
import 'package:uana_project/theme/light_colors.dart';
import 'package:uana_project/provider/weather_provider.dart';
import '../provider/login_provider.dart';
import '../homepage/my_recipe.dart';
import '../provider/notification_provider.dart';
import '../homepage/weather_recipe.dart';
import '../login.dart';
import '../home.dart';
import '../refrigerator/add_refrigerator.dart';
import '../refrigerator/refrigerator_detail.dart';


/*
전체 app 관리하는 파일
 */
class UanaApp extends StatefulWidget {
  const UanaApp({Key? key}) : super(key: key);

  @override
  _UanaAppState createState() => _UanaAppState();
}
class _UanaAppState extends State<UanaApp> {

  @override
  Widget build(BuildContext context) {
    //RecipeProvider recipeProvider = Provider.of(context, listen: true);
    //WeatherProvider weatherProvider = Provider.of(context, listen: true);
    RefrigeratorProvider refrigeratorProvider = Provider.of(context, listen: true);

    return MaterialApp(
      /*
      theme : ThemeData(
        primaryColor : Colors.grey,
        appBarTheme : const AppBarTheme(
          color : Colors.grey,
        ),
      ),

       */
      title: 'Uana',
      home: const LoginPage(),
      initialRoute: '/login',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: LightColors.eachRecipe,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontFamily: 'DoHyeonRegular'),
          iconTheme: IconThemeData(
            color: Colors.black.withOpacity(0.7),
          ),

        ),
        fontFamily: 'DoHyeonRegular',

        canvasColor: LightColors.homeback,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.lightGreen,
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.lightGreen,
        ),

        toggleButtonsTheme: ToggleButtonsThemeData(
          color: Colors.black.withOpacity(0.60),
          selectedColor: Colors.green,
          selectedBorderColor: Colors.green,
          fillColor: Colors.green.withOpacity(0.08),
          splashColor: Colors.green.withOpacity(0.12),
          hoverColor: Colors.green.withOpacity(0.04),
          borderRadius: BorderRadius.circular(4.0),
          constraints: const BoxConstraints(
            minWidth: 80.0,
            minHeight: 60.0,
          ),
        ),
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/add_refrigerator': (context) => const AddRefrigeratorPage(),
        '/weather_recipe': (context) => const WeatherRecipePage(),
        '/my_recipe': (context) => const MyRecipePage(),
        '/popular_recipe': (context) => const PopularRecipePage(),
        //'/profile' : (context) => const ProfilePage(),
      },
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => const LoginPage(),
      fullscreenDialog: true,
    );
  }
}