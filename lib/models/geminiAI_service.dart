import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

class OpenAIService {
  List<Map<String, String>> messages = [];

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });

    final apiKey =
        'AIzaSyBg7OawX9OfLrNvYg2iZ7ba2xXdK2MgR5o'; // Ensure your secrets file provides the API key
    if (apiKey == null) {
      print('No API_KEY found in secrets.');
      return 'API key is missing.';
    }

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final content = [Content.text(prompt)];

    try {
      final response = await model.generateContent(content);

      messages.add({
        'role': 'assistant',
        'content': response.text!,
      });

      return response.text!;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
