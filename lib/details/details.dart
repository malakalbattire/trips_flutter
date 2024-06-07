import 'package:flutter/material.dart';
import 'package:animation_flutter/details/trip.dart';
import 'package:animation_flutter/details/heart.dart';

class Details extends StatelessWidget {
  static const String id = 'details_screen';
  final Trip trip;
  Details({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                  child: Hero(
                tag: 'location-img-${trip.img}',
                child: Image.asset(
                  'images/${trip.img}',
                  height: 360,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              )),
              SizedBox(height: 30),
              ListTile(
                  title: Text(trip.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey[800])),
                  subtitle: Text(
                      '${trip.nights} night stay for only \$${trip.price}',
                      style: TextStyle(letterSpacing: 1)),
                  trailing: Heart()),
              Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                      'in the civil law of Louisiana  : the signature of a notary public on a document accompanied by a date, identification of parties, seal, or other required elements',
                      style: TextStyle(color: Colors.grey[600], height: 1.4))),
            ],
          ),
        ));
  }
}
