// import 'package:flutter/material.dart';
// import '../models/chat_message.dart';
// import '../widgets/message_bubble.dart';
// import '../widgets/input_bar.dart';
// import '../services/gemini_service.dart';
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//
//   final Map<String, List<ChatMessage>> personaHistories = {
//     "Doc Willbert": [],
//     "Professor Luna": [],
//     "Attorney Lex": [],
//     "MindCare AI": [],
//     "Astronaut Hax": [],
//   };
//
//   List<ChatMessage> get currentMessages => personaHistories[selectedPersonality] ?? [];
//
//   final ScrollController scrollController = ScrollController();
//
//   bool _isLoading = false;
//
//   bool _isDarkMode = false;
//
//   String selectedPersonality = "Doc Willbert";
//
//   final List<Map<String, String>> personas = [
//     {"name": "Doc Willbert", "image": "assets/doctor.png", "desc": "Medical Expert"},
//     {"name": "Artist Luna", "image": "assets/artist.png", "desc": "Academic Guide"},
//     {"name": "Engr. Terra", "image": "assets/engineer.png", "desc": "Legal Advisor"},
//     {"name": "Travel advisor Ava", "image": "assets/travelAdvisor.png", "desc": "Emotional Support"},
//     {"name": "Astronaut Hax", "image": "assets/astronaut.png", "desc": "Space Explorer"},
//   ];
//
//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   void addMessage(String text, String role) {
//     setState(() {
//
//       personaHistories[selectedPersonality]!.add(ChatMessage(
//         text: text,
//         role: role,
//         timestamp: DateTime.now(),
//       ));
//     });
//     scrollToBottom();
//   }
//
//   void scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (scrollController.hasClients) {
//         scrollController.animateTo(
//           0.0,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   Future<void> handleSend(String text) async {
//     addMessage(text, "user");
//
//     setState(() => _isLoading = true);
//
//     try {
//       final aiResponse = await GeminiService.sendMultiTurnMessage(
//         currentMessages,
//         text,
//         personality: selectedPersonality,
//       );
//
//       addMessage(aiResponse, "model");
//     } catch (e) {
//       addMessage('❌ Error: $e', "model");
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bgColor = _isDarkMode ? Color(0xFF222831) : Color(0xFFECECEC);
//     final textColor = _isDarkMode ? Colors.white : Colors.black87;
//     final drawerColor = _isDarkMode ? Color(0xFF222831) : Colors.white;
//
//     return Scaffold(
//       backgroundColor: bgColor,
//
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Echo AI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text('Chatting with: $selectedPersonality', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
//           ],
//         ),
//         actions: [
//           Builder(
//             builder: (context) => IconButton(
//               icon: Icon(Icons.settings, color: Colors.white),
//               onPressed: () {
//                 Scaffold.of(context).openEndDrawer();
//               },
//             ),
//           ),
//         ],
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xFF9bafd9),
//                 Color(0xFF103783),
//               ],
//             ),
//           ),
//         ),
//         elevation: 2,
//       ),
//
//       drawer: Drawer(
//         backgroundColor: drawerColor,
//         child: Column(
//           children: [
//             UserAccountsDrawerHeader(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Color(0xFF103783),
//                     Color(0xFF9bafd9),
//                   ],
//                 ),
//               ),
//               accountName: Text("Select AI Persona"),
//               accountEmail: Text("Choose who to talk to"),
//               currentAccountPicture: CircleAvatar(
//                 backgroundColor: Colors.white70,
//                 child: Icon(Icons.psychology, color: Color(0xFF000000), size: 40),
//               ),
//             ),
//
//             Expanded(
//               child: ListView.builder(
//                 itemCount: personas.length,
//                 itemBuilder: (context, index) {
//                   final persona = personas[index];
//                   bool isSelected = selectedPersonality == persona['name'];
//
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: AssetImage(persona['image']!),
//                     ),
//                     title: Text(
//                       persona['name']!,
//                       style: TextStyle(
//                         color: textColor,
//                         fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                       ),
//                     ),
//                     subtitle: Text(
//                       persona['desc']!,
//                       style: TextStyle(
//                         color: _isDarkMode ? Colors.white70 : Colors.black54,
//                       ),
//                     ),
//                     trailing: isSelected ? Icon(Icons.check_circle, color: Colors.green) : null,
//                     selected: isSelected,
//                     onTap: () {
//                       setState(() {
//                         selectedPersonality = persona['name']!;
//                       });
//                       Navigator.pop(context);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//
//       endDrawer: Drawer(
//         backgroundColor: drawerColor,
//         child: Column(
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF103783), Color(0xFF9bafd9)],
//                 ),
//               ),
//               child: const Center(
//                 child: Text("Settings", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
//               ),
//             ),
//             SwitchListTile(
//               secondary: Icon(
//                 _isDarkMode ? Icons.dark_mode : Icons.light_mode,
//                 color: _isDarkMode ? Colors.amber : Colors.blue,
//               ),
//               title: Text(
//                   "Dark Mode",
//                   style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87)
//               ),
//               value: _isDarkMode,
//               onChanged: (bool value) {
//                 setState(() {
//                   _isDarkMode = value;
//                 });
//               },
//             ),
//             const Divider(),
//           ],
//         ),
//       ),
//
//       body: Column(
//         children: [
//           Expanded(
//             child: currentMessages.isEmpty
//                 ? _buildEmptyState()
//                 : ListView.builder(
//               controller: scrollController,
//               reverse: true,
//               padding: EdgeInsets.all(10),
//               itemCount: currentMessages.length,
//               itemBuilder: (context, index) {
//                 final msg = currentMessages[currentMessages.length - 1 - index];
//                 return MessageBubble(message: msg);
//               },
//             ),
//           ),
//
//           if (_isLoading)
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               child: Row(
//                 children: [
//                   SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
//                   SizedBox(width: 12),
//                   Text('$selectedPersonality is typing...', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600])),
//                 ],
//               ),
//             ),
//
//           InputBar(
//             onSendMessage: handleSend,
//             isDarkMode: _isDarkMode,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
//           SizedBox(height: 16),
//           Text('Hello! I am $selectedPersonality.', style: TextStyle(fontSize: 18, color: Colors.grey[700], fontWeight: FontWeight.w500)),
//           Text('How can I help you today?', style: TextStyle(color: Colors.grey[500])),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/input_bar.dart';
import '../services/gemini_service.dart';


//stateful widgets use for ui if theres a changes
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  //history store the convo
  final Map<String, List<ChatMessage>> personaHistories = {
    "Doc Willbert": [],
    "Artist Luna": [],
    "Engr. Terra": [],
    "Travel advisor Ava": [],
    "Astronaut Hax": [],
  };

  List<ChatMessage> get currentMessages => personaHistories[selectedPersonality] ?? [];

  // for auto scroll variable
  final ScrollController scrollController = ScrollController();

  // Used to show the CircularProgressIndicator when waiting for AI response.
  bool _isLoading = false;

  // Toggles between Light and Dark themes.
  bool _isDarkMode = false;

  // start up personalities
  String selectedPersonality = "Doc Willbert";

  // Dito nakalagay ang persona sa burger menu
  final List<Map<String, String>> personas = [
    {"name": "Doc Willbert", "image": "assets/doctor.png", "desc": "Medical Expert"},
    {"name": "Artist Luna", "image": "assets/artist.png", "desc": "Academic Guide"},
    {"name": "Engr. Terra", "image": "assets/engineer.png", "desc": "Legal Advisor"},
    {"name": "Travel advisor Ava", "image": "assets/travelAdvisor.png", "desc": "Emotional Support"},
    {"name": "Astronaut Hax", "image": "assets/astronaut.png", "desc": "Space Explorer"},
  ];

  // --- LIFECYCLE METHODS ---

  //optimization
  @override
  void dispose() {
    scrollController.dispose(); //
    super.dispose();
  }

  // --- LOGIC FUNCTIONS ---

  // Adds a message to the local list and updates the UI.
  void addMessage(String text, String role) {
    setState(() {
      // We look up the list for the *current* personality and add the new message there.
      personaHistories[selectedPersonality]!.add(ChatMessage(
        text: text,
        role: role,
        timestamp: DateTime.now(),
      ));
    });
    // Triggers the auto-scroll to show the newest message.
    scrollToBottom();
  }

  // Animates the list to the bottom so the user sees the latest text.
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0.0, // Since ListView is reversed, 0.0 is the "bottom" (start of the list visually).
          duration: Duration(milliseconds: 800),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // The main function that handles sending text to Gemini.
  Future<void> handleSend(String text) async {
    // 1. Show user's message immediately
    addMessage(text, "user");

    // 2. Set loading state to true (shows the spinner)
    setState(() => _isLoading = true);

    try {
      // 3. Call the API service
      // We pass 'currentMessages' so the AI remembers the context of the conversation.
      final aiResponse = await GeminiService.sendMultiTurnMessage(
        currentMessages,
        text,
        personality: selectedPersonality,
      );

      // 4. Add the AI's response to the chat
      addMessage(aiResponse, "model");
    } catch (e) {
      // 5. Handle errors gracefully (e.g., no internet)
      addMessage('❌ Error: $e', "model");
    } finally {
      // 6. Turn off loading spinner regardless of success or failure
      setState(() => _isLoading = false);
    }
  }


  // --- UI CONSTRUCTION ---

  @override
  Widget build(BuildContext context) {
    // Dynamic styling based on Dark Mode toggle
    final bgColor = _isDarkMode ? Color(0xFF222831) : Color(0xFFECECEC);
    final textColor = _isDarkMode ? Colors.white : Colors.black87;
    final drawerColor = _isDarkMode ? Color(0xFF222831) : Colors.white;

    return Scaffold( //scaffold for visual structure
      backgroundColor: bgColor,

      // Top Bar = navbar
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Echo AI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Chatting with: $selectedPersonality', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
          ],
        ),
        actions: [
          // Custom button to open the END drawer (Settings)
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
        // Gradient background for AppBar
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF9bafd9),
                Color(0xFF103783),
              ],
            ),
          ),
        ),
        elevation: 2,
      ),

      // Left Drawer: Persona Selection
      drawer: Drawer(
        backgroundColor: drawerColor,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF103783),
                    Color(0xFF9bafd9),
                  ],
                ),
              ),
              accountName: Text("Select AI Persona"),
              accountEmail: Text("Choose who to talk to"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white70,
                child: Icon(Icons.psychology, color: Color(0xFF000000), size: 40),
              ),
            ),

            // List of personas generated from the 'personas' list
            Expanded(
              child: ListView.builder(
                itemCount: personas.length,
                itemBuilder: (context, index) {
                  final persona = personas[index]; // persona calling mapping
                  bool isSelected = selectedPersonality == persona['name'];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(persona['image']!),
                    ),
                    title: Text(
                      persona['name']!,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      persona['desc']!,
                      style: TextStyle(
                        color: _isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    // Visual cue (green check) for the active persona
                    trailing: isSelected ? Icon(Icons.check_circle, color: Colors.green) : null,
                    selected: isSelected,
                    onTap: () {
                      // Update state to switch persona and close drawer
                      setState(() {
                        selectedPersonality = persona['name']!;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Right Drawer: Settings (Dark Mode)
      endDrawer: Drawer(
        backgroundColor: drawerColor,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF103783), Color(0xFF9bafd9)],
                ),
              ),
              child: const Center(
                child: Text("Settings", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
            // Switch for Dark Mode
            SwitchListTile(
              secondary: Icon(
                _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: _isDarkMode ? Colors.amber : Colors.blue,
              ),
              title: Text(
                  "Dark Mode",
                  style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87)
              ),
              value: _isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
            const Divider(),
          ],
        ),
      ),

      // Main Content
      body: Column(
        children: [
          // Chat Area
          Expanded(
            child: currentMessages.isEmpty
                ? _buildEmptyState() // Show placeholder if no messages
                : ListView.builder(
              controller: scrollController,
              reverse: true, // IMPORTANT: Makes list start from bottom (standard for chats)
              padding: EdgeInsets.all(10),
              itemCount: currentMessages.length,
              itemBuilder: (context, index) {
                // Since 'reverse' is true, index 0 is at the bottom.
                // But our list adds new items to the END.
                // This math reverses the index access so the newest message (end of list) appears at the bottom (index 0).
                final msg = currentMessages[currentMessages.length - 1 - index];
                return MessageBubble(message: msg);
              },
            ),
          ),

          // Loading Indicator (only shows when waiting for API)
          if (_isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 12),
                  Text('$selectedPersonality is typing...', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600])),
                ],
              ),
            ),

          // Text Input Field
          InputBar(
            onSendMessage: handleSend,
            isDarkMode: _isDarkMode,
          ),
        ],
      ),
    );
  }

  // Helper widget to show when there are no messages yet
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text('Hello! I am $selectedPersonality.', style: TextStyle(fontSize: 18, color: Colors.grey[700], fontWeight: FontWeight.w500)),
          Text('How can I help you today?', style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }
}