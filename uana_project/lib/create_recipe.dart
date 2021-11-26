import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:shrine/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      home: App(),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Firebase load fail"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Home();
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> _dropdownValue = ValueNotifier<String>("ASC");
    final ValueNotifier<bool> _isasc = ValueNotifier<bool>(true);

    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (!snapshot.hasData) {
          return const LoginWidget();
        } else {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.grey,
              leading: IconButton(
                icon: const Icon(
                  Icons.person,
                  semanticLabel: 'mypage',
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => showProfile()),
                  // );
                },
              ),
              title: Text(
                FirebaseAuth.instance.currentUser!.emailVerified
                    ? "Welcome " +
                        FirebaseAuth.instance.currentUser!.displayName
                            .toString() +
                        "!"
                    : "Welcome Guest",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    semanticLabel: 'add',
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageFromGalleryEx(context)),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                // Text("${snapshot.data}님 환영합니다."),
                ValueListenableBuilder(
                    valueListenable: _dropdownValue,
                    builder:
                        (BuildContext context, String svalue, Widget? child) {
                      return DropdownButton<String>(
                        value: _dropdownValue.value,
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        iconSize: 24,
                        elevation: 16,
                        // style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          // color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          _dropdownValue.value = newValue!;
                          if (_dropdownValue.value == 'ASC') {
                            _isasc.value = true;
                            // print(_isasc.value);
                          } else {
                            _isasc.value = false;
                            // print(_isasc.value);
                          }
                        },
                        items: <String>['ASC', 'DESC']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      );
                    }),
                ValueListenableBuilder(
                    valueListenable: _isasc,
                    builder:
                        (BuildContext? context, bool? bvalue, Widget? value) {
                      // sleep(const Duration(seconds:1));
                      // print("그사이");
                      return Expanded(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("product")
                              .orderBy('price', descending: !_isasc.value)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            print("그사이");

                            return GridView.count(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(16.0),
                                childAspectRatio: (8.0) / (8.5),
                                crossAxisCount: 2,
                                children:
                                    List.generate(snapshot.data!.size, (index) {
                                  return Card(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 460,
                                          height: 100,
                                          child: Image.network(
                                            snapshot.data!.docs[index]['path'],
                                            fit: BoxFit.fill, //이미지가 딱 맞게 하도록
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // for left side
                                          children: [
                                            Align(
                                              alignment:
                                                  const Alignment(-1.0, -1.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start, // for left side

                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets
                                                            .fromLTRB(
                                                        10.0, 10.0, 0.0, 0),
                                                    child: Text(
                                                      snapshot.data!.docs[index]
                                                          ['productName'],
                                                      // formatter.format(product.price),
                                                      // style: theme.textTheme.subtitle2,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                            .fromLTRB(
                                                        10.0, 0.0, 0.0, 0),
                                                    child: Text(
                                                      "\$ " +
                                                          snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ['price']
                                                              .toString(),
                                                      // formatter.format(product.price),
                                                      // style: theme.textTheme.subtitle2,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          30.0, 20.0, 2.0, 0),

                                                      width: 130.0,
                                                      height: 33,
                                                      // color : Colors.black,
                                                      alignment:
                                                          Alignment.topRight,
                                                      //여기!
                                                      child: const SizedBox(
                                                        child: Text("More"),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) =>
                                                      //         DetailScreen(
                                                      //             todo: snapshot
                                                      //                 .data!
                                                      //                 .docs[
                                                      //             index]),
                                                      //   ),
                                                      // );
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }));
                          },
                        ),
                      );
                    }),
              ],
            ),
          );
        }
      },
    ));
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          FlatButton(
              color: Colors.grey,
              child: const Text("Google Login"),
              onPressed: () async {
                await signInWithGoogle();

                await FirebaseFirestore.instance
                    .collection('user')
                    .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                    .set({
                  'email': FirebaseAuth.instance.currentUser!.email,
                  'name': FirebaseAuth.instance.currentUser!.displayName,
                  'status_message':
                      "I promise to take the test honestly before GOD.",
                  'uid': FirebaseAuth.instance.currentUser!.uid.toString(),
                });
              }),
          FlatButton(
              color: Colors.grey,
              child: const Text("anonymous Login"),
              onPressed: () async {
                await FirebaseAuth.instance.signInAnonymously();
                await FirebaseFirestore.instance
                    .collection('user')
                    .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                    .set({
                  'status_message':
                      "I promise to take the test honestly before GOD.",
                  'uid': FirebaseAuth.instance.currentUser!.uid.toString(),
                });
              })
        ]),
      ),
    );
  }
}

class ImageFromGalleryEx extends StatefulWidget {
  final type;

  ImageFromGalleryEx(this.type);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(this.type);
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var _processimage0;
  var _processimage1;
  var _processimage2;
  var _processimage3;
  var _processimage4;
  var _processimage5;


  var _default;
  var imagePicker;
  var type;

  var processimageWidth = 250.0;
  var processimageHeight = 140.0;
  var processDescriptionHeight = 20.0;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _profileImageURL = "";

  String productname = 'Default Name';
  String detailVideo = ' ';
  String etcDescription = ' ';

  List<String> processDes = List.generate(6, (index) => " ");
  List<String> processUrl = List.generate(6, (index) => " ");
  List<bool> _forimage = [false, true, true, true, true, true];
  List<bool> _foringredient = List.generate(10,(index)=> false);
  List<String> _ingredient = ["삼겹살", "계란", "우유", "스팸", "소고기", "떡", "파", "마늘", "라면","기타"];
  String etcingredient = " ";

  int price = 0;
  String description = 'Default Description';

  ImageFromGalleryExState(this.type);

//   void urlToFile() async {
// // generate random number.
//
//     var rng = new Random();
// // get temporary directory of device.
//     Directory tempDir = await getTemporaryDirectory();
// // get temporary path from temporary directory.
//     String tempPath = tempDir.path;
// // create a new file in temporary path with random file name.
//     File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
//
//     String imageUrl = 'http://handong.edu/site/handong/res/img/logo.png';
// // call http.get method and pass imageUrl into it to get response.
//     http.Response response = await http.get(Uri.parse(imageUrl));
// // write bodyBytes received in response to file.
//     await file.writeAsBytes(response.bodyBytes);
// // now return the file which is created with random name in
// // temporary directory and image bytes from response is written to // that file.
//     setState(() {
//       _default = file;
//       // _image = file;
//       _uploadImageToStorage(_default);
//       // addProduct(productname, price, description, _default.toString());
//       // print(_default);
//     });
//   }

  @override
  void initState() {
    super.initState();
    _prepareService();
    imagePicker = new ImagePicker();
  }

  void _prepareService() async {
    _user = await _firebaseAuth.currentUser!;
  }


  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: 13, color: Colors.black),
          ),
        ),
        backgroundColor: Colors.grey,
        title: Text("Add"),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Save",
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
            onPressed: () {
              //
              _uploadImageToStorage(_image, _processimage0,_processimage1, _processimage2, _processimage3, _processimage4, _processimage5);
              // if (_image == null) {
              //   urlToFile();
              // } else {
              //   _uploadImageToStorage(_image);
              //   // print("Profile"+_profileImageURL);
              //   // addProduct(productname, price, description, _image.toString());
              // }
              // print(_profileImageURL);

              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 2500,
          child: Column(
            children: [
              //대표이미지 및 이름
              Container(
                child:
                  Column(
                    children: [
                      _image != null
                          ? SizedBox(
                          width: 410,
                          height: 300,
                          child: Image.file(
                            _image,
                            fit: BoxFit.fitHeight,
                          ))
                          : Container(
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          width: 410,
                          height: 300,
                          child: Image.network(
                              'http://handong.edu/site/handong/res/img/logo.png')
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text("음식 이름 : "),
                            SizedBox(
                              width: 270,
                              child:
                              TextField(
                                onChanged: (value){
                                  productname = value;
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.camera_alt),
                              color: Colors.grey[800],
                              onPressed: () async {
                                var source = ImageSource.gallery;
                                XFile image = (await ImagePicker()
                                    .pickImage(source: source, imageQuality: 50)) as XFile;
                                setState(() {
                                  _image = File(image.path);
                                });
                                print(_image);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),

              //재료들
              Container(
                child: Column(
                  children: [
                    Text("재료 추가"),
                    Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _foringredient[0], //처음엔 false
                              onChanged: (value) { //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                setState(() {
                                  _foringredient[0] = value!; //true가 들어감.
                                });
                              },
                            ),
                            Text("삼겹살")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _foringredient[1], //처음엔 false
                              onChanged: (value) { //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                setState(() {
                                  _foringredient[1] = value!; //true가 들어감.
                                });
                              },
                            ),
                            Text("계란")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _foringredient[2], //처음엔 false
                              onChanged: (value) { //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                setState(() {
                                  _foringredient[2] = value!; //true가 들어감.
                                });
                              },
                            ),
                            Text("우유")
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _foringredient[3], //처음엔 false
                              onChanged: (value) { //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                setState(() {
                                  _foringredient[3] = value!; //true가 들어감.
                                });
                              },
                            ),
                            Text("스팸")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _foringredient[4], //처음엔 false
                              onChanged: (value) { //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                setState(() {
                                  _foringredient[4] = value!; //true가 들어감.
                                });
                              },
                            ),
                            Text("소고기")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _foringredient[5], //처음엔 false
                              onChanged: (value) { //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                setState(() {
                                  _foringredient[5] = value!; //true가 들어감.
                                });
                              },
                            ),
                            Text("떡")
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _foringredient[6], //처음엔 false
                              onChanged: (value) { //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                setState(() {
                                  _foringredient[6] = value!; //true가 들어감.
                                });
                              },
                            ),
                            Text("파")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _foringredient[7], //처음엔 false
                              onChanged: (value) { //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                setState(() {
                                  _foringredient[7] = value!; //true가 들어감.
                                });
                              },
                            ),
                            Text("마늘")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _foringredient[8], //처음엔 false
                              onChanged: (value) { //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                setState(() {
                                  _foringredient[8] = value!; //true가 들어감.
                                });
                              },
                            ),
                            Text("라면")
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _foringredient[9], //처음엔 false
                          onChanged: (value) { //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                            setState(() {
                              _foringredient[2] = value!; //true가 들어감.
                            });
                          },
                        ),
                        Text("기타 :  "),
                        SizedBox(
                          width: 200,
                          child:
                          TextField(
                            onChanged: (value){
                              etcDescription = value;
                            },
                          )
                        )

                      ],
                    )

                  ],
                ),
              ),

              //여기서 부터 과정 image와 url을 집어 넣었는데 일단 Offstage가 6번 반복이라 이것좀 gridview나 listview로 바꿔야 할 필요가 있음.
              Container(
                child: Column(
                  children: [
                    Text("과정 image 넣기 및, 설명 넣기 가능"),
                    Offstage(
                        offstage: _forimage[0],
                        child: SizedBox(
                            width: processimageWidth,
                            height: processimageWidth,
                            child:
                            Column(
                              children: [
                                _processimage0 != null
                                    ? SizedBox(
                                    width: processimageWidth,
                                    height: processimageHeight,
                                    child: Image.file(
                                      _processimage0,
                                      fit: BoxFit.fitHeight,
                                    ))
                                    : Container(
                                    decoration: BoxDecoration(color: Colors.grey[200]),
                                    width: processimageWidth,
                                    height: processimageHeight,
                                    child: Image.network(
                                        'http://handong.edu/site/handong/res/img/logo.png')
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  // padding: const EdgeInsets.all(10),
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    color: Colors.grey[800],
                                    onPressed: () async {
                                      var source = ImageSource.gallery;
                                      XFile image = (await ImagePicker()
                                          .pickImage(source: source, imageQuality: 50)) as XFile;
                                      setState(() {
                                        _processimage0 = File(image.path);
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: processimageWidth,
                                  height: processDescriptionHeight,
                                  child:TextField(
                                    onChanged: (value){
                                      processDes[0] = value;
                                    },
                                  )
                                )

                              ],
                            )

                        )
                    ),
                    Offstage(
                        offstage: _forimage[1],
                        child: SizedBox(
                            width: processimageWidth,
                            height: processimageWidth,
                            child:
                            Column(
                              children: [
                                _processimage1 != null
                                    ? SizedBox(
                                    width: processimageWidth,
                                    height: processimageHeight,
                                    child: Image.file(
                                      _processimage1,
                                      fit: BoxFit.fitHeight,
                                    ))
                                    : Container(
                                    decoration: BoxDecoration(color: Colors.grey[200]),
                                    width: processimageWidth,
                                    height: processimageHeight,
                                    child: Image.network(
                                        'http://handong.edu/site/handong/res/img/logo.png')
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  padding: const EdgeInsets.all(10),
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    color: Colors.grey[800],
                                    onPressed: () async {
                                      var source = ImageSource.gallery;
                                      XFile image = (await ImagePicker()
                                          .pickImage(source: source, imageQuality: 50)) as XFile;
                                      setState(() {
                                        _processimage1 = File(image.path);
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                    width: processimageWidth,
                                    height: processDescriptionHeight,
                                    child:TextField(
                                      onChanged: (value){
                                        processDes[1] = value;
                                      },
                                    )
                                )
                              ],
                            )

                        )
                    ),
                    Offstage(
                        offstage: _forimage[2],
                        child: SizedBox(
                            width: processimageWidth,
                            height: processimageWidth,
                            child:
                            Column(
                              children: [
                                _processimage2 != null
                                    ? SizedBox(
                                    width: processimageWidth,
                                    height: processimageHeight,
                                    child: Image.file(
                                      _processimage2,
                                      fit: BoxFit.fitHeight,
                                    ))
                                    : Container(
                                    decoration: BoxDecoration(color: Colors.grey[200]),
                                    width: processimageWidth,
                                    height: processimageHeight,
                                    child: Image.network(
                                        'http://handong.edu/site/handong/res/img/logo.png')
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  padding: const EdgeInsets.all(10),
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    color: Colors.grey[800],
                                    onPressed: () async {
                                      var source = ImageSource.gallery;
                                      XFile image = (await ImagePicker()
                                          .pickImage(source: source, imageQuality: 50)) as XFile;
                                      setState(() {
                                        _processimage2 = File(image.path);
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                    width: processimageWidth,
                                    height: processDescriptionHeight,
                                    child:TextField(
                                      onChanged: (value){
                                        processDes[2] = value;
                                      },
                                    )
                                )
                              ],
                            )

                        )
                    ),
                    Offstage(
                        offstage: _forimage[3],
                        child: SizedBox(
                            width: processimageWidth,
                            height: processimageWidth,
                            child:
                            Column(
                              children: [
                                _processimage3 != null
                                    ? SizedBox(
                                    width: processimageWidth,
                                    height: processimageHeight,
                                    child: Image.file(
                                      _processimage3,
                                      fit: BoxFit.fitHeight,
                                    ))
                                    : Container(
                                    decoration: BoxDecoration(color: Colors.grey[200]),
                                    width: processimageWidth,
                                    height: processimageHeight,
                                    child: Image.network(
                                        'http://handong.edu/site/handong/res/img/logo.png')
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  padding: const EdgeInsets.all(10),
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    color: Colors.grey[800],
                                    onPressed: () async {
                                      var source = ImageSource.gallery;
                                      XFile image = (await ImagePicker()
                                          .pickImage(source: source, imageQuality: 50)) as XFile;
                                      setState(() {
                                        _processimage3 = File(image.path);
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                    width: processimageWidth,
                                    height: processDescriptionHeight,
                                    child:TextField(
                                      onChanged: (value){
                                        processDes[3] = value;
                                      },
                                    )
                                )
                              ],
                            )

                        )
                    ),
                    Offstage(
                        offstage: _forimage[4],
                        child: SizedBox(
                            width: processimageWidth,
                            height: processimageWidth,
                            child:
                            Column(
                              children: [
                                _processimage4 != null
                                    ? SizedBox(
                                    width: processimageWidth,
                                    height: processimageHeight,
                                    child: Image.file(
                                      _processimage4,
                                      fit: BoxFit.fitHeight,
                                    ))
                                    : Container(
                                    decoration: BoxDecoration(color: Colors.grey[200]),
                                    width: processimageWidth,
                                    height: processimageHeight,
                                    child: Image.network(
                                        'http://handong.edu/site/handong/res/img/logo.png')
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  padding: const EdgeInsets.all(10),
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    color: Colors.grey[800],
                                    onPressed: () async {
                                      var source = ImageSource.gallery;
                                      XFile image = (await ImagePicker()
                                          .pickImage(source: source, imageQuality: 50)) as XFile;
                                      setState(() {
                                        _processimage4 = File(image.path);
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                    width: processimageWidth,
                                    height: processDescriptionHeight,
                                    child:TextField(onChanged: (value){
                                      processDes[4] = value;
                                    },)
                                )
                              ],
                            )

                        )
                    ),
                    Offstage(
                        offstage: _forimage[5],
                        child: SizedBox(
                            width: processimageWidth,
                            height: processimageWidth,
                            child:
                            Column(
                              children: [
                                _processimage5 != null
                                    ? SizedBox(
                                    width: processimageWidth,
                                    height: processimageHeight,
                                    child: Image.file(
                                      _processimage5,
                                      fit: BoxFit.fitHeight,
                                    ))
                                    : Container(
                                    decoration: BoxDecoration(color: Colors.grey[200]),
                                    width: processimageWidth,
                                    height: processimageHeight,
                                    child: Image.network(
                                        'http://handong.edu/site/handong/res/img/logo.png')
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  padding: const EdgeInsets.all(10),
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    color: Colors.grey[800],
                                    onPressed: () async {
                                      var source = ImageSource.gallery;
                                      XFile image = (await ImagePicker()
                                          .pickImage(source: source, imageQuality: 50)) as XFile;
                                      setState(() {
                                        _processimage5 = File(image.path);
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                    width: processimageWidth,
                                    height: processDescriptionHeight,
                                    child:TextField(
                                      onChanged: (value){
                                        processDes[5] = value;
                                      },
                                    )
                                )
                              ],
                            )

                        )
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.expand_more_outlined),
                          onPressed: () {
                            if(count >0){
                              count--;
                              setState(() {
                                _forimage[count] = !_forimage[count];
                              });
                              print(_forimage);
                            }else{
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text('You should input more than 1 process'),
                                ),
                              );
                            }

                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.expand_less_outlined),
                          onPressed: () {
                            if(count < 5){
                              count++;
                              setState(() {
                                _forimage[count] = !_forimage[count];
                              });
                              print(_forimage);
                            }else{
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text('You can input just 6 process'),
                                ),
                              );
                            }

                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),

              //대표 요리 영상
              Container(
                child:
                Column(
                  children: [
                    Text("영상 url"),
                    SizedBox(
                      width: 270,
                      child:
                      TextField(
                        onChanged: (value){
                          detailVideo = value;
                        },
                      )
                    )

                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  void _uploadImageToStorage(File _image, File _p0, File _p1,File _p2,File _p3,File _p4,File _p5) async {
    // 프로필 사진을 업로드할 경로와 파일명을 정의. 사용자의 uid를 이용하여 파일명의 중복 가능성 제거


    // 파일 업로드
    if(_image != null){
      Reference storageReference1 = _firebaseStorage.ref().child(
          "${_user!.uid}/" + DateTime.now().toString() + "/" + productname);
      UploadTask storageUploadTask = storageReference1.putFile(_image);
      var downloadURL = (await (await storageUploadTask).ref.getDownloadURL());
      // print(downloadURL.toString());
      _profileImageURL = downloadURL.toString();
    }else{
      _profileImageURL= "http://handong.edu/site/handong/res/img/logo.png";
    }

    if(_p0 != null){
      Reference storageReference2 = _firebaseStorage.ref().child(
          "${_user!.uid}/" + DateTime.now().toString() + "/" + productname+"0");
      UploadTask storageUploadTask = storageReference2.putFile(_p0);
      var downloadURL = (await (await storageUploadTask).ref.getDownloadURL());
      // print(downloadURL.toString());
      processUrl[0] = downloadURL.toString();
    }else{
      processUrl[0]= "http://handong.edu/site/handong/res/img/logo.png";
    }

    if(_p1 != null){
      Reference storageReference3 = _firebaseStorage.ref().child(
          "${_user!.uid}/" + DateTime.now().toString() + "/" + productname +"1");
      UploadTask storageUploadTask = storageReference3.putFile(_p1);
      var downloadURL = (await (await storageUploadTask).ref.getDownloadURL());
      // print(downloadURL.toString());
      processUrl[1] = downloadURL.toString();
    }else{
      processUrl[1]= "http://handong.edu/site/handong/res/img/logo.png";
    }

    if(_p2 != null){
      Reference storageReference4 = _firebaseStorage.ref().child(
          "${_user!.uid}/" + DateTime.now().toString() + "/" + productname +"2");
      UploadTask storageUploadTask = storageReference4.putFile(_p2);
      var downloadURL = (await (await storageUploadTask).ref.getDownloadURL());
      // print(downloadURL.toString());
      processUrl[2] = downloadURL.toString();
    }else{
      processUrl[2]= "http://handong.edu/site/handong/res/img/logo.png";
    }

    if(_p3 != null){
      Reference storageReference5 = _firebaseStorage.ref().child(
          "${_user!.uid}/" + DateTime.now().toString() + "/" + productname +"3");
      UploadTask storageUploadTask = storageReference5.putFile(_p3);
      var downloadURL = (await (await storageUploadTask).ref.getDownloadURL());
      // print(downloadURL.toString());
      processUrl[3] = downloadURL.toString();
    }else{
      processUrl[3]= "http://handong.edu/site/handong/res/img/logo.png";
    }

    if(_p4 != null){
      Reference storageReference6 = _firebaseStorage.ref().child(
          "${_user!.uid}/" + DateTime.now().toString() + "/" + productname +"4");
      UploadTask storageUploadTask = storageReference6.putFile(_p4);
      var downloadURL = (await (await storageUploadTask).ref.getDownloadURL());
      // print(downloadURL.toString());
      processUrl[4] = downloadURL.toString();
    }else{
      processUrl[4]= "http://handong.edu/site/handong/res/img/logo.png";
    }

    if(_p5 != null){
      Reference storageReference7 = _firebaseStorage.ref().child(
          "${_user!.uid}/" + DateTime.now().toString() + "/" + productname +"5");
      UploadTask storageUploadTask = storageReference7.putFile(_p5);
      var downloadURL = (await (await storageUploadTask).ref.getDownloadURL());
      // print(downloadURL.toString());
      processUrl[5] = downloadURL.toString();
    }else{
      processUrl[5]= "http://handong.edu/site/handong/res/img/logo.png";
    }

    List<String> tempingredient = [];

    for(int i=0; i < _ingredient.length; i++){
      if(_foringredient[i] == true){
        tempingredient.add(_ingredient[i]);
      }
    }
    // 파일 업로드 완료까지 대기

    // 업로드한 사진의 URL 획득

    // print(_profileImageURL);
    // 업로드된 사진의 URL을 페이지에 반영
    var docName = productname + DateTime.now().toString();
    FirebaseFirestore.instance
        .collection('forUana')
        .doc(docName.toString())
        .set({
      'foodName': productname,
      'path': _profileImageURL,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'timedate': DateTime.now().toString(),
      'name': FirebaseAuth.instance.currentUser!.displayName,
      // 'userId' : DocumentRe
      'ingredient' : tempingredient,
      'processUrl' : { "1" : processUrl[0], "2" : processUrl[1], "3" : processUrl[2], "4" : processUrl[3], "5" : processUrl[4], "6" : processUrl[5]},
      'processDescription' : { "1" : processDes[0], "2" : processDes[1], "3" : processDes[2], "4" : processDes[3], "5" : processDes[4], "6" : processDes[5]},
      'userId': FirebaseAuth.instance.currentUser!.uid.toString(),
      'docId': docName.toString(),
      'etcMaterial': etcDescription,
    });
    // setState(() {
    //   _profileImageURL = downloadURL.toString();
    //   print(_profileImageURL);
    // });
  }
}
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//       appBar: AppBar(
//         title: Text("Kindacode.com"),
//         leading: IconButton(
//           icon: Icon(Icons.add),
//           onPressed: () {
//             count++;
//             setState(() {
//               _forimage[count] = !_forimage[count];
//             });
//             print(_forimage);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Offstage(
//               offstage: _forimage[0],
//               child: const TextField(
//                 // decoration:
//               ),
//             ),
//             Offstage(
//               offstage: _forimage[1],
//               child: const TextField(
//                 // decoration:
//               ),
//             ),
//             Offstage(
//               offstage: _forimage[2],
//               child: const TextField(
//                 // decoration:
//               ),
//             ),
//             Offstage(
//               offstage: _forimage[3],
//               child: const TextField(
//                 // decoration:
//               ),
//             ),
//             GestureDetector(
//               onTap: () async {
//                 var source = ImageSource.gallery;
//                 File image = (await ImagePicker().pickImage(
//                     source: source, imageQuality: 50)) as File;
//                 setState(() {
//                   _image = File(image.path);
//                 });
//               },
//               child: Column(
//                 children: [
//                   _image != null
//                       ? SizedBox(
//                       width: 410,
//                       height: 300,
//                       child: Image.file(
//                         _image,
//                         fit: BoxFit.fitHeight,
//                       ))
//                       : Container(
//                       decoration: BoxDecoration(color: Colors.grey[200]),
//                       width: 410,
//                       height: 300,
//                       child: Image.network(
//                           'http://handong.edu/site/handong/res/img/logo.png')
//
//                     // Icon(
//                     //       Icons.image,
//                     //       color: Colors.grey[800],
//                     //       size: 150,
//                     // ),
//
//                   ),
//                   Container(
//                     alignment: Alignment.bottomRight,
//                     padding: const EdgeInsets.all(10),
//                     child: Icon(
//                       Icons.camera_alt,
//                       color: Colors.grey[800],
//                       size: 30,
//                     ),
//                   ),
//                   SizedBox(
//                       width: 300,
//                       height: 180,
//                       child: Column(
//                         children: [
//
//                         ],
//                       )),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       )
//   );
// }
