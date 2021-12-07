
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uana_project/recipe/recipe_detail.dart';
import 'package:uana_project/provider/recipe_provider.dart';
import 'package:uana_project/theme/light_colors.dart';
import '../provider/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';

/*
사용자 프로필 화면 (로그아웃 가능)
 */
class ProfilePage extends StatefulWidget {
  const ProfilePage ({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  List<Card> _buildGridCards(BuildContext context, int index) {
    RecipeProvider recipeProvider = Provider.of(context, listen : true); // provider 사용
    List<List<RecipeInfo>> changeRecipeList = [recipeProvider.favoriteRecipes,recipeProvider.myRecipes];
    if (recipeProvider.favoriteRecipes.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
  print(index);
    return changeRecipeList[index].map((recipe) {// 중간, 기말 때 썼던 예제 그대로
      return Card(
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
                aspectRatio: 15 / 11,

                child: Image.network(
                  recipe.path,
                  fit: BoxFit.fill,
                ),

              ),
              // Container(
              //   width: double.infinity,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: <Widget>[
              //       Text(
              //         recipe.foodName,
              //         style: TextStyle(
              //           fontSize: 10,
              //         ),
              //         maxLines: 1,
              //       ),
              //       // SizedBox(height: 1,)
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      );
    }).toList();
  }
  final ValueNotifier<int> _changeSetting = ValueNotifier<int>(0);
  final ValueNotifier<bool> _changeSetting2 = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);


    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ListView(
          children: <Widget>[
            Center(
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage("${loginProvider.userInformation?.profileUrl}"),

                  ),

                  Positioned(
                    bottom: 20,
                    right: 5,
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color:Colors.indigo,
                        size: 40,
                      ),
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => EditProfilePage()),
                        );
                      },

                    ),
                  ),
                ],
              ),
            ),

            //profileImage(),
            Text(
              loginProvider.userInformation!.name
            ),
            Text(
                loginProvider.userInformation!.email
            ),
            Text(
                'User Message: ${loginProvider.userInformation!.statusMessage}'
            ),
            SizedBox(height:20),


            ValueListenableBuilder(
                valueListenable: _changeSetting2,
                builder: (BuildContext contex, bool bvaule, Widget? child){
                  return Row(
                    children: [
                      Container(
                        decoration : BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: _changeSetting2.value == true? LightColors.eachRecipe.withOpacity(1) : LightColors.homeback.withOpacity(1),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ]
                        ),
                        child: IconButton(
                          onPressed: (){
                            setState(() {
                              _changeSetting.value = 0;
                              _changeSetting2.value = true;
                            });
                          },
                          icon: const Icon(Icons.star,),
                          color: _changeSetting2.value == true ?  Colors.green : Colors.black,

                        ),
                      ),
                      Container(
                        decoration : BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: _changeSetting2.value == false? LightColors.eachRecipe.withOpacity(1) : LightColors.homeback.withOpacity(1),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ]
                        ),
                        child: IconButton(
                            onPressed: (){
                              setState(() {
                                _changeSetting.value = 1;
                                _changeSetting2.value = false;
                              });
                            },
                            icon : const Icon(Icons.account_circle),
                            color: _changeSetting2.value == false ?  Colors.green : Colors.black,
                        ),
                      ),
                    ],
                  );
                }),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              child:
              Text(
                  _changeSetting2.value == true ? '즐겨찾기' : '내가 올린 레시피'
              ),
            ),
            SizedBox(
              height: 250,
              child: ValueListenableBuilder(
                  valueListenable: _changeSetting,
                  builder: (BuildContext context, int svalue, Widget? child){
                    return Expanded(
                      child: GridView.count( // 카드 한 줄에 하나씩 출력 되도록
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        crossAxisCount: 3,
                        padding: const EdgeInsets.all(0.0),
                        childAspectRatio: 11.5 / 9.0,
                        children: _buildGridCards(context, _changeSetting.value),
                      ),
                    );
                  }
              ),
            ),

            Positioned(
              bottom: 30,
              child: SizedBox(
              //width: 50.0,
              height: 30.0,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const FaIcon(FontAwesomeIcons.signOutAlt, color: Colors.black),
                label: const Text('Logout'),
                onPressed: () async {
                  await loginProvider.signOut(); // 로그아웃
                  print("Logout Success!!");
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),
            )

            //LogoutField(),
          ],
        ),
     ),
    );
  }
}

//update 된 내용을 db에 저장해야함
//image picker는 넣지말까 고민중 받아올때에는 url로 받아오는데 올리는건 image 데이터 파일

// Edit Page
class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _controller1 = TextEditingController();
  String description ='';
  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);
    return Scaffold(
      body: Form(
        key: _formKey,
        //padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage("${loginProvider.userInformation?.profileUrl}"),

                  ),
                  Positioned(
                    bottom: 20,
                    right: 5,
                    child: InkWell(
                      onTap: (){
                        showModalBottomSheet(context: context, builder: ((builder) =>bottomSheet()));
                      },
                      child: const Icon(
                        Icons.camera_alt,
                        color:Colors.indigo,
                        size: 40,
                      ),
                    ),
                  ),

                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(20),),
            Text(
                'User Name: ${loginProvider.userInformation!.name}'
            ),
            Text(
                'User Email Address: ${loginProvider.userInformation!.email}'
            ),
            const Padding(padding: EdgeInsets.all(20),),
            TextFormField(
              onSaved: (value){
                setState(() {
                  description = value!;
                });
              },
              controller: _controller1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.indigo,
                    width: 2,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.indigo,
                ),

                labelText: 'Update Status Message',
                hintText: 'Input',

              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your message to continue';
                }
                return null;
              },
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  //add update function
                  // FirebaseFirestore.instance
                  //     .collection('user')
                  //     .doc(loginProvider.userInformation!.uid)
                  //     .update(<String, dynamic>{
                  //   'status_message': description,
                  // });
                  // Navigator.pushReplacement(context, MaterialPageRoute(
                  //     builder: (context) => ProfilePage()));
                  _controller1.clear();
                  Navigator.pop(context);
                }
              },
              child: Row(
                children: const [
                  Icon(Icons.save),
                  SizedBox(width: 10),
                  Text('Save'),
                ],
              ),
            ),

          ],
        ),


      ),
    );
  }

  Widget bottomSheet(){
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20,),
      child: Column(
        children: <Widget>[
          const Text(
            '사진을 선택하세요.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.camera, size: 50,),
                onPressed: (){
                  selectPhoto(ImageSource.camera);
                },

              ),
              IconButton(
                icon: const Icon(Icons.photo_library, size: 50,),
                onPressed: (){
                  selectPhoto(ImageSource.gallery);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  selectPhoto(ImageSource source) async{
    final pickedFile = await _picker.getImage(source:source);
    setState(() {
      _imageFile = pickedFile!;
    });
  }
}