part of 'sign_in_bloc.dart';

class SignInWithEmailEvent extends BaseEvent {
  SignInWithEmailEvent(this.email, this.password);

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class SignInWithGoogleEvent extends BaseEvent {}
