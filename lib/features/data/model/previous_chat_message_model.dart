// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PreviousChatMessageModel {
  final String role;
  final List<ChatPartModel> parts;

  PreviousChatMessageModel({required this.role, required this.parts});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role,
      'parts': parts.map((x) => x.toMap()).toList(),
    };
  }

  factory PreviousChatMessageModel.fromMap(Map<String, dynamic> map) {
    return PreviousChatMessageModel(
      role: map['role'] as String,
      parts: List<ChatPartModel>.from(
        (map['parts'] as List<dynamic>).map<ChatPartModel>(
          (partMap) => ChatPartModel.fromMap(partMap as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PreviousChatMessageModel.fromJson(String source) =>
      PreviousChatMessageModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class ChatPartModel {
  final String text;
  ChatPartModel({required this.text});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
    };
  }

  factory ChatPartModel.fromMap(Map<String, dynamic> map) {
    return ChatPartModel(
      text: map['text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatPartModel.fromJson(String source) =>
      ChatPartModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
