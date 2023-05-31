part of 'sign_up_bloc.dart';

class SignUpEvent extends BaseEvent {
  SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}

class SignUpWithGoogleEvent extends BaseEvent {}
