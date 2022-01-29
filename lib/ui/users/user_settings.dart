import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/chat_user.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  ChatUser? user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserSettings();
  }

  void loadUserSettings() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshotUser =
          await FirebaseFirestore.instance
              .collection("chat_users")
              .where("email", isEqualTo: firebaseAuth.currentUser?.email)
              .get();
      if (querySnapshotUser.docs.isNotEmpty) {
        user = ChatUser(firebaseAuth.currentUser?.email,
            querySnapshotUser.docs.first.get("full_name"));
      } else {
        print('User not found');
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error in get user List: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff070c44),
      appBar: AppBar(
        backgroundColor: Color(0xff6226c5),
        title: const Text(
          'My Account',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Name: " + user!.name!,
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 24),
          Text(
            "Email: " + user!.email!,
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
