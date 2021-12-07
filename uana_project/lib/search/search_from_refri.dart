import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uana_project/provider/recipe_provider.dart';
import 'package:uana_project/recipe/recipe_create.dart';
import '../recipe/recipe_detail.dart';
import '../provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import '../recipe/recipe_create.dart';

/*
전체 레시피 화면 (추후에 검색 기능 추가하도록)
 */
class SearchFromRefriPage extends StatefulWidget {
  final List<String> userRefriInfo;
  const SearchFromRefriPage ({Key? key, required this.userRefriInfo}) : super(key: key);

  @override
  _SearchFromRefriPageState createState() => _SearchFromRefriPageState();
}

class _SearchFromRefriPageState extends State<SearchFromRefriPage> {

  List<Card> _buildGridCards(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of(context, listen : true); // provider 사용

    if (recipeProvider.recipeInformation.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    var newrecipePro = recipeProvider.recipeInformation.where((element) {
      bool contain = false;
      for(int i=0; i < element.ingredient.length; i++){
        if(widget.userRefriInfo.contains(element.ingredient[i])){
          contain = true;
        }
      }
      return contain;
    });

    print(newrecipePro);
    print(widget.userRefriInfo);
    return newrecipePro.map((recipe) {// 중간, 기말 때 썼던 예제 그대로
      String kate = "";
      for(int i=0; i< recipe.kategorie.length ; i++){
        if(i != 0){
          kate += ", ";
        }

        kate += recipe.kategorie[i] + "류";
      }
      // print(recipe);
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
                      const SizedBox(height: 8.0),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('냉장고 파먹기'),
      ),
      body: Column(
        children: <Widget>[
          // IconButton(
          //   icon: const Icon(
          //     Icons.add,
          //     semanticLabel: 'add',
          //   ),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => RecipeCreate(context)),
          //     );
          //   },
          // ),
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
      )
    );
  }
}