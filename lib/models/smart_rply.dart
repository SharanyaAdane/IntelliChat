import 'package:intelli_ca/models/geminiAI_service.dart';

class GenerateSmartReply {
  final OpenAIService openAIService = OpenAIService();

  Future<List<String>> generateReply(String latestMsg) async {
    String prompt =
        "I am sharing a message text you need to generate three best replies for that message in 7-8 words, just generate those 3 messages separated by * symbol, no extra message. Here's the message: $latestMsg";
    try {
      final speech = await openAIService.chatGPTAPI(prompt);
      return speech.split(
          '*'); // Assuming the response is a single string with replies separated by *
    } catch (e) {
      print('Error generating smart reply: $e');
      return [];
    }
  }
}

/*class GenerateSmartReply {
  Future<List<String>> generateReply(String latestMsg) async {
    // Mock smart replies for demonstration purposes
    return Future.delayed(const Duration(seconds: 1), () {
      return ['Reply 1', 'Reply 2', 'Reply 3'];
    });
  }
}*/
