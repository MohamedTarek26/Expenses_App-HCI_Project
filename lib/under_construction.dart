// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class UnderConstruction extends StatefulWidget {
  @override
  _UnderConstruction createState() => _UnderConstruction();
}

class _UnderConstruction extends State<UnderConstruction> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 414,
        height: 896,
        child: Stack(children: <Widget>[
          Positioned(
              top: 3,
              left: -3,
              child: Container(
                  width: 417,
                  height: 893,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment(-1, 6.123234262925839e-17),
                        end: Alignment(6.123234262925839e-17, 1),
                        colors: [
                          Color.fromRGBO(49, 75, 206, 1),
                          Color.fromRGBO(49, 206, 196, 1)
                        ]),
                  ))),
          Positioned(
            top: 60,
            left: 10,
            child: GestureDetector(
              onTap: () {
                // Handle back button press
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.transparent,
                width: 41,
                height: 36,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white, // Customize the color
                ),
              ),
            ),
          ),
          Positioned(
              top: 387,
              left: 70,
              child: DefaultTextStyle(
                child: Text(
                  'Page Under \n Development',
                  textAlign: TextAlign.center,
                ),
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Roboto',
                    fontSize: 36,
                    letterSpacing:
                        1 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.w900,
                    height: 1),
              )),
        ]));
  }
}
