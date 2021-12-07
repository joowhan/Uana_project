import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uana_project/provider/recipe_provider.dart';
import 'provider/notification_provider.dart';
import 'provider/refrigerator_provider.dart';
import 'provider/login_provider.dart';
import 'provider/weather_provider.dart';
import 'recipe/app.dart';

/*
main
 */
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()), // provider 사용
        ChangeNotifierProvider(create: (context) => RecipeProvider()), // provider 사용
        ChangeNotifierProvider(create: (context) => WeatherProvider()), // provider 사용
        ChangeNotifierProvider(create: (context) => RefrigeratorProvider()), // provider 사용
        ChangeNotifierProvider(create: (context) => NotificationProvider()), // provider 사용
      ],
      child: const UanaApp(),
    ),
  );
}
