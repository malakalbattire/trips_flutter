import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:animation_flutter/utilities/rounded_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_screen.dart';

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
  LatLng? _selectedLocation;
  bool _isImageSelected = true;
  bool _isLocationSelected = true;

  Future<void> addTrip() async {
    if ((_formKey.currentState?.validate() ?? false) &&
        _image != null &&
        _selectedLocation != null) {
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
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
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
    } else {
      setState(() {
        _isImageSelected = _image != null;
        _isLocationSelected = _selectedLocation != null;
      });
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (_selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a location'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
        _isImageSelected = true;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _selectLocation() async {
    final LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result;
        _isLocationSelected = true;
      });
    }
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
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _selectLocation,
                    child: Text(_selectedLocation == null
                        ? 'Select Location'
                        : 'Change Location'),
                  ),
                  if (_selectedLocation != null)
                    Text(
                        'Location: (${_selectedLocation!.latitude.toStringAsFixed(3)}, ${_selectedLocation!.longitude.toStringAsFixed(3)})'),
                ],
              ),
              if (!_isLocationSelected)
                const Text(
                  'Location is required',
                  style: TextStyle(color: Colors.red),
                ),
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
              if (!_isImageSelected)
                const Text(
                  'Image is required',
                  style: TextStyle(color: Colors.red),
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
