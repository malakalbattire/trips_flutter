import 'package:flutter/material.dart';
import 'package:animation_flutter/home/screenTitle.dart';
import 'package:animation_flutter/shared/tripList.dart';
import 'package:animation_flutter/Notification/notifications_screen.dart';
import 'package:animation_flutter/shared/constants.dart';

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
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg.png"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topLeft),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              kSizedBox30,
              SizedBox(
                height: 160,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ScreenTitle(text: "Trips List"),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, NotificationScreen.id);
                      },
                      child: kNotificationIcon,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: TripList(),
              )
              //Sandbox(),
            ],
          )),
    );
  }
}
