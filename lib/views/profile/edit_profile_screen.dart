import 'package:animation_flutter/widgets/navigation_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animation_flutter/widgets/rounded_button.dart';
import 'package:animation_flutter/utilities/constants.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;

class EditProfileScreen extends StatefulWidget {
  static const String id = 'edit_profile_screen';
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'name': _nameController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Update Your FullName',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              RoundedButton(
                title: 'Update Profile',
                colour: Colors.lightBlueAccent,
                onPressed: () {
                  _updateUserProfile();
                  Navigator.pushNamed(context, NavigationMenu.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
