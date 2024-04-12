import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_ai/core/network_services.dart';
import 'package:chat_ai/features/data/model/chat_messages_response_model.dart';
import 'package:chat_ai/features/data/model/previous_chat_message_model.dart';
import 'package:chat_ai/features/data/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<PreviousChatMessageModel> messagesTyped;
  BuildContext context;
  HomeBloc({required this.context, required this.messagesTyped})
      : super(
          ChatSucessState(
            messages: messagesTyped,
          ),
        ) {
    on<NewTextMessageGeneratEvent>(_handleNewChatMessages);
    on<LocalStorageEmptyEvent>(_handleLocalStorage);
  }

  List<PreviousChatMessageModel> messages = [];

  GetStorage localStorage = GetStorage();
  IHomeRepository homeRepository = HomeRepository();
  bool isTextGenerating = false;

  FutureOr<void> _handleNewChatMessages(
      NewTextMessageGeneratEvent event, Emitter<HomeState> emit) async {
    messages.addAll(messagesTyped);
    messages.add(
      PreviousChatMessageModel(
        role: "user",
        parts: [
          ChatPartModel(text: event.inputMessgae),
        ],
      ),
    );
    emit(ChatSucessState(messages: messages));
    await localStorage.write("messages", messages);
    isTextGenerating = true;

    var result = await homeRepository.getChatResponseFromAI(messages);

    result.fold(
      (NetworkFailure error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Somthing went wrong!"),
          ),
        );
      },
      (ChatMessageResponseModel data) async {
        messages.add(
          PreviousChatMessageModel(
            role: "model",
            parts: [
              ChatPartModel(
                  text: data.candidates?.first.content?.parts?.first.text ??
                      "Not able to generate answer.Try again")
            ],
          ),
        );
        emit(ChatSucessState(messages: messages));
        await localStorage.write("messages", messages);

        isTextGenerating = false;
      },
    );
  }

  FutureOr<void> _handleLocalStorage(
      LocalStorageEmptyEvent event, Emitter<HomeState> emit) {
    localStorage.remove("messages");
    emit(ChatSucessState(messages: const []));
  }
}

List<PreviousChatMessageModel> previoudData() {
  List<dynamic> messagesDynamic = GetStorage().read("messages") ?? [];
  return messagesDynamic.map((jsonString) {
    return PreviousChatMessageModel.fromJson(jsonString);
  }).toList();
}
