import 'package:flutter/material.dart';
import 'package:hello_chat/models/chat_user.dart';

class UserRow extends StatelessWidget {
  final ChatUser chatUser;

  const UserRow(this.chatUser);

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
            backgroundColor: Color(0xff070c44),
          ),
          const SizedBox(width: 16),
          Text(
            chatUser.name!,
            style: const TextStyle(fontSize: 16,color: Colors.white),
          )
        ],
      ),
    );
  }
}
