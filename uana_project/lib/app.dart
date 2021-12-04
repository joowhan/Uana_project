import 'package:flutter/material.dart';
import 'my_recipe.dart';
import 'weather_recipe.dart';
import 'login.dart';
import 'home.dart';
import 'add_refrigerator.dart';


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
        fontFamily: 'DoHyeonRegular'
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/add_refrigerator': (context) => const AddRefrigeratorPage(),
        '/weather_recipe': (context) => const WeatherRecipePage(),
        '/my_recipe': (context) => const MyRecipePage(),
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