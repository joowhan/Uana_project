import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'login_provider.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import 'recipe_provider.dart';

/*
디테일 레시피 화면 - 아직 필드에 빈 값이 있으면 에러 뜬다!!
예) 더덕구이 --> process_url 없어서 에러 뜸!


* 요리 영상 (detail_url)은 링크가 유효하지 않은듯?!
* process_description이랑 process_url이랑 매치가 안되는 듯!
 */
class RecipeDetailPage extends StatefulWidget {
  final RecipeInfo recipe; // recipe.dart 에서 전달 받은 하나의 recipe

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipeDetailPage> {

  Widget getCookingProcess(dynamic key) { // 요리 과정 출력 (사진 + 과정) (현재 에러 뜸)
    print(widget.recipe.processUrl[key]);
    return Column(
      children: [
        if(widget.recipe.processUrl[key] != ' ')//null이 아니라 space가 하나 있었음.
          Image.network(widget.recipe.processUrl[key]),

        Text('${key} : ${widget.recipe.processDescription[key]}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.recipeName),
      ),

      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * (2/5),
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              widget.recipe.imageUrl,
              fit: BoxFit.fill,
            ),
          ),

          Text('재료 목록\n'),
          Text('주재료\n\n'),
          for(dynamic key in widget.recipe.ingredientMain.keys)
            Text('${key} : ${widget.recipe.ingredientMain[key]}'), // 주재료 목록

          Text('\n\n부재료\n\n'),
          for(dynamic key in widget.recipe.ingredientSub.keys)
            Text('${key} : ${widget.recipe.ingredientSub[key]}'), // 부재료 목록

          Text('\n\n양념\n\n'),
          for(dynamic key in widget.recipe.ingredientSauce.keys)
            Text('${key} : ${widget.recipe.ingredientSauce[key]}'), // 양념 목록

          Text('\n\n요리 순서\n\n'),
          for(dynamic key in widget.recipe.processDescription.keys)
            getCookingProcess(key), // 요리 순서 출력



          Text('\n\n요리 영상\n\n'), // 요리 영상 띄우기 (요리 영상 링크가 유효하지 않은듯?!)






        ],
      ),
    );
  }
}