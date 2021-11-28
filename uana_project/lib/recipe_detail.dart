import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'login_provider.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import 'recipe_provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

/*
디테일 레시피 화면
 */
class RecipeDetailPage extends StatefulWidget {
  final RecipeInfo recipe; // recipe.dart 에서 전달 받은 하나의 recipe

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipeDetailPage> {
  final CountDownController _controller = CountDownController();
  int _currentHourValue = 0;
  int _currentMinValue = 0;
  int _currentSecValue = 0;
  int _duration = 10;

  Widget getCookingProcess(dynamic key) {
    // 요리 과정 출력 (사진 + 과정) (사진 용량이 커서 띄우는데 오래 걸리네욥)
    print(widget.recipe.processUrl[key]);
    return Column(
      children: [
        if (widget.recipe.processUrl[key] != ' ') //null이 아니라 space가 하나 있었음.
          Image.network(widget.recipe.processUrl[key]),
        Text('$key : ${widget.recipe.processDescription[key]}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of(context, listen : true); // provider 사용
    print(widget.recipe.likeusers);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('forUana').doc(widget.recipe.docId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        /*if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Something went wrong');
        }*/

        var recipeDocument = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.recipe.foodName),
            ),
            body: ListView(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * (2 / 5),
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget.recipe.path,
                  fit: BoxFit.fill,
                ),
              ),

              Row(
                children: [
                  Text(
                    '${widget.recipe.foodName}\n',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  recipeDocument!['likeusers'].contains(FirebaseAuth.instance.currentUser!.uid) ?
                  IconButton(
                    icon: Icon(Icons.star),
                    color: Colors.red,
                    iconSize: 30,
                    onPressed: () {
                      recipeProvider.updateLike(recipeDocument['docId'], recipeDocument['like'], false);
                    },
                  ) : IconButton(
                    icon : Icon(Icons.star_border),
                    color: Colors.red,
                    iconSize: 30,
                    onPressed: () {
                      recipeProvider.updateLike(recipeDocument['docId'], recipeDocument['like'], true);
                    },
                  ),
                  Text(recipeDocument['like'].toString()),
                ],
              ),
              Text('재료 목록\n'),
              for (int i = 0; i < widget.recipe.ingredient.length; i++)
                Text('${widget.recipe.ingredient[i]}'), // 재료 목록

              Text('\n\n카테고리\n\n'),
              for (int i = 0; i < widget.recipe.kategorie.length; i++)
                Text('${widget.recipe.kategorie[i]}'), // 카테고리 목록


              Text('\n\n요리 과정\n\n'),
              for (dynamic key in widget.recipe.processDescription.keys)
                getCookingProcess(key),
              /*
        for (int i = 0; i < widget.recipe.processDescription.length; i++)
          getCookingProcess(i), // 요리 순서 출력

         */
              Text('\n\n요리 영상\n\n'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      NumberPicker(
                        value: _currentHourValue,
                        minValue: 0,
                        maxValue: 24,
                        step: 1,
                        haptics: true,
                        //onChanged: (value) => setState(() => _currentHourValue = value),
                        onChanged: (value) {
                          setState(() {
                            _currentHourValue = value;
                            _duration = _currentHourValue*3600 + _currentMinValue*60 + _currentSecValue;
                          });
                        },

                      ),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => setState(() {
                              final newValue = _currentHourValue - 1;
                              _currentHourValue = newValue.clamp(0, 24);
                            }),
                          ),
                          Text('H: $_currentHourValue'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => setState(() {
                              final newValue = _currentHourValue + 1;
                              _currentHourValue = newValue.clamp(0, 24);
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Column(
                    children: <Widget>[
                      NumberPicker(
                          value: _currentMinValue,
                          minValue: 0,
                          maxValue: 60,
                          step: 1,
                          haptics: true,
                          //onChanged: (value) => setState(() => _currentMinValue = value),
                          onChanged: (value) {
                            setState(() {
                              _currentMinValue = value;
                              _duration = _currentHourValue*3600 + _currentMinValue*60 + _currentSecValue;
                            });
                          }
                      ),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => setState(() {
                              final newValue = _currentMinValue - 1;
                              _currentMinValue = newValue.clamp(0, 60);
                            }),
                          ),
                          Text('M: $_currentMinValue'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => setState(() {
                              final newValue = _currentMinValue + 1;
                              _currentMinValue = newValue.clamp(0, 60);
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      NumberPicker(
                          value: _currentSecValue,
                          minValue: 0,
                          maxValue: 60,
                          step: 1,
                          haptics: true,
                          //onChanged: (value) => setState(() => _currentSecValue = value),
                          onChanged: (value) {
                            setState(() {
                              _currentSecValue = value;
                              _duration = _currentHourValue*3600 + _currentMinValue*60 + _currentSecValue;
                            });
                          }
                      ),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => setState(() {
                              final newValue = _currentSecValue - 1;
                              _currentSecValue = newValue.clamp(0, 60);
                            }),
                          ),
                          Text('S: $_currentSecValue'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => setState(() {
                              final newValue = _currentSecValue + 1;
                              _currentSecValue = newValue.clamp(0, 60);
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),


                ],
              ),

              Divider(color: Colors.grey, height: 32),
              SizedBox(height: 16),
              Center(
                child: CircularCountDownTimer(
                  // Countdown duration in Seconds.
                  duration: _duration,
                  // Countdown initial elapsed Duration in Seconds.
                  initialDuration: 0,
                  // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                  controller: _controller,
                  // Width of the Countdown Widget.
                  width: MediaQuery.of(context).size.width / 2,
                  // Height of the Countdown Widget.
                  height: MediaQuery.of(context).size.height / 2,
                  // Ring Color for Countdown Widget.
                  ringColor: Colors.grey[300]!,
                  // Ring Gradient for Countdown Widget.
                  ringGradient: null,
                  // Filling Color for Countdown Widget.
                  fillColor: Colors.purpleAccent[100]!,
                  // Filling Gradient for Countdown Widget.
                  fillGradient: null,
                  // Background Color for Countdown Widget.
                  backgroundColor: Colors.purple[500],
                  // Background Gradient for Countdown Widget.
                  backgroundGradient: null,
                  // Border Thickness of the Countdown Ring.
                  strokeWidth: 20.0,
                  // Begin and end contours with a flat edge and no extension.
                  strokeCap: StrokeCap.round,
                  // Text Style for Countdown Text.
                  textStyle: const TextStyle(
                      fontSize: 33.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  // Format for the Countdown Text.
                  textFormat: CountdownTextFormat.S,
                  // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                  isReverse: false,
                  // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                  isReverseAnimation: false,
                  // Handles visibility of the Countdown Text.
                  isTimerTextShown: true,
                  // Handles the timer start.
                  autoStart: false,
                  // This Callback will execute when the Countdown Starts.
                  onStart: () {
                    // Here, do whatever you want
                    print('Countdown Started');
                  },
                  // This Callback will execute when the Countdown Ends.
                  onComplete: () {
                    // Here, do whatever you want
                    print('Countdown Ended');
                  },
                ),
              )
            ]),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                ),
                _button(title: "Start", onPressed: () => _controller.start()),
                SizedBox(
                  width: 10,
                ),
                _button(title: "Pause", onPressed: () => _controller.pause()),
                SizedBox(
                  width: 10,
                ),
                _button(title: "Resume", onPressed: () => _controller.resume()),
                SizedBox(
                  width: 10,
                ),
                _button(
                    title: "Restart",
                    onPressed: () => _controller.restart(duration: _duration))
              ],
            ),
          );

      }
    );

  }

  _button({required String title, VoidCallback? onPressed}) {
    return Expanded(
        child: RaisedButton(
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: onPressed,
      color: Colors.purple,
    ));
  }
}

