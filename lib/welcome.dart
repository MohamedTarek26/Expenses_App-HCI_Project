// ignore_for_file: prefer_const_constructors

import 'package:expenses_hci/home_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 414,
        height: 896,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1, 6.123234262925839e-17),
            end: Alignment(6.123234262925839e-17, 1),
            colors: [
              Color.fromRGBO(49, 75, 206, 1),
              Color.fromRGBO(49, 206, 196, 1),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DefaultTextStyle(
                child: Text(
                  'Welcome',
                  textAlign: TextAlign.center,
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  fontSize: 36,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Navigate to another page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Let's Get Started",
                    style: TextStyle(
                      color: Color.fromRGBO(
                          49, 75, 206, 1), // Same color as the page
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
