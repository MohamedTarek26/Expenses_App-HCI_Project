import 'package:expenses_hci/Register.dart';
import 'package:expenses_hci/accountinfoPage.dart';
import 'package:expenses_hci/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import 'welcome.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage(),
      routes: {
        "login": (context) => const loginPage(),
        "home": (context) => const HomePage(),
        "Register": (context) => const RegisterPage(),
        "account info": (context) => const AccountInfo(),
      },
    );
  }
}
