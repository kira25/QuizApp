import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  createAccount(String email, String password) async {
    UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

  updateProfile(User user, String displayName) async {
    await user.updateProfile(displayName: displayName);
    await user.reload();
    User newUser = _auth.currentUser;
    return newUser;
  }

  getCurrentuser() {
    final User user = _auth.currentUser;
    print('getCurrentUser : $user');
    return user;
  }

  signOut() {
    _auth.signOut();
  }

  signInWithEmailAndPassword(String username, password) async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
              email: username, password: password))
          .user;
      return user;
    } on FirebaseException catch (e) {
      print('Exception:  ${e.message}');
    }
  }

  sendPasswordResetEmail(String email) async {
    print('SendEmail');
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<User> signInWithGoogle() async {
   try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User user = result.user;

     
      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }
}
