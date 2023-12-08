import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username="@asser26";
  File? _image;
  String fullName="Asser";
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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
                        InkWell(child: Text("Account info",style: TextStyle(fontSize: 20)),onTap: (){})]
            ),
            Gap(20),
            Row(
                children: [Gap(20),Icon(Icons.group,color: Colors.grey,size: 30),Gap(20),
                  InkWell(child: Text("Groups",style: TextStyle(fontSize: 20)),onTap: (){})]
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
                  InkWell(child: Text("Log Out",style: TextStyle(fontSize: 20,color: Colors.red)),onTap: (){})]
            ),
            Gap(20)
          ],
        ),
    );
  }
}
