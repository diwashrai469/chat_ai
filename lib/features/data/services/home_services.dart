import 'package:chat_ai/common/utils/constant.dart';
import 'package:chat_ai/features/data/model/chat_messages_response_model.dart';
import 'package:chat_ai/features/data/model/previous_chat_message_model.dart';
import 'package:dio/dio.dart';

class HomeServices {
  final Dio _dio = Dio();
  Future<ChatMessageResponseModel> getChatResponseFromAI(
      List<PreviousChatMessageModel> previousMessage) async {
    var response = await _dio.post(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro:generateContent?key=$api_key",
        data: {
          "contents": previousMessage.map((e) => e.toMap()).toList(),
          "generationConfig": {
            "temperature": 0.9,
            "topK": 1,
            "topP": 1,
            "maxOutputTokens": 2048,
            "stopSequences": []
          },
          "safetySettings": [
            {
              "category": "HARM_CATEGORY_HARASSMENT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_HATE_SPEECH",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            }
          ]
        });
    return ChatMessageResponseModel.fromJson(response.data);
  }
}
