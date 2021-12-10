import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:uana_project/home.dart';
import 'package:uana_project/other/forreadcsv.dart';
import 'package:uana_project/recipe/recipe_detail_youtube.dart';
import 'package:uana_project/provider/recipe_provider.dart';
import 'package:uana_project/search/search.dart';
import '../provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import 'package:numberpicker/numberpicker.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:video_player/video_player.dart';
import 'package:unicorndial/unicorndial.dart';

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
        if (widget.recipe.processDescription[key] != ' ') //null이 아니라 space가 하나 있었음.
          Column(
            children: <Widget>[
              _buildStep(
                  leadingTitle: "$key",
                  title: "Step".toUpperCase(),
                  content: "${widget.recipe.processDescription[key]}"),
            ],
          ),
        SizedBox(
          height: 20.0,
        ),

        if (widget.recipe.processUrl[key] != 'http://handong.edu/site/handong/res/img/logo.png')
          Container(
            width: 400,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Colors.redAccent,
            ),
            child: Image.network(widget.recipe.processUrl[key]),
          ),

        SizedBox(height: 20.0),
        //Text('$key : ${widget.recipe.processDescription[key]}'),
      ],
    );
  }

  Widget _buildStep(
      {required String leadingTitle,
        required String title,
        required String content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Material(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          color: Colors.red,
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Text(leadingTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0)),
          ),
        ),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title,
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
              SizedBox(
                height: 10.0,
              ),
              Text(content),
            ],
          ),
        )
      ],
    );
  }
  var ingreMap = Map<int, String>();
  late AutoScrollController autocontroller;
  final scrollDirection = Axis.vertical;
  Future _scrollToIndex() async {
    await autocontroller.scrollToIndex(1, preferPosition: AutoScrollPosition.end);
  }

  @override
  void initState() {
    super.initState();
    autocontroller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
  }
  @override
  Widget build(BuildContext context) {
    var childButtons = <UnicornButton>[];

    for (int i = 0; i < widget.recipe.ingredient.length; i++) {
      ingreMap[i] = widget.recipe.ingredient[i];
    }
    final ValueNotifier<List<dynamic>> _a = ValueNotifier<List<dynamic>>([]);
    _a.value = widget.recipe.likeusers;
    // bool _owner =
    //     FirebaseAuth.instance.currentUser!.uid == widget.recipe.likeusers;
    int _thislike = widget.recipe.like;
    final ValueNotifier<int> _counter = ValueNotifier<int>(_thislike);

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "timer",
        currentButton: FloatingActionButton(
          heroTag: "start",
          backgroundColor: Colors.redAccent,
          mini: true,
          child: Icon(Icons.not_started),
          onPressed: () {
            _controller.restart(duration: _duration);
          },
        )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            heroTag: "pause",
            backgroundColor: Colors.greenAccent,
            mini: true,
            onPressed: () {
              _controller.pause();
            },
            child: Icon(Icons.pause))));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            heroTag: "resume",
            backgroundColor: Colors.blueAccent,
            mini: true,
            onPressed: () {
              _controller.resume();
            },
            child: Icon(Icons.restart_alt))));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            heroTag: "movt2timer",
            backgroundColor: Colors.yellow,
            mini: true,
            onPressed: _scrollToIndex,
            child: Icon(Icons.alarm))));

    RecipeProvider recipeProvider = Provider.of(context, listen: true); // provider 사용
    print(widget.recipe.likeusers);
    void _delete(RecipeInfo doc) {
      FirebaseFirestore.instance.collection('forUana').doc(doc.docId).delete();
      Navigator.pop(context);
      recipeProvider.loadRecipes();
    }

    _onAlertButtonsPressed(context) {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "해당 레시피를 삭제시겠습니까?",
        buttons: [
          DialogButton(
            child: Text(
              "삭제",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () async{
              _delete(widget.recipe);
              Future.delayed(const Duration(milliseconds: 1000), () {
                recipeProvider.loadRecipes();
                Navigator.pop(context);
              });

            },
            color: Color.fromRGBO(0, 179, 134, 1.0),
          ),
          DialogButton(
            child: Text(
              "취소",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () => Navigator.pop(context),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(116, 116, 191, 1.0),
              Color.fromRGBO(52, 138, 199, 1.0),
            ]
            ),
          )
        ],
      ).show();
    }

    return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('${widget.recipe.foodName}'),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {

                      Navigator.of(context).pop();
                      recipeProvider.loadRecipes();

                }
              ),
              // title: Text(
              //   widget.recipe.foodName,
              //   style: TextStyle(fontStyle: FontStyle.normal),
              // ),
              //backgroundColor: Colors.grey,
              actions: <Widget>[

                IconButton(
                  icon: Icon(Icons.delete),

                  onPressed: () => _onAlertButtonsPressed(context),
                ),


              ],
            ),
            body: ListView(
                padding: EdgeInsets.all(20.0),
                controller: autocontroller,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  AutoScrollTag(
                    key : ValueKey(0),
                    index : 0,
                    controller: autocontroller,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * (2 / 5),
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            widget.recipe.path,
                            fit: BoxFit.fill,
                          ),
                        ),


                        Container(
                          margin: EdgeInsets.fromLTRB(5.0, 10.0, 20, 0),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.st,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                '${widget.recipe.foodName}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              FlatButton.icon(
                                icon: Icon(Icons.play_circle_filled, color: Colors.red),
                                label: Text("Watch Recipe"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Player(
                                          widget.recipe.detailUrl, widget.recipe.foodName),
                                    ),
                                  );
                                },
                              ),


                              ValueListenableBuilder(
                                  valueListenable: _counter,
                                  builder: (BuildContext context, int value, Widget? child) {
                                    return
                                      ValueListenableBuilder(
                                          valueListenable: _a,
                                          builder: (BuildContext context, List<dynamic> avalue, Widget? child) {
                                            return Row(
                                              children: [

                                                avalue.contains(
                                                    FirebaseAuth.instance.currentUser!.uid)
                                                    ? IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints: BoxConstraints(),
                                                  icon: Icon(Icons.star),
                                                  color: Colors.red,
                                                  iconSize: 40,
                                                  onPressed: () async{
                                                    _counter.value -= 1;
                                                    _a.value.remove(FirebaseAuth.instance.currentUser!.uid.toString());
                                                    await FirebaseFirestore.instance
                                                        .collection("forUana")
                                                        .doc(widget.recipe.docId)
                                                        .update({
                                                      'like': _counter.value,
                                                      'likeusers': FieldValue.arrayRemove(
                                                          [FirebaseAuth.instance.currentUser!.uid])
                                                    });
                                                  },
                                                )
                                                    : IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints: BoxConstraints(),
                                                  icon: Icon(Icons.star_border),
                                                  color: Colors.red,
                                                  iconSize: 40,
                                                  onPressed: () async{
                                                    _counter.value += 1;
                                                    _a.value.add(FirebaseAuth.instance.currentUser!.uid.toString());
                                                    await FirebaseFirestore.instance
                                                        .collection("forUana")
                                                        .doc(widget.recipe.docId)
                                                        .update({
                                                      'like': _counter.value,
                                                      'likeusers': FieldValue.arrayUnion(
                                                          [FirebaseAuth.instance.currentUser!.uid])
                                                    });
                                                  },
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                    _counter.value.toString(),
                                                    semanticsLabel: 'like_you',
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                      );
                                  }
                              ),


                            ],
                          ),
                        ),


                        // const SizedBox(
                        //   height: 16.0,
                        // ),
                        Divider(color: Colors.grey, height: 32),
                        Container(
                          //padding: EdgeInsets.all(10.0),
                          child: const Text(
                            'What we need?\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),

                        GridView.count(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          crossAxisCount: 3,
                          padding: const EdgeInsets.all(5.0),
                          childAspectRatio: 5.0 / 2.0,
                          children: widget.recipe.ingredient.map((ingre) {
                            return Container(
                              height: 30,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(ingre),
                                        ],
                                      )),
                                  const VerticalDivider(),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        Align(
                          alignment: Alignment.center,
                          child: Text('기타 재료 : ${widget.recipe.etcMaterial}'),
                        ),
                        // for (int i = 0; i < widget.recipe.ingredient.length; i++)
                        //   Text('${widget.recipe.ingredient[i]}'), // 재료 목록
                        Divider(color: Colors.grey, height: 32),
                        Container(
                          //padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                          child: const Text(
                            '\n\nCategory\n\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),

                        GridView.count(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          crossAxisCount: 3,
                          padding: const EdgeInsets.all(5.0),
                          childAspectRatio: 5.0 / 3.0,
                          children: widget.recipe.kategorie.map((kate) {
                            //return Text(kate);

                            return Row(children: <Widget>[
                              if (kate == '식사')
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/meal.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text('식사')
                                    ],
                                  ),
                                ),
                              if (kate == '튀김')
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/deep-fryer.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text('튀김 음식')
                                    ],
                                  ),
                                ),
                              if (kate == '국물')
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/soup.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text('국물 음식')
                                    ],
                                  ),
                                ),
                              if (kate == '매운 음식')
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/chili-pepper.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text('매운 음식')
                                    ],
                                  ),
                                ),
                              if (kate == '야식')
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/fried-chicken.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text('야식')
                                    ],
                                  ),
                                ),
                              if (kate == '아침')
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/breakfast.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text('아침')
                                    ],
                                  ),
                                ),
                            ]);
                          }).toList(),
                        ),
                        // 카테고리 목록
                        Divider(color: Colors.grey, height: 32),
                        Container(
                          //padding: EdgeInsets.all(1.0),
                          child: const Text(
                            '\n\n요리 과정\n\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                        ),

                        for (dynamic key in widget.recipe.processDescription.keys)
                          getCookingProcess(key),
                        /*
            for (int i = 0; i < widget.recipe.processDescription.length; i++)
              getCookingProcess(i), // 요리 순서 출력

             */
                        // Container(

                        //     padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                        //     child: Row(
                        //       children: [
                        //         Text(
                        //           '\n\n요리 영상  => \n\n',
                        //           style: const TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 15,
                        //           ),
                        //         ),
                        //         TextButton(
                        //             onPressed: () {
                        //               Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                   builder: (context) => Player(
                        //                       widget.recipe.detailUrl,
                        //                       widget.recipe.foodName),
                        //                 ),
                        //               );
                        //             },
                        //             child: Text("보러 가기")),
                        //       ],
                        //     )),
                        Divider(color: Colors.grey, height: 32),
                        // AutoScrollTag(
                        //   key: ValueKey(1),
                        //   controller: autocontroller,
                        //   index: 1,
                        //   child: Container(
                        //     height: 100,
                        //     color: Colors.red,
                        //     margin: EdgeInsets.all(10),
                        //     child: Center(child: Text('index: 0')),
                        //   ),
                        //   highlightColor: Colors.black.withOpacity(0.1),
                        // ),

                      ],
                    ),
                  ),
                  AutoScrollTag(
                    key : ValueKey(1),
                    index: 1,
                    controller: autocontroller,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: const Text(
                              'Timer\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
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
                                        _duration = _currentHourValue * 3600 +
                                            _currentMinValue * 60 +
                                            _currentSecValue;
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
                                          _duration = _currentHourValue * 3600 +
                                              _currentMinValue * 60 +
                                              _currentSecValue;
                                        });
                                      }),
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
                                          _duration = _currentHourValue * 3600 +
                                              _currentMinValue * 60 +
                                              _currentSecValue;
                                        });
                                      }),
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
                              fillColor: Colors.redAccent,
                              // Filling Gradient for Countdown Widget.
                              fillGradient: null,
                              // Background Color for Countdown Widget.
                              backgroundColor: Colors.red,
                              // Background Gradient for Countdown Widget.
                              backgroundGradient: null,
                              // Border Thickness of the Countdown Ring.
                              strokeWidth: 15.0,
                              // Begin and end contours with a flat edge and no extension.
                              strokeCap: StrokeCap.round,
                              // Text Style for Countdown Text.
                              textStyle: const TextStyle(
                                  fontSize: 30.0,
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
                        ],
                      ),
                    ),
                  )

                ]),
                floatingActionButton: UnicornDialer(
                    backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
                    parentButtonBackground: Colors.redAccent,
                    orientation: UnicornOrientation.VERTICAL,
                    parentButton: Icon(Icons.timer),
                    childButtons: childButtons),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     SizedBox(
                //       width: 30,
                //     ),
                //     _button(title: "Start", onPressed: () => _controller.start()),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     _button(title: "Pause", onPressed: () => _controller.pause()),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     _button(title: "Resume", onPressed: () => _controller.resume()),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     _button(
                //         title: "Restart",
                //         onPressed: () => _controller.restart(duration: _duration))
                //   ],
                // ),
              );
            }



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


