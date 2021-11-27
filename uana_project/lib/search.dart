import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uana_project/recipe_create.dart';
import 'recipe_detail.dart';
import 'login_provider.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import 'recipe_provider.dart';

/*
전체 레시피 화면 (추후에 검색 기능 추가하도록)
 */
class SearchPage extends StatefulWidget {
  const SearchPage ({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Card> _buildGridCards(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of(context, listen : true); // provider 사용

    if (recipeProvider.recipeInformation.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);

    return recipeProvider.recipeInformation.map((recipe) {// 중간, 기말 때 썼던 예제 그대로
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,

              child: Image.network(
                recipe.imageUrl,
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
                      recipe.recipeName,
                      style: theme.textTheme.headline6,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '소요 시간: ${recipe.cookingTime}',
                      style: theme.textTheme.subtitle2,
                    ),
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(
            Icons.add,
            semanticLabel: 'add',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipeCreate(context)),
            );
          },
        ),
        Expanded(
          child: GridView.count( // 카드 한 줄에 하나씩 출력 되도록
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 1,
            padding: const EdgeInsets.all(16.0),
            childAspectRatio: 8.0 / 9.0,
            children: _buildGridCards(context),
          ),
        ),
      ],
    );
  }
}