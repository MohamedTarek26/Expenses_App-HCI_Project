import 'package:expenses_hci/login_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage(),
      routes:{
        "login":(context)=>loginPage(),
        "home":(context)=>HomePage(),
      },
    );
  }
}
