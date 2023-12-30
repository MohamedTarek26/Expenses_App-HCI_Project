import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'transaction.dart' as trans;
import 'dart:convert';


class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  _loginPage createState() => _loginPage();
}

class _loginPage extends State<loginPage> {
  String errorMessage="";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void showError(bool hide) {
    setState(() {
      if(!hide) {
        errorMessage='email or password are incorrect';
      } else {
        errorMessage="";
      }
    });
  }
  get_image()
  {
    return get_image();
  }
  Future<void> storeUserEmail(String? userEmail) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', userEmail ?? '');
    if (userEmail != null) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userEmail).get();
      if (userSnapshot.exists && userSnapshot.data() != null &&
          userSnapshot.data()!.containsKey('username')) {
        print(userSnapshot.get('username'));
        print(userSnapshot.get('fullName'));
        // print(userSnapshot.get('transactions')[0]);
        print(json.encode(userSnapshot.get('transactions')));
        print("test");
        prefs.setString('username', userSnapshot.get('username'));
        prefs.setString('fullName', userSnapshot.get('fullName'));
        prefs.setString('transactions',json.encode(userSnapshot.get('transactions')) );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment(-1, 6.123234262925839e-17),
        //     end: Alignment(6.123234262925839e-17, 1),
        //     colors: [Color.fromRGBO(49, 75, 206, 1), Color.fromRGBO(49, 206, 196, 1),],
        //   ),
        // ),
        color: Color.fromRGBO(49, 206, 196, 1),
        child: Center(
          child: Column(
            children: [
              const Gap(150),
              const Text('Sign In',style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              )),
              const Gap(20),
              Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Gap(50),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text("EMAIL"),
                          constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2, color:   Color.fromRGBO(49, 206, 196, 1),),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onChanged: (value) {
                      },
                    ),
                    const Gap(40),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text("PASSWORD"),
                          constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2, color: Color.fromRGBO(49, 206, 196, 1)),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onChanged: (value) {
                      },
                    ),
                    const Gap(10),
                    Text(errorMessage,style: const TextStyle(color: Colors.red,fontSize: 17),),
                    const Gap(20),
                    Row(
                      children: [
                        const Gap(50),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(49, 206, 196, 1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )
                            ),
                            fixedSize: MaterialStateProperty.all(const Size(200,10)),
                          ),
                          onPressed: () async {
                            showError(true);
                            try {
                              final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              await storeUserEmail(_emailController.text);
                              Navigator.pushReplacementNamed(context,"home");
                            } on FirebaseAuthException catch (e) {
                              showError(false);
                            }

                          },
                          child: const Text('LOGIN',style: TextStyle(fontSize: 18, color:Colors.white,fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const Gap(30),
                    Row(
                      children: [
                        const Gap(30),
                        const Text("Don't have an account?"),
                        const Gap(5),
                        InkWell(
                          child: const Text("Register",style: TextStyle(fontSize: 16, color: Color.fromRGBO(49, 206, 196, 1),fontWeight: FontWeight.bold)),
                          onTap: (){
                            Navigator.pushReplacementNamed(context, "Register");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
        