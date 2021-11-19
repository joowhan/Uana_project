import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'login_provider.dart';
import 'package:provider/provider.dart';
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
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);
    return ListView(
      children: [
        const SizedBox(height: 30.0),
        SizedBox(
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

        const SizedBox(height: 30.0),
      ],
    );
  }
}