import 'package:machine/base/bloc/base_bloc.dart';

class AppInitializedState extends ActionState {}

class SplashEndedState extends NavigationState {}

class UserState extends NavigationState {
  UserState({required this.isUserLogged});

  final bool isUserLogged;

  @override
  List<Object> get props => [isUserLogged];
}

class MoveToNoInternetPage extends NavigationState {}
