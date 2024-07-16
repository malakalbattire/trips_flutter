import 'package:animation_flutter/utilities/constants.dart';
import 'package:animation_flutter/views/notifications_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animation_flutter/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/column_stream_builder.dart';
import '../widgets/stream_builder_row.dart';

class Home extends StatefulWidget {
  static const String id = 'home_screen';
  final String userId;
  const Home({super.key, required this.userId});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = userProvider.user;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user found')),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                          'Hello, ${userProvider.userData?['name'] ?? 'User'} 👋🏻',
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
                      icon: const Icon(Icons.notifications_active_outlined),
                    ),
                  ],
                ),
                kSizedBox10,
                const StreamBuilderRow(),
                kSizedBox20,
                const Text(
                  'Popular places',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const ColumnStreamBuilder(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
