import 'package:expenses_hci/Data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore_for_file: prefer_const_constructors

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  Data user=Data("@Asser26", "name@gmail.com", "USD", "Asser Osama", Image.asset(""));
  @override
  void initState() {
    super.initState();
    updateData();
  }
  Future<void> updateData() async {
    String? updatedUsername = await getUserNamesFromLS();
    String? updatedFullName = await getUserFullNamesFromLS();
    String? updatedEmail = await getUserEmailFromLS();
    setState(() {
      user.username = updatedUsername ?? user.username;
      user.fullName = updatedFullName ?? user.fullName;
      user.email = updatedEmail ?? user.email;
    });
  }
  Future<String?> getUserNamesFromLS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
  Future<String?> getUserEmailFromLS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }
  Future<String?> getUserFullNamesFromLS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fullName');
  }
  Future<String> updateUsername() async {
    return await getUserNamesFromLS() ?? '';
  }
  Future<String> updateFullName() async {
    return await getUserFullNamesFromLS() ?? '';
  }
  Future<String> updateEmail() async {
    return await getUserEmailFromLS() ?? '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 56, 208, 213),
        centerTitle: true,
        // toolbarHeight: 80.0,
        elevation: 0,
        leading: const BackButton(color: Colors.black,style: ButtonStyle()),
        title: const Text(
            'Account Info',
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.black,
            fontWeight: FontWeight.bold

          ),
        ),
      ),
      body: Column(
        children: [
          Gap(100),
          Row(
            children: [
              Gap(20),
              Text("Full name: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Gap(50),
              Text(user.fullName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            ],
          ),
          Gap(30),
          Row(
            children: [
              Gap(20),
              Text("Email: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Gap(50),
              Text(user.email,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            ],
          ),
          Gap(30),
          Row(
            children: [
              Gap(20),
              Text("Username: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Gap(50),
              Text(user.username,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            ],
          ),
          Gap(30),
          Row(
            children: [
              Gap(20),
              Text("Currency: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Gap(60),
              Text(user.currency,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            ],
          ),
        ],
      ),
    );
  }
}
