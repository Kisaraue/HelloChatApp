import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_chat/models/chat_user.dart';
import 'package:hello_chat/ui/chat/chat_screen.dart';
import 'package:hello_chat/ui/widgets/user_row.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({Key? key}) : super(key: key);

  @override
  State<UserSearchScreen> createState() => _PageState();
}

class _PageState extends State<UserSearchScreen> {
  List<ChatUser> _users = [];
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  void getAllUsers() async {
    try {
      String? email = firebaseAuth.currentUser?.email;
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("chat_users")
              .where("email", isNotEqualTo: email)
              .get();
      _users = [];
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        _users.add(ChatUser(
            queryDocumentSnapshot.id, queryDocumentSnapshot.get("full_name")));
      }
      setState(() {});
    } catch (e) {
      print('Error in get All Users List: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff070c44),
      appBar: AppBar(
        backgroundColor: Color(0xff6226c5),
        title: const Text("Select User"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _users.length,
        itemBuilder: (connectionContext, index) {
          return InkWell(
            child: UserRow(_users[index]),
            onTap: () => onUserTap(index),
          );
        },
      ),
    );
  }

  void onUserTap(int index) {
    String recipientUserEmail = _users[index].email.toString();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => ChatScreen(recipientUserEmail)));
  }
}
