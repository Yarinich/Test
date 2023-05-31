import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:machine/data/models/user_model.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;

  final _googleSignIn = GoogleSignIn();

  // TODO: remove later
  UserModel? getUser() {
    final user = _auth.currentUser;

    return user != null
        ? UserModel(
            name: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: user.photoURL,
          )
        : null;
  }

  Future<UserModel?> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    /// створюю аккаунт з такою поштою та паролен
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    /// змінюю ім'я юзера
    await _auth.currentUser?.updateDisplayName(name);

    final user = _auth.currentUser;

    return user != null
        ? UserModel(
            name: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: user.photoURL,
          )
        : null;
  }

  Future<UserModel?> signInWithEmail(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;

    return user != null
        ? UserModel(
            name: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: user.photoURL,
          )
        : null;
  }

  Future<UserModel?> signInWithGoogle() async {
    final googleAccount = await _googleSignIn.signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleAccount?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    /// авторизуватись у Firebase
    final userCreds =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final user = userCreds.user;

    return user != null
        ? UserModel(
            name: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: user.photoURL,
          )
        : null;
  }

  /// Future.wait метод який визиває всі методи в ньому паралельно
  Future<void> signOut() => Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
}
