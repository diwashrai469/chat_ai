part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class NewTextMessageGeneratEvent extends HomeEvent {
  final String inputMessgae;

  NewTextMessageGeneratEvent({required this.inputMessgae});
}

class LocalStorageEmptyEvent extends HomeEvent {}
