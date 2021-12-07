import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uana_project/recipe/recipe_create.dart';
import 'package:uana_project/provider/recipe_provider.dart';
import 'package:uana_project/theme/light_colors.dart';
import '../recipe/recipe_detail.dart';
import '../provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import '../recipe/recipe_create.dart';

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
      String kate = "";
      for(int i=0; i< recipe.kategorie.length ; i++){
        if(i != 0){
          kate += ", ";
        }

        kate += recipe.kategorie[i] + "류";
      }
      return Card(
        // color: LightColors.eachRecipe,
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
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color : Colors.white,
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
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          recipe.foodName,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                          ),
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
        ),
      );
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecipeCreate(context)),
          );
        },
        child: const Icon(Icons.add),
        //backgroundColor: Colors.green,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
            "전체 레시피",
            style: TextStyle(
              fontSize: 30,
            )
        ),
      ),
      body: Container(
        color: LightColors.homeback,
        child: Column(
          children: [
            // Container(
            //   padding : EdgeInsets.fromLTRB(0, 30, 0, 0),
            //   margin : EdgeInsets.fromLTRB(0, 0, 0, 0),
            //   color: Colors.green,
            //   height: 80,
            //   width: 450,
            //   child: Text(
            //     "전체 레시피",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 40,
            // ),


            Expanded(
              child: GridView.count( // 카드 한 줄에 하나씩 출력 되도록
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20.0),
                childAspectRatio: 8.0 / 9.0,
                children: _buildGridCards(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}