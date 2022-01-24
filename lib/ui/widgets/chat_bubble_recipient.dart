import 'package:flutter/material.dart';
import 'package:hello_chat/models/message.dart';
import 'package:intl/intl.dart';

class ChatBubbleRecipient extends StatelessWidget {
  final ChatMessage message;

  const ChatBubbleRecipient(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, right: 16, left: 10),
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.messageData,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    DateFormat('hh:mm a').format(message.time),
                    style: const TextStyle(color: Colors.white, fontSize: 9),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
