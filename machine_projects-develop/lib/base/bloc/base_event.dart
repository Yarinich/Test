part of 'base_bloc.dart';

@immutable
abstract class BaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ErrorEvent extends BaseEvent {
  ErrorEvent({this.msg, this.data});

  final String? msg;
  final dynamic data;

  @override
  List<Object?> get props => [msg, data];
}

class NewLinkEvent extends BaseEvent {
  NewLinkEvent(this.link);

  final String link;

  @override
  List<Object> get props => [link];
}

class OpenScreenEvent extends BaseEvent {}

class ProgressEvent extends BaseEvent {}

class GetCurrentUserEvent extends BaseEvent {}

class RebuildEvent extends BaseEvent {}
