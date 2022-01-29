import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_chat/models/chat.dart';
import 'package:hello_chat/ui/chat/chat_screen.dart';
import 'package:hello_chat/ui/users/user_search_screen.dart';
import 'package:hello_chat/ui/users/user_settings.dart';
import 'package:hello_chat/ui/widgets/chat_row.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _PageState();
}

class _PageState extends State<MainScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<Chat> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("chat_messages")
        .snapshots()
        .listen((event) {
      getMyChats();
    });
    getMyChats();
  }

  void getMyChats() async {
    try {
      String? myEmail = firebaseAuth.currentUser?.email;
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("chat_messages")
              .where("users", arrayContains: myEmail)
              .get();
      _chats = [];
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        List<dynamic> users = queryDocumentSnapshot.get("users");
        String recipientEmail = "";
        if (users.first.toString() == myEmail) {
          recipientEmail = users.last.toString();
        } else {
          recipientEmail = users.first.toString();
        }
        Chat chat = Chat(queryDocumentSnapshot.id, recipientEmail);
        _chats.add(chat);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error in get my chat list: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff070c44),
      appBar: AppBar(
        backgroundColor: Color(0xff6226c5),
        title: const Text("Hello Chat"),
        actions: [
          FlatButton(
              padding: EdgeInsets.all(0.0),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserSettings()));
              },
              child: Image.asset("assets/images/Admin Settings Male.png"))
          // add more IconButton
        ],
      ),
      body: _buildBody(),
      floatingActionButton: !_isLoading
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: FloatingActionButton(
                backgroundColor: Color(0xff6226c5),
                onPressed: _newChat,
                tooltip: 'Increment',
                child: const Icon(Icons.chat),
              ),
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_chats.isEmpty) {
      return const Center(
        child: Text(
          'No chat found',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _chats.length,
      itemBuilder: (connectionContext, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            child: ChatRow(_chats[index].recipient),
            onTap: () => onChatTap(index),
          ),
        );
      },
    );
  }

  void _newChat() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const UserSearchScreen()));
  }

  onChatTap(int index) {
    String recipientUserEmail = _chats[index].recipient;
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => ChatScreen(recipientUserEmail)));
  }
}
