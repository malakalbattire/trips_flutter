import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animation_flutter/utilities/rounded_button.dart';
import 'package:animation_flutter/utilities/constants.dart';

class AddTripsScreen extends StatefulWidget {
  static const String id = 'add_trip_screen';

  const AddTripsScreen({super.key});

  @override
  AddTripScreenState createState() => AddTripScreenState();
}

class AddTripScreenState extends State<AddTripsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController nightsController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  void addTrip() {
    FirebaseFirestore.instance.collection('trips').add({
      'title': titleController.text,
      'description': descriptionController.text,
      'price': priceController.text,
      'nights': nightsController.text,
      'img': imageController.text,
    }).then((value) {
      Navigator.pop(context);
    }).catchError((error) {
      print("Failed to add trip: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add trip'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Trip'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            kSizedBox10,
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'description'),
            ),
            kSizedBox10,
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            kSizedBox10,
            TextField(
              controller: nightsController,
              decoration: const InputDecoration(labelText: 'Nights'),
            ),
            kSizedBox10,
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            kSizedBox10,
            RoundedButton(
              onPressed: addTrip,
              title: 'Add Trip ',
              colour: Colors.lightBlueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
