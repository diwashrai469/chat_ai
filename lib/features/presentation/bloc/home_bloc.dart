import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_ai/common/utils/constant.dart';
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
  }

  List<PreviousChatMessageModel> messages = [];
  ScrollController listScrollController = ScrollController();

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
    await localStorage.write(localStorageKeyForMessage, messages);
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
        await localStorage.write(localStorageKeyForMessage, messages);

        isTextGenerating = false;
      },
    );
  }
}

//dont know why but the return type of local storage messgaes is lIST<DYNAMIC> instead of list<PreviousChatMessageModel>
//so converting the type to List<PreviousChatMessageModel>
List<PreviousChatMessageModel> previoudData() {
  List<dynamic> messagesDynamic =
      GetStorage().read(localStorageKeyForMessage) ?? [];
  return messagesDynamic.map((jsonString) {
    return PreviousChatMessageModel.fromJson(jsonString);
  }).toList();
}
