import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uana_project/recipe/recipe_detail.dart';
import 'package:uana_project/provider/recipe_provider.dart';
import 'package:uana_project/search/search_from_refri.dart';
import 'package:uana_project/provider/weather_provider.dart';
import 'package:weather/weather.dart';
import '../refrigerator/refrigerator_detail.dart';
import '../provider/refrigerator_provider.dart';
import '../refrigerator/add_refrigerator_detail.dart';
import '../provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
import 'dart:core';
import "package:google_maps_webservice/places.dart";


class WeatherRecipePage extends StatefulWidget {
  const WeatherRecipePage ({Key? key}) : super(key: key);

  @override
  _WeatherRecipePageState createState() => _WeatherRecipePageState();
}

class _WeatherRecipePageState extends State<WeatherRecipePage> {
  List<Card> _buildGridCards(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of(context, listen : true); // provider 사용

    if (recipeProvider.weatherRecipes.isEmpty) {
      print('아직 다운 안됐음');
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);

    return recipeProvider.weatherRecipes.map((recipe) {// 중간, 기말 때 썼던 예제 그대로
      String kate = "";
      for(int i=0; i< recipe.kategorie.length ; i++){
        if(i != 0){
          kate += ", ";
        }

        kate += recipe.kategorie[i] + "류";
      }
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailPage(recipe: recipe),
              ),
            );
          },
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
                      Text(kate,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'DoHyeonRegular'
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget printWeatherDescription(Weather? weather) {
    // 요리 과정 출력 (사진 + 과정) (사진 용량이 커서 띄우는데 오래 걸리네욥)
    String? weatherDescription;

    if(DateTime.now().hour >= 21) {
      weatherDescription = "야심한 밤 야식 어떠세요?";
    }
    else if(DateTime.now().hour >= 7 && DateTime.now().hour <= 10) {
      weatherDescription = "일찍 일어나셨군요! 간단하게 아침 어떠세요?";
    }
    else if(weather!.weatherDescription!.toLowerCase() == "rain") {
      weatherDescription = "추적 추적 비가 오네요 비 오는 날엔 튀김이랑 전이 국룰인거 아시죠?";
    }
    else if(weather.tempFeelsLike!.celsius! <= 6.0) {
      weatherDescription = "날이 참 춥네요 따뜻한 국물 요리 어떠세요?";
    }
    else if(weather.tempFeelsLike!.celsius! >= 27.0) {
      weatherDescription = "날이 참 덥네요 스트레스를 확 풀어줄 매운 음식 어떠세요?";
    }

    return Text(
        weatherDescription!,
        maxLines: 3,
      style: TextStyle(
        fontSize: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WeatherProvider weatherProvider = Provider.of(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('오늘의 추천 요리'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * (1 / 10),
            width: MediaQuery.of(context).size.width,
            child: Align(
                alignment: Alignment.center,
                child: printWeatherDescription(weatherProvider.weather)
            ),
          ),
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
