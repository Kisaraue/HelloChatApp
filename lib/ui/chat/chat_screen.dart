import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_chat/models/chat_user.dart';
import 'package:hello_chat/models/message.dart';
import 'package:hello_chat/ui/users/user_details_screen.dart';
import 'package:hello_chat/ui/widgets/chat_bubble_recipient.dart';
import 'package:hello_chat/ui/widgets/chat_bubble_self.dart';

class ChatScreen extends StatefulWidget {
  final String recipientUserEmail;

  const ChatScreen(this.recipientUserEmail);

  @override
  State<ChatScreen> createState() => _PageState();
}

class _PageState extends State<ChatScreen> {
  ChatUser? recipient;
  final TextEditingController _message = TextEditingController();
  String chatId = "";
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    loadRecipientData();
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void loadRecipientData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshotRecipient =
          await FirebaseFirestore.instance
              .collection("chat_users")
              .where("email", isEqualTo: widget.recipientUserEmail)
              .get();
      if (querySnapshotRecipient.docs.isNotEmpty) {
        recipient = ChatUser(widget.recipientUserEmail,
            querySnapshotRecipient.docs.first.get("full_name"));
        loadChat();
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error in get All Users List: ${e.toString()}');
    }
  }

  void loadChat() async {
    try {
      String? myEmail = firebaseAuth.currentUser?.email;
      final QuerySnapshot<Map<String, dynamic>> existingChatSnapshot =
          await FirebaseFirestore.instance.collection("chat_messages").where(
              "users",
              arrayContainsAny: [myEmail, widget.recipientUserEmail]).get();
      if (existingChatSnapshot.docs.isEmpty) {
        DocumentReference<Map<String, dynamic>> newDocument =
            await FirebaseFirestore.instance.collection("chat_messages").add({
          "users": [myEmail, widget.recipientUserEmail],
        });
        chatId = newDocument.id;
        print("Creating a new chat" + chatId);
      } else {
        chatId = existingChatSnapshot.docs.first.id;
        print("Using existing chat : " + chatId);
      }
      setState(() {});
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
        automaticallyImplyLeading: true,
        title: recipient != null ? Text(recipient!.name!) : const Text("Chat"),
        actions: [
          IconButton(onPressed: _showProfile, icon: const Icon(Icons.person))
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (chatId.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("chat_messages")
                .doc(chatId)
                .collection("messages")
                .orderBy("time")
                .snapshots(),
            builder: (context, snapshot) {
              print("Check data change");
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  List<QueryDocumentSnapshot> documents =
                      snapshot.data!.docs.reversed.toList();
                  return ListView.builder(
                    itemCount: documents.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      if (documents[index].get("time") != null) {
                        Timestamp timestamp = documents[index].get("time");
                        ChatMessage chatMessage = ChatMessage(
                            documents[index].get("message_data"),
                            documents[index].get("message_type"),
                            timestamp.toDate(),
                            documents[index].get("recipient"));
                        if (chatMessage.recipient !=
                            firebaseAuth.currentUser?.email) {
                          return ChatBubbleSelf(chatMessage);
                        } else {
                          return ChatBubbleRecipient(chatMessage);
                        }
                      } else {
                        return const Text("");
                      }
                    },
                  );
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _message,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Type your message",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _sendMessage,
                  child: Text(
                    _isSending ? "Sending" : 'Send',
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void _sendMessage() async {
    if (_message.text.isEmpty) {
      return;
    }
    setState(() {
      _isSending = true;
    });
    FirebaseFirestore.instance
        .collection("chat_messages")
        .doc(chatId)
        .collection("messages")
        .add({
      "message_data": _message.text,
      "message_type": "text",
      "recipient": recipient!.email,
      "time": FieldValue.serverTimestamp()
    });
    setState(() {
      _message.text = "";
      _isSending = false;
    });
  }

  void _showProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => UserDetailsScreen(widget.recipientUserEmail)));
  }
}
