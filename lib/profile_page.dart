import 'dart:io';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: prefer_const_constructors

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username="@asser26";
  File? _image;
  String fullName="Asser";
  bool isGroupsExpanded = false;
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }
  @override
  void initState() {
    super.initState();
    updateData();
  }
 Future<void> updateData() async {
    String? updatedUsername = await getUserNamesFromLS();
    String? updatedFullName = await getUserFullNamesFromLS();

    setState(() {
      username = updatedUsername ?? username;
      fullName = updatedFullName ?? fullName;
    });
  }
Future<String?> getUserNamesFromLS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
Future<String?> getUserFullNamesFromLS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
  Future<String> updateUsername() async {
   return await getUserNamesFromLS() ?? '';
  }
  Future<String> updateFullName() async {
   return await getUserFullNamesFromLS() ?? '';
  }
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
            Gap(50),
           Row(
             children: [
               Gap(130),
                 CircleAvatar(
                   radius: 50,
                   backgroundImage: _image != null ? FileImage(_image!) : null,
                   child: _image == null
                       ? const Icon(
                     Icons.person,
                     size: 40.0,
                     color: Colors.white,
                   )
                       : null,
                 ),
               ElevatedButton(
                 style: ButtonStyle(
                   shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                 ),
                 onPressed: _getImage,
                 child:Icon(Icons.camera_alt),
               ),
             ],
           ),
            Gap(10),
            Text(fullName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
            Gap(10),
            Text(username,style: TextStyle(fontSize: 16,fontStyle: FontStyle.italic,color: Colors.blue)),
            Gap(50),
            Row(
              children: [Gap(20),Icon(Icons.person,color: Colors.grey,size: 30),Gap(20),
                        InkWell(child: Text("Account info",style: TextStyle(fontSize: 20)),onTap: (){
                          Navigator.pushNamed(context,"account info");})]
            ),
            Gap(20),
             Row(
                 children: [Gap(20),Icon(Icons.group,color: Colors.grey,size: 30),Gap(20),
                   InkWell(child: Text("Groups",style: TextStyle(fontSize: 20)),
                       onTap: (){setState(() {isGroupsExpanded=!isGroupsExpanded;});
                       }),
                 ]
             ),
            Column(
              children: isGroupsExpanded?[
                Gap(20),
                Row(
                    children: [Gap(50),Icon(Icons.add,color: Colors.blue,size: 30),Gap(10),
                      InkWell(child: Text("Create Group",style: TextStyle(fontSize: 20,color:Colors.blue)),onTap: (){})]
                ),
                Gap(20),
                Row(
                    children: [Gap(50),Icon(Icons.group_add_rounded,color: Colors.blue,size: 30),Gap(10),
                      InkWell(child: Text("Join Group",style: TextStyle(fontSize: 20,color: Colors.blue)),onTap: (){})]
                ),
                Gap(20),
                Row(
                    children: [Gap(50),Icon(Icons.groups,color: Colors.blue,size: 30),Gap(10),
                      InkWell(child: Text("View Groups",style: TextStyle(fontSize: 20,color: Colors.blue)),onTap: (){})]
                ),
                Gap(20)]
              :[],
            ),
            Gap(20),
            Row(
                children: [Gap(20),Icon(Icons.notifications,color: Colors.grey,size: 30),Gap(20),
                  InkWell(child: Text("Notifications",style: TextStyle(fontSize: 20)),onTap: (){})]
            ),
            Gap(20),
            Row(
                children: [Gap(20),Icon(Icons.help,color: Colors.grey,size: 30),Gap(20),
                  InkWell(child: Text("Help",style: TextStyle(fontSize: 20)),onTap: (){})]
            ),
            Gap(20),
            Row(
                children: [Gap(20),Icon(Icons.logout,color: Colors.red,size: 30),Gap(20),
                  InkWell(child: Text("Log Out",style: TextStyle(fontSize: 20,color: Colors.red)),
                      onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context,"login");
                  })]
            ),
            Gap(20)

          ],
        ),

    );
  }
}
