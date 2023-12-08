import 'package:expenses_hci/Data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// ignore_for_file: prefer_const_constructors

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  Data user=Data("@Asser26", "name@gmail.com", "EGP", "Asser Osama", Image.asset(""));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey[50],
          elevation: 0,
          leading: BackButton(color: Colors.blue,style: ButtonStyle())
      ),
      body: Column(
        children: [
          Gap(80),
          Center(child: Text("Account info",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.blue)),),
          Gap(40),
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
