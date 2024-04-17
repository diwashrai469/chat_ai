import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_ai/common/utils/constant.dart';
import 'package:chat_ai/core/network_services.dart';
import 'package:chat_ai/features/data/model/chat_messages_response_model.dart';
import 'package:chat_ai/features/data/model/previous_chat_message_model.dart';
import 'package:chat_ai/features/data/repository/home_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BuildContext context;
  HomeBloc({required this.context})
      : super(
          ChatSucessState(
            messages: previoudData(),
          ),
        ) {
    on<NewTextMessageGeneratEvent>(_handleNewChatMessages);
    on<NewChatEvent>(_handleNewChat);
  }

  List<PreviousChatMessageModel> messages = [];
  ScrollController listScrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  GetStorage localStorage = GetStorage();
  IHomeRepository homeRepository = HomeRepository();

  FutureOr<void> _handleNewChatMessages(
      NewTextMessageGeneratEvent event, Emitter<HomeState> emit) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    List<PreviousChatMessageModel> historyChat = previoudData();

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      messageController.clear();

      messages.addAll(historyChat);
      messages.add(
        PreviousChatMessageModel(
          role: "user",
          parts: [
            ChatPartModel(text: event.inputMessgae),
          ],
        ),
      );
      emit(ChatSucessState(messages: messages, isTextGenerating: true));

      var result = await homeRepository.getChatResponseFromAI(messages);

      result.fold(
        (NetworkFailure error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.grey.shade700,
              content: const Text(
                "Unable to fetch the data right now. Try again later!",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
          emit(ChatSucessState(messages: historyChat, isTextGenerating: false));
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
          emit(ChatSucessState(messages: messages, isTextGenerating: false));
          await localStorage.write(
            localStorageKeyForMessage,
            messages.map((message) => message.toJson()).toList(),
          );
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (listScrollController.hasClients) {
                listScrollController.animateTo(
                  listScrollController.position.maxScrollExtent,
                  curve: Curves.linear,
                  duration: const Duration(milliseconds: 500),
                );
              }
            },
          );
          messages = [];
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Check your internet connection!"),
        ),
      );
    }
  }

  FutureOr<void> _handleNewChat(NewChatEvent event, Emitter<HomeState> emit) {
    GetStorage().remove(localStorageKeyForMessage);
    messages = [];
    emit(ChatSucessState(messages: messages, isTextGenerating: false));
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
