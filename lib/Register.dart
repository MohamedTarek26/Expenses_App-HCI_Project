// import 'dart:js_util';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transaction.dart' as trans;
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  Future<void> storeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('userEmail',_emailController.text);
    prefs.setString('username', _usernameController.text);
    prefs.setString('fullName', _fullNameController.text);
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
              const Gap(100),
              const Text('REGISTER',style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,

              )),
              const Gap(20),
              Container(
                width: 300,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Gap(40),
                    TextField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text("Full Name"),
                          constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2, color: Color.fromRGBO(49, 206, 196, 1)),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onChanged: (value) {
                      },
                    ),
                    const Gap(30),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text("Email"),
                          constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2, color: Color.fromRGBO(49, 206, 196, 1)),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onChanged: (value) {
                      },
                    ),
                    const Gap(30),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text("Username"),
                          constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2, color: Color.fromRGBO(49, 206, 196, 1)),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onChanged: (value) {
                      },
                    ),
                    const Gap(30),
                    TextField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text("Password"),
                          constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
                          enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2, color: Color.fromRGBO(49, 206, 196, 1)),
                          borderRadius: BorderRadius.circular(15),
                          )),
                      onChanged: (value) {
                      },
                    ),
                    const Gap(30),
        
                    Row(
                      children: [
                        const Gap(40),
                        Center(
                          child:
                        ElevatedButton(
                          
                          style: ButtonStyle(
                            
                            backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(49, 206, 196, 1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )
                            ),
                            fixedSize: MaterialStateProperty.all(const Size(200,10)),
                          ),
                          onPressed: () async {
                            try {
                              final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: _emailController.text ,
                                password: _passwordController.text,

                              );
                              // Create a document in Firestore for additional user information
                              await _firestore.collection('users').doc(_emailController.text).set({
                                'username': _usernameController.text,
                                'fullName': _fullNameController.text,
                                'email': _emailController.text,
                                'password': _passwordController.text,
                                'transactions': [],
                              });
                              await storeUserData();

                              print(_usernameController.text);
                              print(_fullNameController.text);
                              print(_passwordController.text);
                              Navigator.pushReplacementNamed(context,"home");
                              print('User registered: ${userCredential.user?.uid}');
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                print('The account already exists for that email.');
                              }
                            } catch (e) {
                              print(e);
                            }

                          },
                          child: const Text('Register',style: TextStyle(fontSize: 18, color:Colors.white,fontWeight: FontWeight.bold)),
                        ),
                    ),
                      ],
                    ),
                    const Gap(30),
                    Row(
                      children: [
                        const Gap(30),
                        const Text("Already have an account?"),
                        const Gap(5),
                        InkWell(
                          child: const Text("Sign in",style: TextStyle(fontSize: 16, color: Color.fromRGBO(49, 206, 196, 1),fontWeight: FontWeight.bold)),
                          onTap: (){
                            Navigator.pushReplacementNamed(context, "login");
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
