import 'package:expenses_hci/Register.dart';
import 'package:expenses_hci/accountinfoPage.dart';
import 'package:expenses_hci/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import 'welcome.dart';

Future<void>  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState()=>_MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('=======================================User is currently signed out!');
      } else {
        print('=======================================User is signed in!');
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseAuth.instance.currentUser== null ? const WelcomePage(): const HomePage(),
      routes: {
        "login": (context) => const loginPage(),
        "home": (context) => const HomePage(),
        "Register": (context) => const RegisterPage(),
        "account info": (context) => const AccountInfo(),
      },
    );
  }
}
