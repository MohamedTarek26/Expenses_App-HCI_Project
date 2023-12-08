import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text("Full Name"),
                          constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2, color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onChanged: (value) {
                      },
                    ),
                    const Gap(30),
                    TextField(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text("Email"),
                          constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2, color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onChanged: (value) {
                      },
                    ),
                    const Gap(30),
                    TextField(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text("Username"),
                          constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2, color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onChanged: (value) {
                      },
                    ),
                    const Gap(30),
                    TextField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text("Password"),
                          constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2, color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onChanged: (value) {
                      },
                    ),
                    const Gap(30),
                    Row(
                      children: [
                        const Gap(40),
                        ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                  )
                              ),
                            fixedSize: MaterialStateProperty.all(const Size(200,10)),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context,"home");
                          },
                          child: const Text('SIGN UP'),
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
                          child: const Text("Sign in",style: TextStyle(fontSize: 16, color: Colors.blueAccent,fontWeight: FontWeight.bold)),
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
