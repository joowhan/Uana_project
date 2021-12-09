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
import 'package:provider/provider.dart';
import 'package:uana_project/provider/recipe_provider.dart';
import 'package:uana_project/theme/light_colors.dart';

class RecipeCreate extends StatefulWidget {
  final type;

  RecipeCreate(this.type);

  @override
  RecipeCreateExState createState() => RecipeCreateExState(this.type);
}

class RecipeCreateExState extends State<RecipeCreate> {
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

  // List<Widget> kategorywidet = List<Widget>();
  var processimageWidth = 250.0;
  var processimageHeight = 140.0;
  var processDescriptionHeight = 20.0;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _profileImageURL = "";

  String productname = 'Default Name';
  String detailVideo = 'NUienUvTEvg';
  String etcDescription = ' ';

  List<String> processDes = List.generate(6, (index) => " ");
  List<String> processUrl = List.generate(6, (index) => " ");
  List<bool> _forimage = [false, true, true, true, true, true];

  List<String> _ingredient = [
    "가래떡", "간장", "감자", "게맛살", "계란", "고등어", "고추기름", "고추장", "고춧가루", "골뱅이",
    "국수", "치즈", "김", "김치", "깨소금", "깻잎", "꽈리고추", "녹말", "다시마", "단무지",
    "닭", "당근", "대파", "돼지고기", "된장", "두반장", "두부", "떡", "라면", "마늘",
    "만두피", "맛소금", "맛술", "매실장아찌", "멸치", "멸칫국물", "무", "물", "물엿", "밀가루",
    "바질", "밥", "버터", "베이컨", "부추", "새우", "샐러리", "생강", "생크림", "설탕",
    "소금", "소면", "쇠고기", "숙주", "스파게티", "식용유", "식초", "실고추", "실파", "쑥갓",
    "애호박", "양송이버섯", "양파", "어묵", "오이", "오징어", "완두콩", "우유", "육수", "죽순",
    "참기름", "참치", "청고추", "청주", "청피망", "카레", "콩나물", "토마토케첩", "통후추", "파",
    "파슬리", "팽이버섯", "표고버섯", "프랑크소시지", "햄", "호두","호박", "홍고추", "홍합", "화이트와인",
    "후추", "기타"
  ];
  List<bool> _foringredient = [];
  bool _offingre = true;
  // List<bool> _forkategorie = List.generate(6, (index) => false);
  List<bool> _forkategorie = [];
  List<String> _kategorie = ["국물", "튀김", "매운 음식", "야식", "아침", "식사"];

  String etcingredient = " ";

  int price = 0;
  String description = 'Default Description';

  RecipeCreateExState(this.type);

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

  Widget makeCheckbox(int i, String valuename, List<bool> forthis) {
    return Row(
      children: [
        Checkbox(
          value: forthis[i], //처음엔 false
          onChanged: (value) {
            //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
            setState(() {
              forthis[i] = value!; //true가 들어감.
            });
          },
        ),
        Text(valuename)
      ],
    );
  }

  final _formKey = GlobalKey<FormState>();

  int count = 0;

  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of(context, listen : true); // provider 사용
    for (int i = 0; i < _ingredient.length; i++) {
      _foringredient.add(false);
    }
    for (int i = 0; i < _kategorie.length-1; i++) {
      _forkategorie.add(false);
      if(i == _kategorie.length-2){
        _forkategorie.add(true);
      }
    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
        backgroundColor: LightColors.eachRecipe,
        title: Text("레시피 추가하기",
        style: TextStyle(
          color: Colors.black
        ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Save",
              style: TextStyle(fontSize: 13, color: Colors.black),
            ),
            onPressed: () {
              //
              if(_formKey.currentState!.validate()){
                _uploadImageToStorage(
                    _image,
                    _processimage0,
                    _processimage1,
                    _processimage2,
                    _processimage3,
                    _processimage4,
                    _processimage5);
                Future.delayed(const Duration(milliseconds: 1000), () {
                  recipeProvider.loadRecipes();
                  Navigator.pop(context);
                });

              }


            },
          ),
        ],
      ),
      body:  LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints){
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                // height: 3500,
                child: Column(
                  children: [
                    //대표이미지 및 이름
                    Container(
                        child: Column(
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
                                    'http://handong.edu/site/handong/res/img/logo.png')),
                            Container(
                              alignment: Alignment.bottomRight,
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text("음식 이름 : "),
                                  SizedBox(
                                    width: 270,
                                    child: TextFormField(
                                      onChanged: (value) {
                                        productname = value;
                                      },
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return '이름을 입력해주세요';
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    color: Colors.grey[800],
                                    onPressed: () async {
                                      var source = ImageSource.gallery;
                                      XFile image = (await ImagePicker().pickImage(
                                          source: source, imageQuality: 30)) as XFile;
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
                        )),
                    //카테고리 만들기
                    Container(
                      child: Column(
                          children: _kategorie.map((item) {
                            var index = _kategorie.indexOf(item);
                            if (index % 3 == 0) {
                              return Row(children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _forkategorie[index], //처음엔 false
                                      onChanged: (value) {
                                        //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                        setState(() {
                                          _forkategorie[index] = value!; //true가 들어감.
                                        });
                                      },
                                    ),
                                    Text(_kategorie[index])
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _forkategorie[index + 1], //처음엔 false
                                      onChanged: (value) {
                                        //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                        setState(() {
                                          _forkategorie[index + 1] =
                                          value!; //true가 들어감.
                                        });
                                      },
                                    ),
                                    Text(_kategorie[index + 1])
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _forkategorie[index + 2], //처음엔 false
                                      onChanged: (value) {
                                        //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                        setState(() {
                                          _forkategorie[index + 2] =
                                          value!; //true가 들어감.
                                        });
                                      },
                                    ),
                                    Text(_kategorie[index + 2])
                                  ],
                                ),
                              ]);
                            } else {
                              return SizedBox(height: 0);
                            }
                          }).toList()),
                    ),

                    //재료들
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          setState(() {
                            _offingre = !_offingre;
                          });

                        }, icon: _offingre ? Icon(Icons.expand_more_outlined) : Icon(Icons.expand_less_outlined)),
                        Text("재료 추가")
                      ],
                    ),
                    Container(
                        child: Column(
                          children: [
                            Offstage(
                              offstage: _offingre,
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                crossAxisCount: 3,
                                padding: const EdgeInsets.all(5.0),
                                childAspectRatio: 5.0 / 2.0,
                                children: _ingredient.map((ingre){
                                  var index = _ingredient.indexOf(ingre);
                                  return Row(children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _foringredient[index],
                                          //처음엔 false
                                          onChanged: (value) {
                                            //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                            setState(() {
                                              _foringredient[index] = value!; //true가 들어감.
                                            });
                                          },
                                        ),
                                        Text(_ingredient[index])
                                      ],
                                    ),
                                  ]);
                                }

                                ).toList(),

                              ),
                            ),

                            !_offingre ?
                            SizedBox(
                              width: 300,
                              height: 50,
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: "기타 재료"),
                                onChanged: (value) {
                                  etcDescription = value;
                                },
                                validator: (val){
                                  if(_foringredient[_ingredient.length-1] == true && val!.isEmpty){
                                    return '기타에 체크 시 추가 재료를 입력해주세요';
                                  }
                                },
                              ),
                            ) : SizedBox(height: 0,)
                          ],
                        )
                    ),
                    !_offingre ?
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          setState(() {
                            _offingre = !_offingre;
                          });

                        }, icon: Icon(Icons.expand_less_outlined)),
                        Text("재료 목록 올리기")
                      ],
                    ) : SizedBox(height: 0),

                    //여기서 부터 과정 image와 url을 집어 넣었는데 일단 Offstage가 6번 반복이라 이것좀 gridview나 listview로 바꿔야 할 필요가 있음.
                    Container(
                      child: Column(
                        children: [
                          Text("과정 이미지 추가와 설명 적어주세요"),
                          Offstage(
                              offstage: _forimage[0],
                              child: SizedBox(
                                  width: processimageWidth,
                                  height: processimageWidth,
                                  child: Column(
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
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200]),
                                          width: processimageWidth,
                                          height: processimageHeight,
                                          child: Image.network(
                                              'http://handong.edu/site/handong/res/img/logo.png')),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        // padding: const EdgeInsets.all(10),
                                        child: IconButton(
                                          icon: Icon(Icons.camera_alt),
                                          color: Colors.grey[800],
                                          onPressed: () async {
                                            var source = ImageSource.gallery;
                                            XFile image = (await ImagePicker()
                                                .pickImage(
                                                source: source,
                                                imageQuality: 30)) as XFile;
                                            setState(() {
                                              _processimage0 = File(image.path);
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                          width: processimageWidth,
                                          height: processDescriptionHeight,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              processDes[0] = value;
                                            },
                                            validator: (val){
                                              if(val!.isEmpty){
                                                return '적어도 하나의 과정은 추가 해야합니다.';
                                              }
                                            },
                                          ))
                                    ],
                                  ))),
                          Offstage(
                              offstage: _forimage[1],
                              child: SizedBox(
                                  width: processimageWidth,
                                  height: processimageWidth,
                                  child: Column(
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
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200]),
                                          width: processimageWidth,
                                          height: processimageHeight,
                                          child: Image.network(
                                              'http://handong.edu/site/handong/res/img/logo.png')),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        padding: const EdgeInsets.all(10),
                                        child: IconButton(
                                          icon: Icon(Icons.camera_alt),
                                          color: Colors.grey[800],
                                          onPressed: () async {
                                            var source = ImageSource.gallery;
                                            XFile image = (await ImagePicker()
                                                .pickImage(
                                                source: source,
                                                imageQuality: 30)) as XFile;
                                            setState(() {
                                              _processimage1 = File(image.path);
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                          width: processimageWidth,
                                          height: processDescriptionHeight,
                                          child: TextField(
                                            onChanged: (value) {
                                              processDes[1] = value;
                                            },
                                          ))
                                    ],
                                  ))),
                          Offstage(
                              offstage: _forimage[2],
                              child: SizedBox(
                                  width: processimageWidth,
                                  height: processimageWidth,
                                  child: Column(
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
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200]),
                                          width: processimageWidth,
                                          height: processimageHeight,
                                          child: Image.network(
                                              'http://handong.edu/site/handong/res/img/logo.png')),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        padding: const EdgeInsets.all(10),
                                        child: IconButton(
                                          icon: Icon(Icons.camera_alt),
                                          color: Colors.grey[800],
                                          onPressed: () async {
                                            var source = ImageSource.gallery;
                                            XFile image = (await ImagePicker()
                                                .pickImage(
                                                source: source,
                                                imageQuality: 30)) as XFile;
                                            setState(() {
                                              _processimage2 = File(image.path);
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                          width: processimageWidth,
                                          height: processDescriptionHeight,
                                          child: TextField(
                                            onChanged: (value) {
                                              processDes[2] = value;
                                            },
                                          ))
                                    ],
                                  ))),
                          Offstage(
                              offstage: _forimage[3],
                              child: SizedBox(
                                  width: processimageWidth,
                                  height: processimageWidth,
                                  child: Column(
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
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200]),
                                          width: processimageWidth,
                                          height: processimageHeight,
                                          child: Image.network(
                                              'http://handong.edu/site/handong/res/img/logo.png')),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        padding: const EdgeInsets.all(10),
                                        child: IconButton(
                                          icon: Icon(Icons.camera_alt),
                                          color: Colors.grey[800],
                                          onPressed: () async {
                                            var source = ImageSource.gallery;
                                            XFile image = (await ImagePicker()
                                                .pickImage(
                                                source: source,
                                                imageQuality: 30)) as XFile;
                                            setState(() {
                                              _processimage3 = File(image.path);
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                          width: processimageWidth,
                                          height: processDescriptionHeight,
                                          child: TextField(
                                            onChanged: (value) {
                                              processDes[3] = value;
                                            },
                                          ))
                                    ],
                                  ))),
                          Offstage(
                              offstage: _forimage[4],
                              child: SizedBox(
                                  width: processimageWidth,
                                  height: processimageWidth,
                                  child: Column(
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
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200]),
                                          width: processimageWidth,
                                          height: processimageHeight,
                                          child: Image.network(
                                              'http://handong.edu/site/handong/res/img/logo.png')),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        padding: const EdgeInsets.all(10),
                                        child: IconButton(
                                          icon: Icon(Icons.camera_alt),
                                          color: Colors.grey[800],
                                          onPressed: () async {
                                            var source = ImageSource.gallery;
                                            XFile image = (await ImagePicker()
                                                .pickImage(
                                                source: source,
                                                imageQuality: 30)) as XFile;
                                            setState(() {
                                              _processimage4 = File(image.path);
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                          width: processimageWidth,
                                          height: processDescriptionHeight,
                                          child: TextField(
                                            onChanged: (value) {
                                              processDes[4] = value;
                                            },
                                          ))
                                    ],
                                  ))),
                          Offstage(
                              offstage: _forimage[5],
                              child: SizedBox(
                                  width: processimageWidth,
                                  height: processimageWidth,
                                  child: Column(
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
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200]),
                                          width: processimageWidth,
                                          height: processimageHeight,
                                          child: Image.network(
                                              'http://handong.edu/site/handong/res/img/logo.png')),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        padding: const EdgeInsets.all(10),
                                        child: IconButton(
                                          icon: Icon(Icons.camera_alt),
                                          color: Colors.grey[800],
                                          onPressed: () async {
                                            var source = ImageSource.gallery;
                                            XFile image = (await ImagePicker()
                                                .pickImage(
                                                source: source,
                                                imageQuality: 30)) as XFile;
                                            setState(() {
                                              _processimage5 = File(image.path);
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                          width: processimageWidth,
                                          height: processDescriptionHeight,
                                          child: TextField(
                                            onChanged: (value) {
                                              processDes[5] = value;
                                            },
                                          ))
                                    ],
                                  ))),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    if (count > 0) {

                                      setState(() {
                                        _forimage[count] = !_forimage[count];
                                      });
                                      count--;
                                      print(_forimage);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'You should input more than 1 process'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 280,
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    if (count < 5) {
                                      count++;
                                      setState(() {
                                        _forimage[count] = !_forimage[count];
                                      });
                                      print(_forimage);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content:
                                          Text('You can input just 6 process'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    //대표 요리 영상
                    Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("영상 url id  "),
                                SizedBox(
                                  width: 320,
                                  child: TextFormField(
                                    decoration: const InputDecoration(prefixText: "www.youtube.com/watch?v="),
                                    onChanged: (value) {
                                      detailVideo = value;
                                    },
                                    validator: (val) {
                                      String value = val.toString();
                                      if (value.length > 11) {
                                        return 'Youtube Video ID만 입력해주세요.';
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),


                            SizedBox(
                              height: 20.0,
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _uploadImageToStorage(File _image, File _p0, File _p1, File _p2,
      File _p3, File _p4, File _p5) async {
    // 프로필 사진을 업로드할 경로와 파일명을 정의. 사용자의 uid를 이용하여 파일명의 중복 가능성 제거

    // 파일 업로드
    if (_image != null) {
      Reference storageReference1 = _firebaseStorage.ref().child(
          "${_user!.uid}/" + DateTime.now().toString() + "/" + productname);
      UploadTask storageUploadTask = storageReference1.putFile(_image);
      var downloadURL = (await (await storageUploadTask).ref.getDownloadURL());
      // print(downloadURL.toString());
      _profileImageURL = downloadURL.toString();
    } else {
      _profileImageURL = "http://handong.edu/site/handong/res/img/logo.png";
    }

    if (_p0 != null) {
      Reference storageReference2 = _firebaseStorage.ref().child(
          "${_user!.uid}/" +
              DateTime.now().toString() +
              "/" +
              productname +
              "0");
      UploadTask storageUploadTask = storageReference2.putFile(_p0);
      var downloadURL = (await (await storageUploadTask).ref.getDownloadURL());
      // print(downloadURL.toString());
      processUrl[0] = downloadURL.toString();
    } else {
      processUrl[0] = "http://handong.edu/site/handong/res/img/logo.png";
    }

    if (_p1 != null) {
      Reference storageReference3 = _firebaseStorage.ref().child(
          "${_user!.uid}/" +
              DateTime.now().toString() +
              "/" +
              productname +
              "1");
      UploadTask storageUploadTask = storageReference3.putFile(_p1);
      var downloadURL = (await (await storageUploadTask).ref.getDownloadURL());
      // print(downloadURL.toString());
      processUrl[1] = downloadURL.toString();
    } else {
      processUrl[1] = "http://handong.edu/site/handong/res/img/logo.png";
    }

    if (_p2 != null) {
      Reference storageReference4 = _firebaseStorage.ref().child(
          "${_user!.uid}/" +
              DateTime.now().toString() +
              "/" +
              productname +
              "2");
      UploadTask storageUploadTask = storageReference4.putFile(_p2);
      var downloadURL = (await (await storageUploadTask).ref.getDownloadURL());
      // print(downloadURL.toString());
      processUrl[2] = downloadURL.toString();
    } else {
      processUrl[2] = "http://handong.edu/site/handong/res/img/logo.png";
    }

    if (_p3 != null) {
      Reference storageReference5 = _firebaseStorage.ref().child(
          "${_user!.uid}/" +
              DateTime.now().toString() +
              "/" +
              productname +
              "3");
      UploadTask storageUploadTask = storageReference5.putFile(_p3);
      var downloadURL = (await (await storageUploadTask).ref.getDownloadURL());
      // print(downloadURL.toString());
      processUrl[3] = downloadURL.toString();
    } else {
      processUrl[3] = "http://handong.edu/site/handong/res/img/logo.png";
    }

    if (_p4 != null) {
      Reference storageReference6 = _firebaseStorage.ref().child(
          "${_user!.uid}/" +
              DateTime.now().toString() +
              "/" +
              productname +
              "4");
      UploadTask storageUploadTask = storageReference6.putFile(_p4);
      var downloadURL = (await (await storageUploadTask).ref.getDownloadURL());
      // print(downloadURL.toString());
      processUrl[4] = downloadURL.toString();
    } else {
      processUrl[4] = "http://handong.edu/site/handong/res/img/logo.png";
    }

    if (_p5 != null) {
      Reference storageReference7 = _firebaseStorage.ref().child(
          "${_user!.uid}/" +
              DateTime.now().toString() +
              "/" +
              productname +
              "5");
      UploadTask storageUploadTask = storageReference7.putFile(_p5);
      var downloadURL = (await (await storageUploadTask).ref.getDownloadURL());
      // print(downloadURL.toString());
      processUrl[5] = downloadURL.toString();
    } else {
      processUrl[5] = "http://handong.edu/site/handong/res/img/logo.png";
    }

    List<String> tempingredient = [];

    for (int i = 0; i < _ingredient.length; i++) {
      if (_foringredient[i] == true) {
        tempingredient.add(_ingredient[i]);
      }
    }

    List<String> tempkategorie = [];

    for (int i = 0; i < _kategorie.length; i++) {
      if (_forkategorie[i] == true) {
        tempkategorie.add(_kategorie[i]);
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
      'ingredient': tempingredient,
      'kategorie': tempkategorie,
      'processUrl': {
        "1": processUrl[0],
        "2": processUrl[1],
        "3": processUrl[2],
        "4": processUrl[3],
        "5": processUrl[4],
        "6": processUrl[5]
      },
      'processDescription': {
        "1": processDes[0],
        "2": processDes[1],
        "3": processDes[2],
        "4": processDes[3],
        "5": processDes[4],
        "6": processDes[5]
      },
      'userId': FirebaseAuth.instance.currentUser!.uid.toString(),
      'docId': docName.toString(),
      'etcMaterial': etcDescription,
      'like': 0,
      'likeusers': [],
      'detailUrl': detailVideo
    });
    // setState(() {
    //   _profileImageURL = downloadURL.toString();
    //   print(_profileImageURL);
    // });
  }
}