import 'package:flutter/material.dart';
import 'package:animation_flutter/home/screenTitle.dart';
import 'package:animation_flutter/shared/tripList.dart';

class Home extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/bg.png"),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topLeft),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                SizedBox(
                  height: 160,
                  child: ScreenTitle(text: "Trips List"),
                ),
                Flexible(
                  child: TripList(),
                )
                //Sandbox(),
              ],
            )));
  }
}
