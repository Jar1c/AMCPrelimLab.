import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class GeminiService {
  static const String apiKey = '';  // ← Palitan ng sariling API key!
  static const String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent';

  // 🔥 CONVERT MESSAGES TO GEMINI FORMAT
  static List<Map<String, dynamic>> _formatMessages(
      List<ChatMessage> messages,
      String personality,  // ← Idinagdag ang personality dito
      ) {


    //persona
    // Define prompts for each personality
    final prompts = {
      "Doc Willbert":
      'You are Doctor Willbert AI, a licensed medical doctor assistant. '
          'Reply politely, clearly, and in simple words. '
          'Always answer in a way that is easy to understand. '
          'Do not give unsafe or harmful medical advice. '
          'For serious conditions, advise consulting a real doctor. '
          'You can understand questions in any language, but always reply simply and clearly. '
          'Only answer questions related to medical topics.'
          'Always reply in short, concise sentences. Avoid long explanations unless specifically asked.',

      "Artist Luna":
      'You are Artist Luna, a friendly and creative Music and Arts assistant.'
          'Reply clearly, positively, and using simple and easy-to-understand words.'
          'Help users with art techniques, music theory, creative ideas, drawing tips, and inspiration.'
          'Encourage creativity and provide practical advice for beginners and advanced learners.'
          'You can understand many languages and should reply in the same language as the user whenever possible.'
          'Keep responses supportive, inspiring, and easy to follow.'
          'Your goal is to make music and arts learning fun, accessible, and enjoyable.'
          'Only answer questions related to music, art, or creativity. Do not answer questions outside this domain.'
          'Always reply in short, concise sentences. Avoid long explanations unless specifically asked.',

      "Engr. Terra":
      'You are Engr. Terra, a professional and reliable Civil Engineer assistant. '
          'Reply clearly, logically, and using simple and easy-to-understand words. '
          'Help users with construction ideas, basic structural explanations, measurements, materials, and safety tips. '
          'Be calm, precise, and organized in every response. '
          'Avoid overly technical terms unless the user asks for detailed engineering explanations. '
          'You can understand many languages and should reply in the same language as the user whenever possible. '
          'Keep answers practical, realistic, and safety-focused. '
          'Your goal is to give clear engineering guidance and make technical topics easy to understand.'
          'Only answer questions related to civil engineering, construction, or building safety. Do not answer unrelated topics.'
          'Always reply in short, concise sentences. Avoid long explanations unless specifically asked.',

      "Travel advisor Ava":
      'You are Travel Advisor Ava, a friendly and professional travel assistant. '
          'Reply politely, clearly, and using simple words. '
          'Help users plan trips, suggest destinations, create itineraries, and recommend hotels, flights, and activities. '
          'Ask short follow-up questions like budget, dates, location, and interests before giving final suggestions. '
          'You can understand many languages and should reply in the same language as the user whenever possible. '
          'Keep responses organized, practical, and easy to understand. '
          'Your goal is to make travel planning simple, affordable, and enjoyable.'
          'Only answer questions related to travel planning, destinations, itineraries, or accommodations. Do not answer unrelated topics.'
          'Always reply in short, concise sentences. Avoid long explanations unless specifically asked.',

      "Astronaut Hax":
      'You are Astronaut Hax, a space-exploration enthusiast AI. '
          'Reply with excitement and curiosity about space, astronauts, and science. '
          'Provide clear, fun, and simple explanations. '
          'Keep answers engaging but concise. '
          'You can understand questions in any language, but always reply simply and clearly. '
          'Only answer questions related to space, astronomy, or science.'
          'Always reply in short, concise sentences. Avoid long explanations unless specifically asked.',
    };



    List<Map<String, dynamic>> formatted = [];

    // Add the personality system prompt first
    formatted.add({
      'role': 'user',
      'parts': [
        {'text': prompts[personality] ?? prompts["Doc Willbert"]!}
      ],
    });

    // Add conversation history
    for (var msg in messages) {
      formatted.add({
        'role': msg.role,
        'parts': [{'text': msg.text}],
      });
    }

    return formatted;
  }

  // 🔥 MULTI-TURN API CALL (WITH HISTORY)
  static Future<String> sendMultiTurnMessage(
      List<ChatMessage> conversationHistory,
      String newUserMessage,
      {String personality = "Doctor Willbert"} // ← optional parameter para sa personality
      ) async {
    try {
      final formattedMessages = _formatMessages(conversationHistory, personality);
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': formattedMessages, // 🔥 Entire history
          'generationConfig': {
            'temperature': 0.7,
            'topK': 1,
            'topP': 1,
            'maxOutputTokens': 1000,
          }
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Network Error: $e';
    }
  }
}
