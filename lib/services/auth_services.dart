import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/constants/app_colors.dart';
import '/pages/auth/sign_in/sign_in_vm.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<SignInStatus> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      servicesResultPrint('Sign In Successful');
      return SignInStatus.successful;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          servicesResultPrint('Invalid email');
          return SignInStatus.invalidEmail;
        case 'user-disabled':
          servicesResultPrint('User disabled');
          return SignInStatus.userDisabled;
        case 'user-not-found':
          servicesResultPrint('User not found');
          return SignInStatus.userNotFound;
        case 'wrong-password':
          servicesResultPrint('Wrong password');
          return SignInStatus.wrongPassword;
        default:
          return SignInStatus.wrongPassword;
      }
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    servicesResultPrint('Sign out');
  }

  User? currentUser() {
    if (_firebaseAuth.currentUser == null) {
      servicesResultPrint('Current user not found', isToast: false);
      return null;
    }
    servicesResultPrint("Current user: ${_firebaseAuth.currentUser!.uid}",
        isToast: false);
    return _firebaseAuth.currentUser;
  }

  void servicesResultPrint(String result, {bool isToast = true}) async {
    print("FirebaseAuthentication services result: $result");
    if (isToast)
      await Fluttertoast.showToast(
        msg: result,
        timeInSecForIosWeb: 2,
        backgroundColor: AppColors.kWhiteBackground,
        textColor: AppColors.kText,
      );
  }
}