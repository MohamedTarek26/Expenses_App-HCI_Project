import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


class loginPage extends StatefulWidget {
  @override
  _loginPage createState() => _loginPage();
}

class _loginPage extends State<loginPage> {
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
                 Gap(150),
                 Text('WELCOME',style: TextStyle(
                   color: Colors.white,
                   fontWeight: FontWeight.bold,
                   fontSize: 30,

                 )),
                 Gap(20),
                 Container(
                   width: 300,
                   height: 400,
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: Column(
                     children: [
                       Gap(50),
                       TextField(
                         decoration: InputDecoration(
                             border: const OutlineInputBorder(),
                             label: const Text("USERNAME"),
                             constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
                             enabledBorder: OutlineInputBorder(
                               borderSide: BorderSide(width: 2, color: Colors.blueAccent),
                               borderRadius: BorderRadius.circular(15),
                             )),
                         onChanged: (value) {
                         },
                       ),
                       Gap(40),
                       TextField(
                         keyboardType: TextInputType.visiblePassword,
                         decoration: InputDecoration(
                             border: const OutlineInputBorder(),
                             label: const Text("PASSWORD"),
                             constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
                             enabledBorder: OutlineInputBorder(
                               borderSide: BorderSide(width: 2, color: Colors.blueAccent),
                               borderRadius: BorderRadius.circular(15),
                             )),
                         onChanged: (value) {
                         },
                       ),
                       Gap(40),
                       Row(
                         children: [
                           Gap(50),
                           ElevatedButton(
                             style: ButtonStyle(
                                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                     RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(18.0),
                                     )
                                 ),
                               fixedSize: MaterialStateProperty.all(Size(200,10)),
                             ),
                             onPressed: () {
                               Navigator.pushReplacementNamed(context,"home");
                             },
                             child: Text('LOGIN',style: TextStyle(fontSize: 18)),
                           ),
                         ],
                       ),
                       const Gap(30),
                       Row(
                         children: [
                           Gap(30),
                           Text("Don't have an account?"),
                           Gap(5),
                           InkWell(
                             child: Text("Register",style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold)),
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
        