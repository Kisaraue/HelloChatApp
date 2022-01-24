import 'package:flutter/material.dart';
import 'package:hello_chat/models/message.dart';
import 'package:intl/intl.dart';

class ChatBubbleSelf extends StatelessWidget {
  final ChatMessage message;

  const ChatBubbleSelf(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              padding:
              const EdgeInsets.only(top: 8, bottom: 8, right: 10, left: 16),
              decoration: const BoxDecoration(
                color: Color(0xff6226c5),
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