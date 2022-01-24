import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRow extends StatefulWidget {
  final String recipient;

  const ChatRow(this.recipient);

  @override
  State<ChatRow> createState() => _ChatRowState();
}

class _ChatRowState extends State<ChatRow> {
  String displayName = "";
  String profilePic = "";

  @override
  void initState() {
    super.initState();
    displayName = widget.recipient;
    getUserData();
  }

  void getUserData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("chat_users")
              .where("email", isEqualTo: widget.recipient)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        displayName = querySnapshot.docs.first.get("full_name");
        profilePic = querySnapshot.docs.first.get("profile_pic");
      }
      setState(() {});
    } catch (e) {
      print('Error in get user List: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            backgroundColor: Color(0xff6226c5),
          ),
          const SizedBox(width: 16),
          Text(
            displayName,
            style: const TextStyle(fontSize: 16,
            color: Colors.white),
          )
        ],
      ),
    );
  }
}
