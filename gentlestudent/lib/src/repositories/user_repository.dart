import 'package:firebase_auth/firebase_auth.dart';
import 'package:gentlestudent/src/network/authentication_api.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final AuthenticationApi _authenticationApi;

  UserRepository(
      {FirebaseAuth firebaseAuth, AuthenticationApi authenticationApi})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _authenticationApi = authenticationApi ?? AuthenticationApi();

  Future<void> signInWithCredentials(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      print("Something went wrong during the sign in process: $error");
    }
  }

  Future<void> signUp(String firstName, String lastName, String education,
      String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (await isSignedIn()) {
        FirebaseUser firebaseUser = await getUser();

        UserUpdateInfo userUpdateInfo = UserUpdateInfo();
        userUpdateInfo.displayName = "$firstName $lastName";
        firebaseUser.updateProfile(userUpdateInfo);

        firebaseUser.sendEmailVerification();

        await _authenticationApi.addUserToFirestore(
            firstName, lastName, education, email, firebaseUser.uid);
      }
    } catch (error) {
      print("Something went wrong while creating an account: $error");
    }
  }

  Future<void> signOut() async => Future.wait([
        _firebaseAuth.signOut(),
      ]);

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<bool> hasVerifiedEmail() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser.isEmailVerified;
  }

  Future<FirebaseUser> getUser() async => await _firebaseAuth.currentUser();

  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch(error) {
      print("An error occurred while sending the password reset email: $error");
    }
  }

  Future<bool> editFirebaseUser(String name, String email) async {
    FirebaseUser user = await getUser();
    if (user == null) return false;

    if (email != user.email) {
      try {
        await user.updateEmail(email);
        await user.sendEmailVerification();
      } catch (error) {
        print("Error changing email: $error");
        return false;
      }
    }

    if (name != user.displayName) {
      UserUpdateInfo info = UserUpdateInfo()
        ..displayName = name;

      try {
        await user.updateProfile(info);
      } catch (error) {
        print("Error changing name and institute: $error");
        return false;
      }
    }

    return true;
  }
}
