import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recipe_provider.dart';
import 'login_provider.dart';
import 'app.dart';

/*
main
 */
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()), // provider 사용
        ChangeNotifierProvider(create: (context) => RecipeProvider()), // provider 사용
      ],
      child: const UanaApp(),
    ),
  );
}
