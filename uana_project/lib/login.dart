import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'provider/login_provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

/*
로그인 화면
 */
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true); // Login Provider 사용

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100.0),
            Image.asset('assets/uana_logo3.png'),
            const SizedBox(height: 16.0),
            const SizedBox(height: 10.0),

            SignInButton(
              Buttons.Google,
              text: '구글로 시작하기',
              onPressed: () async {
                try {
                  await loginProvider.signInWithGoogle(); // 구글 로그인
                  print("Google Login Success!!");
                  Navigator.pushNamed(context, '/home');

                } catch(e) {
                  if (e is FirebaseAuthException) {
                    print(e.message!);
                  }
                }
              },
            ),


            const SizedBox(height: 10.0),

            SizedBox(
              width: 220.0,
              height: 30.0,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const FaIcon(FontAwesomeIcons.question, color: Colors.black),
                label: const Text('GUEST'),
                onPressed: () async {
                  await loginProvider.signInWithAnonymous(); // 익명 로그인 (우리 프로젝트에는 딱히 필요 없을 듯?!)
                  print("Anonymous Login Success!!");
                  Navigator.pushNamed(context, '/home');
                },
              ),
            ),


          ],
        ),
      ),
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true); // Login Provider 사용
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.network('https://handong.edu/site/handong/res/img/logo.png'),
                const SizedBox(height: 16.0),
                const Text('Uana'),
              ],
            ),
            const SizedBox(height: 120.0),
            SizedBox(
              width: 50.0,
              height: 30.0,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                ),
                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                label: const Text('GOOGLE'),
                onPressed: () async {
                  try {
                    await loginProvider.signInWithGoogle(); // 구글 로그인
                    print("Google Login Success!!");
                    Navigator.pushNamed(context, '/home');

                  } catch(e) {
                    if (e is FirebaseAuthException) {
                      print(e.message!);
                    }
                  }
                },
              ),
            ),

            const SizedBox(height: 30.0),

            SizedBox(
              width: 50.0,
              height: 30.0,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const FaIcon(FontAwesomeIcons.question, color: Colors.black),
                label: const Text('GUEST'),
                onPressed: () async {
                  await loginProvider.signInWithAnonymous(); // 익명 로그인 (우리 프로젝트에는 딱히 필요 없을 듯?!)
                  print("Anonymous Login Success!!");
                  Navigator.pushNamed(context, '/home');
                },
              ),
            ),

            const SizedBox(height: 30.0),


          ],
        ),
      ),
    );
  }
   */
}