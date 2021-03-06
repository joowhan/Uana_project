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
      final confirmlist = List.generate(0, (index) => 0);  // ????????? ????????? ????????????.
      for(int i =0; i < fields.length; i++){
        print(i);
        if(fields[i][0] is! String){ //??? csv ?????? ??? ?????? ???????????? ?????????.
        //   if(!confirmlist.contains(fields[i][0])){ //?????? ?????? ????????? ?????? ????????? ????????? ???????????? confirmlist??? ????????????, set??? ???????????? firebase?????? ?????????.
        //     confirmlist.add(fields[i][0]);
        //     print("confirmlist");
        //     print(confirmlist);
        //     //?????? ????????? ??? ?????? ????????? ????????? set??? ???????????? ?????????.
        //     await FirebaseFirestore.instance
        //         .collection('recipes')
        //         .doc(fields[i][0].toString())
        //         .set({
        //       /*
        // ????????? ??????!, ????????? ??????! ,?????? ???!, ?????? ??????!, ?????? ?????? ???(??????, ????????? ???)!, ?????? ??????(??????, ?????? ???)!, ?????? ??????!
        // ????????????(??????, ??????, ??? ???)!,?????? ??????!, ??????(??????)!, ?????????!, ??????????????? URL!, ?????? URL!, ?????? ????????????!, ?????? ??????!, ?????? ????????? url!
        //  */
        //       'recipeCode' : fields[i][0] as int, //????????? ???????????? doc ?????? // ??? ?????? ?????? !
        //       // 'recipeName': "", //????????? ?????? !
        //       // 'ingredient_main' : {"?????????" : "??????"}, //(???)?????? ?????? ?????? !
        //       // 'ingredient_sub' : {"" : ""}, //(???)?????? ?????? ?????? !
        //       // 'ingredient_sauce' : {"" : ""}, //(??????)?????? ?????? ?????? !
        //       // 'type_c' : "", // ?????? ??????(??????, ?????? ???) !
        //       // 'food_c' : "", // ?????? ??????(??????, ?????? ???) !
        //       // 'description' : "", //?????? ?????? !
        //       // 'cooking_time' : "", //?????? ?????? !
        //       // 'level' : "", //????????? !
        //       // 'image_url' : "", //??????????????? url !
        //       // 'detail_url' : "", //?????? url !
        //       // 'process_description' : {"" :  ""}, //?????? ?????? : ??????
        //       // 'process_url' : {"" :  ""}, //?????? ?????? : ??????
        //     });
        //
        //     }
        //   else{ // ?????? confirmlist??? ????????? set??? ??? ????????? update??? ????????????.

/*
          await FirebaseFirestore.instance
              .collection("recipes")
              .doc(fields[i][0].toString())
              .update({
                // 'ingredient' : FieldValue.arrayUnion([fields[i][2] ,  fields[i][3]]),
                'process_description.${fields[i][1]}': fields[i][2],
                'process_url.${fields[i][1]}': fields[i][3],

                // 'userInfo.userCount': 2
          });
 */

        await FirebaseFirestore.instance
            .collection("food")
            .doc(fields[i][0].toString())
            .set({
          'foodCode' : fields[i][0] as int,
          'foodName' : fields[i][1] as String,
        });
           //?????????  ?????? ?????? ?????? ???
            
            // await FirebaseFirestore.instance
            //     .collection("recipes")
            //     .doc(fields[i][0].toString())
            //     .update({
            //   // 'ingredient' : FieldValue.arrayUnion([fields[i][2] ,  fields[i][3]]),
            //   'recipeName' : fields[i][1],
            //   'type_c' : fields[i][4],
            //   'food_c' : fields[i][6],
            //   'description' : fields[i][2],
            //   'cooking_time' : fields[i][7],
            //   'level' : fields[i][10],
            //   'image_url' : fields[i][11],
            //   'detail_url' : fields[i][12],
            //
            //
            //   // 'userInfo.userCount': 2
            // }); //????????? ?????????

            // await FirebaseFirestore.instance
            //     .collection("recipes")
            //     .doc(fields[i][0].toString())
            //     .update({
            //       // 'ingredient' : FieldValue.arrayUnion([fields[i][2] ,  fields[i][3]]),
            //       'ingredient.${fields[i][2]}': fields[i][3],
            //       // 'userInfo.userCount': 2
            // });
            // } //????????? ?????? ingredient ?????? ???

        }
      }

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

//????????? ??????
enum ImageSourceType { gallery, camera }


void _delete(DocumentSnapshot doc) {
  FirebaseFirestore.instance.collection('product').doc(doc.id).delete();
}
