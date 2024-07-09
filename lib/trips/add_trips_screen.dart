import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AddTripsScreen extends StatefulWidget {
  static const String id = 'add_trip_screen';

  const AddTripsScreen({super.key});

  @override
  AddTripScreenState createState() => AddTripScreenState();
}

class AddTripScreenState extends State<AddTripsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController nightsController = TextEditingController();
  File? _image;
  bool _isUploading = false;

  Future<void> addTrip() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isUploading = true;
      });

      String? imageUrl;
      if (_image != null) {
        imageUrl = await uploadImageToStorage(_image!);
      }

      String priceText = priceController.text;
      int price = int.parse(priceText);
      String nightText = nightsController.text;
      int nights = int.parse(nightText);

      FirebaseFirestore.instance.collection('trips').add({
        'title': titleController.text,
        'description': descriptionController.text,
        'price': price,
        'nights': nights,
        'img': imageUrl,
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
      }).whenComplete(() {
        setState(() {
          _isUploading = false;
        });
      });
    }
  }

  Future<String> uploadImageToStorage(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('trips/$fileName');

    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  String? _validateTextField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Trip'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => _validateTextField(value, 'Title'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => _validateTextField(value, 'Description'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) => _validateTextField(value, 'Price'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: nightsController,
                decoration: const InputDecoration(labelText: 'Nights'),
                validator: (value) => _validateTextField(value, 'Nights'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Pick Image'),
              ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.file(
                    _image!,
                    height: 200,
                  ),
                ),
              const SizedBox(height: 10),
              if (_isUploading)
                const Center(child: CircularProgressIndicator()),
              RoundedButton(
                onPressed: addTrip,
                title: 'Add Trip',
                colour: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color colour;

  const RoundedButton({
    required this.onPressed,
    required this.title,
    required this.colour,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
