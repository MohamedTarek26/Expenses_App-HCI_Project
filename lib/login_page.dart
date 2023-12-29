import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
    body: Container(
           decoration: const BoxDecoration(
           gradient: LinearGradient(
            begin: Alignment(-1, 6.123234262925839e-17),
            end: Alignment(6.123234262925839e-17, 1),
            colors: [Color.fromRGBO(49, 75, 206, 1), Color.fromRGBO(49, 206, 196, 1),],
           ),
           ),
           child: Center(
             child: Column(
               children: [
                 const Gap(150),
                 const Text('WELCOME',style: TextStyle(
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
                             label: const Text("email"),
                             constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
                             enabledBorder: OutlineInputBorder(
                               borderSide: const BorderSide(width: 2, color: Colors.blueAccent),
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
                               borderSide: const BorderSide(width: 2, color: Colors.blueAccent),
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

                                 Navigator.pushReplacementNamed(context,"home");
                               } on FirebaseAuthException catch (e) {
                                 showError(false);
                               }

                             },
                             child: const Text('LOGIN',style: TextStyle(fontSize: 18)),
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
                             child: const Text("Register",style: TextStyle(fontSize: 16, color: Colors.blueAccent,fontWeight: FontWeight.bold)),
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
        