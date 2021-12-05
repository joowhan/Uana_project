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


class PopularRecipePage extends StatefulWidget {
  const PopularRecipePage ({Key? key}) : super(key: key);

  @override
  _PopularRecipePageState createState() => _PopularRecipePageState();
}

class _PopularRecipePageState extends State<PopularRecipePage> {
  List<Card> _buildGridCards(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of(context, listen : true); // provider 사용

    if (recipeProvider.popularRecipes.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);

    return recipeProvider.popularRecipes.map((recipe) {// 중간, 기말 때 썼던 예제 그대로
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              recipe.foodName,
                              style: theme.textTheme.headline6,
                              maxLines: 1,
                            ),

                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.red,
                                size: 20,
                              ),
                              Text(
                                'x ${recipe.like}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
            ],
          ),
        ),
      );
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('인기 레시피'),
      ),
      body: Column(
        children: [
          //printWeatherDescription(weatherProvider.weather),
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
