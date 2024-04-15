part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class ChatLoadingState extends HomeState {}

final class ChatSucessState extends HomeState {
  final List<PreviousChatMessageModel> messages;
  final bool isTextGenerating;

  ChatSucessState({required this.messages, this.isTextGenerating = false});
}
