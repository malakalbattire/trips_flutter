import 'package:animation_flutter/Notification/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:animation_flutter/home/screen_title.dart';
import 'package:animation_flutter/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animation_flutter/details/trip_details.dart';

class Home extends StatefulWidget {
  static const String id = 'home_screen';

  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void getTripList() {}
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
            kSizedBox20,
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
                    child: const Icon(Icons.notifications),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('trips').snapshots(),
              builder: (context, snapshot) {
                List<ListTile> tripsWidgets = [];
                if (snapshot.hasData) {
                  final trips = snapshot.data?.docs.reversed.toList();
                  for (var trip in trips!) {
                    final tripWidget = ListTile(
                        trailing: Text('\$${trip['price']}'),
                        onTap: () {
                          Navigator.pushNamed(context, TripDetails.id);
                        },
                        contentPadding: const EdgeInsets.all(25),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('${trip['nights']} nights'.toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[300])),
                            Text(trip['title'].toString(),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey[600])),
                          ],
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Hero(
                            tag: 'location-img',
                            child: Image.network(
                              trip['img'],
                              height: 50.0,
                            ),
                          ),
                        ));
                    //trailing: Text('\$${trip['price']}');
                    tripsWidgets.add(tripWidget);
                  }
                }
                return Expanded(
                  child: ListView(
                    children: tripsWidgets,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
