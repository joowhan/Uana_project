import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uana_project/recipe_detail.dart';
import 'package:uana_project/recipe_provider.dart';
import 'package:uana_project/search_from_refri.dart';
import 'package:uana_project/weather_provider.dart';
import 'package:weather/weather.dart';
import 'refrigerator_detail.dart';
import 'refrigerator_provider.dart';
import 'add_refrigerator_detail.dart';
import 'login_provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
import 'dart:core';
import "package:google_maps_webservice/places.dart";


class MyRecipePage extends StatefulWidget {
  const MyRecipePage ({Key? key}) : super(key: key);

  @override
  _MyRecipePageState createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<MyRecipePage> {
  List<Card> _buildGridCards(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of(context, listen : true); // provider 사용

    if (recipeProvider.myRecipes.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);

    return recipeProvider.myRecipes.map((recipe) {// 중간, 기말 때 썼던 예제 그대로
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,

              child: Image.network(
                recipe.path,
                fit: BoxFit.fitWidth,
              ),

            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      recipe.foodName,
                      style: theme.textTheme.headline6,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8.0),
                    /*
                    Text(
                      '카테고리: ${recipe.cookingTime}',
                      style: theme.textTheme.subtitle2,
                    ),

                     */
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: SizedBox(
                    width: 50.0,
                    height: 25.0,
                    child: TextButton(
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(recipe: recipe),
                          ),
                        );


                      },
                      child: const Text(
                        'more',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget printWeatherDescription(Weather? weather) {
    // 요리 과정 출력 (사진 + 과정) (사진 용량이 커서 띄우는데 오래 걸리네욥)
    String? weatherDescription;

    if(DateTime.now().hour >= 21) {
      weatherDescription = "와우! 야심한 밤 야식 어떠세요?";
    }
    else if(DateTime.now().hour >= 7 && DateTime.now().hour <= 10) {
      weatherDescription = "와우! 일찍 일어나셨군요! 간단하게 아침 어떠세요?";
    }
    else if(weather!.weatherDescription!.toLowerCase() == "rain") {
      weatherDescription = "와우! 추적 추적 비가 오네요 비 오는 날엔 튀김이랑 전이 국룰인거 아시죠?";
    }
    else if(weather.tempFeelsLike!.celsius! <= 6.0) {
      weatherDescription = "와우! 날이 참 춥네요 따뜻한 국물 요리 어떠세요?";
    }
    else if(weather.tempFeelsLike!.celsius! >= 27.0) {
      weatherDescription = "와우! 날이 참 덥네요 스트레스를 확 풀어줄 매운 음식 어떠세요?";
    }

    return SizedBox(
      width: 300,
      height: 30,
      child: Text(weatherDescription!),
    );
  }

  @override
  Widget build(BuildContext context) {
    WeatherProvider weatherProvider = Provider.of(context, listen: true);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          printWeatherDescription(weatherProvider.weather),
          Expanded(
            child: GridView.count( // 카드 한 줄에 하나씩 출력 되도록
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              childAspectRatio: 8.0 / 9.0,
              children: _buildGridCards(context),
            ),
          ),
        ],
      ),

    );
  }
}
