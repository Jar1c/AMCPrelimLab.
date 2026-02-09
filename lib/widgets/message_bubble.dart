import 'package:flutter/material.dart';
import '/models/chat_message.dart';

class MessageBubble extends StatelessWidget{
  final ChatMessage message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUserMessage
        ? Alignment.centerRight
        : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUserMessage
              ? const Color(0xFF9bafd9) // User: Brighter blue
              : const Color(0xFF103783), // AI: Green (Gemini!)
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 16,
            // ETO ANG MAGPAPALIT NG KULAY NG TEXT:
            color: message.role == 'user'
                ? Colors.black  // Kulay ng text para sa User
                : Colors.grey[300], // Kulay ng text para sa AI (Reply)
          ),
        ),
      ),
    );
  }
}