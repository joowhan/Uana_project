import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// import 'package:shrine/login.dart';
import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const App(),
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
    List<List<dynamic>> _data = [];

    void openFile(PlatformFile file ) async{
      OpenFile.open(file.path!);
      final input = new File(file.path!).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();
      final confirmlist = List.generate(0, (index) => 0); // 레시피 코드를 저장한다.
      for(int i =0; i < 2; i++){
        print(confirmlist);
        if(fields[i][0] is! String){ //각 csv 파일 맨 위는 사용하지 않는다.
          if(!confirmlist.contains(fields[i][0])){ //만약 원래 추가가 되지 않았던 레시피 코드라면 confirmlist에 추가하고, set을 사용해서 firebase에도 올린다.
            confirmlist.add(fields[i][0]);
            print("confirmlist");
            print(confirmlist);
            //원래 추가가 된 것이 아니기 때문에 set을 이용해서 올린다.
            await FirebaseFirestore.instance
                .collection('recipes')
                .doc(fields[i][0].toString() + "안녕")
                .set({
              /*
        레시피 코드, 레시피 이름 ,재료 명, 재료 용량, 재료 타입 명(양념, 주재료 등), 유형 분류(한식, 퓨전 등),
        음식분류(부침, 나물, 밥 등),조리 시간, 분량(인분), 난이도, 가격, 대표이미지 URL, 상세 URL, 요리 설명순서, 요리 설명, 과정 이미지 url, tip
         */
              'recipeCode' : fields[i][0] as int, //레시피 코드이자 doc 이름
              'recipeName': "", //레시피 이름
              'ingredient' : {fields[i][2] :  fields[i][3]}, //재료 명과 용량




            });

            }
          else{ // 만약 confirmlist에 있다면 set이 된 것이니 update를 이용한다.
            await FirebaseFirestore.instance
                .collection("recipes")
                .doc(fields[i][0].toString())
                .update({
                  // 'ingredient' : FieldValue.arrayUnion([fields[i][2] ,  fields[i][3]]),
                  'ingredient.${fields[i][2]}': fields[i][3],
                  // 'userInfo.userCount': 2
            });
            }

          print(fields[i]);
        }
      }

      print(confirmlist);
      print(fields);
      print(fields.length);

    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Kindacode.com"),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, index) {
          return Card(
              margin: const EdgeInsets.all(3),
              color: index == 0 ? Colors.amber : Colors.white,
              child: Text("")
            // ListTile(
            //   leading: Text(_data[index][0].toString()),
            //   title: Text(_data[index][1]),
            //   trailing: Text(_data[index][2].toString()),
            // ),
          );
        },
      ),
      floatingActionButton:
      FloatingActionButton(child: Icon(Icons.add), onPressed: () async{
        final result = await FilePicker.platform.pickFiles();
        if (result == null )return;
        final file = result.files.first;
        openFile(file);
        print('Name: ${file.name} ');
        print('Bytes: ${file.bytes} ');
        print('Size: ${file.size} ');
        print('Extension: ${file.extension} ');
        print('Path : ${file.path} ');

        // final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
      }),
    );
  }
}
void signOutGoogle() async{
  await googleSignIn.signOut();

  print("User Sign Out");
}

final GoogleSignIn googleSignIn = GoogleSignIn();
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
class LoginWidget extends StatelessWidget {
  LoginWidget({Key? key}) : super(key: key);


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

//이미지 피커
enum ImageSourceType { gallery, camera }


void _delete(DocumentSnapshot doc) {
  FirebaseFirestore.instance.collection('product').doc(doc.id).delete();
}