import 'package:chat_ai/core/network_services.dart';
import 'package:chat_ai/features/data/model/chat_messages_response_model.dart';
import 'package:chat_ai/features/data/model/previous_chat_message_model.dart';
import 'package:chat_ai/features/data/services/home_services.dart';
import 'package:dartz/dartz.dart';

abstract class IHomeRepository {
  Future<Either<NetworkFailure, ChatMessageResponseModel>>
      getChatResponseFromAI(List<PreviousChatMessageModel> previousMessage);
}

class HomeRepository extends IHomeRepository {
  final HomeServices _homeServices = HomeServices();
  @override
  Future<Either<NetworkFailure, ChatMessageResponseModel>>
      getChatResponseFromAI(
          List<PreviousChatMessageModel> previousMessage) async {
    try {
      var result = await _homeServices.getChatResponseFromAI(previousMessage);
      return right(result);
    } on NetworkFailure catch (e) {
      return left(e);
    }
  }
}
