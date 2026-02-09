import 'package:flutter/material.dart';

class InputBar extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isDarkMode; // <--- Dinagdag natin ito para malaman ng bar kung dark mode

  const InputBar({
    Key? key,
    required this.onSendMessage,
    required this.isDarkMode // <--- Kailangan itong ipasa galing sa ChatScreen
  }) : super(key: key);

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nagbabagong kulay depende sa mode
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final hintColor = widget.isDarkMode ? Colors.white60 : Colors.grey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              // ETO ANG MAGPAPALIT NG KULAY NG TYPEWRITTEN TEXT
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Type your message..',
                hintStyle: TextStyle(color: hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: widget.isDarkMode ? Colors.white24 : Colors.grey),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            mini: true,
            backgroundColor: const Color(0xFF9bafd9),
            child: const Icon(Icons.send, color: Colors.black),
          )
        ],
      ),
    );
  }
}