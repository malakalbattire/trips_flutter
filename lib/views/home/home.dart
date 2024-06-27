//import 'package:animation_flutter/Notification/notifications_screen.dart';
import 'package:animation_flutter/Notification/notifications_screen.dart';
import 'package:flutter/material.dart';
//import 'package:animation_flutter/home/screen_title.dart';
import 'package:animation_flutter/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animation_flutter/trips/trip_details.dart';
//import 'package:animation_flutter/fav/fav.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class Home extends StatefulWidget {
  static const String id = 'home_screen';

  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  void getTripList() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            color: const Color(0xFFF1ECF7),
            padding: const EdgeInsetsDirectional.all(10),
            height: 50,
            width: double.infinity,
            child: IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, NotificationScreen.id),
              icon: const Icon(
                Icons.notifications,
              ),
            ),
          ),
          ImageSlideshow(
            width: double.infinity,
            height: 300,
            initialPage: 0,
            indicatorColor: Colors.blue,
            indicatorBackgroundColor: Colors.grey,
            autoPlayInterval: 3000,
            isLoop: true,
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/ski.png"),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topLeft),
                ),
                // child: GestureDetector,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, NotificationScreen.id);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/beach.png"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topLeft),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/ski.png"),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topLeft),
                ),
              ),
            ],
          ),
          kSizedBox20,
          // SizedBox(
          //   height: 160,
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const ScreenTitle(text: "Trips List"),
          //       GestureDetector(
          //         onTap: () {
          //           Navigator.pushNamed(context, NotificationScreen.id);
          //         },
          //         child: const Icon(Icons.notifications),
          //       ),
          //     ],
          //   ),
          // ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('trips').snapshots(),
            builder: (context, snapshot) {
              List<ListTile> tripsWidgets = [];
              if (snapshot.hasData) {
                final trips = snapshot.data?.docs.reversed.toList();
                for (var trip in trips!) {
                  final tripWidget = ListTile(
                      trailing: Text('\$${trip['price']}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripDetailsPage(trip.id),
                          ),
                        );
                      },
                      // onTap: () {
                      //   Navigator.pushNamed(context, TripDetails.id);
                      // },
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
                          tag: 'img ${trip['title']} ',
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
    );
  }
}
