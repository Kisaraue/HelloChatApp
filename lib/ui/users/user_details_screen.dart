import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_chat/models/chat_user.dart';

class UserDetailsScreen extends StatefulWidget {
  final String email;

  UserDetailsScreen(this.email);

  @override
  State<UserDetailsScreen> createState() => _PageState();
}

class _PageState extends State<UserDetailsScreen> {
  ChatUser? user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  void loadUserDetails() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshotRecipient =
          await FirebaseFirestore.instance
              .collection("chat_users")
              .where("email", isEqualTo: widget.email)
              .get();
      if (querySnapshotRecipient.docs.isNotEmpty) {
        user = ChatUser(
            widget.email, querySnapshotRecipient.docs.first.get("full_name"));
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
    return Scaffold( backgroundColor: Color(0xff070c44),
      appBar: AppBar(
        backgroundColor: Color(0xff6226c5),
        title: const Text(
          'User details',
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
          Text("Name: " + user!.name!,
          style: TextStyle(color: Colors.white),),
          const SizedBox(height: 16),
          Text("Email: " + user!.email!,
            style: TextStyle(color: Colors.white),),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
