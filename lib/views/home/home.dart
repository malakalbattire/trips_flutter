import 'package:animation_flutter/Notification/notifications_screen.dart';
import 'package:animation_flutter/trips/trip_details.dart';
import 'package:animation_flutter/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animation_flutter/views/profile/user_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const String id = 'home_screen';
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${userProvider.userData!['name']} 👋🏻',
                          style: const TextStyle(
                              color: Color(0xFF2F2F2F),
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0),
                        ),
                        const Text(
                          'Explore the world!',
                          style: TextStyle(
                              color: Color(0xFF888888), fontSize: 18.0),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, NotificationScreen.id);
                        },
                        icon: const Icon(Icons.notifications_active_outlined)),
                  ],
                ),
                kSizedBox20,
                const Text(
                  'Popular places',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                StreamBuilderRow(),
                kSizedBox20,
                const Text(
                  'Explore more',
                  style: TextStyle(fontSize: 20),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('trips')
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Container> tripsWidgets = [];
                    if (snapshot.hasData) {
                      final trips = snapshot.data?.docs.reversed.toList();
                      for (var trip in trips!) {
                        final tripWidget = Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                              trailing: Text('\$${trip['price']}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TripDetailsPage(trip.id),
                                  ),
                                );
                              },
                              contentPadding: const EdgeInsets.all(10),
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
                                          fontSize: 20,
                                          color: Colors.grey[600])),
                                ],
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Hero(
                                  tag: 'img ${trip['title']} ',
                                  child: Image.network(
                                    trip['img'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),
                        );
                        tripsWidgets.add(tripWidget);
                      }
                    }
                    return Flexible(
                      fit: FlexFit.loose,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: tripsWidgets,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StreamBuilderRow extends StatefulWidget {
  @override
  _StreamBuilderRowState createState() => _StreamBuilderRowState();
}

class _StreamBuilderRowState extends State<StreamBuilderRow> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('trips').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final trips = snapshot.data?.docs.reversed.toList();
            List<Widget> tripsWidgets = trips!.map((trip) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailsPage(trip.id),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 220,
                          margin: const EdgeInsets.all(10),
                          child: Hero(
                            tag: 'img ${trip['title']}',
                            child: Image.network(
                              trip['img'],
                              height: 260.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                            top: 20,
                            right: 15,
                            width: 40,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(150, 255, 255, 255),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.favorite_border),
                                onPressed: () {},
                              ),
                            )),
                        Positioned(
                          bottom: 25,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(150, 255, 255, 255),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trip['title'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0,
                                      ),
                                    ),
                                    Text(
                                      '${trip['nights'].toString()} nights',
                                    ),
                                  ],
                                ),
                                Text('\$${trip['price'].toString()}'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList();

            return Row(
              children: tripsWidgets,
            );
          },
        ),
      ),
    );
  }
}
