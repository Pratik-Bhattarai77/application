import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // google Sing in
  signInWithGoogle() async {
    //begin process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    //obtain details
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credientail for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    //finally get in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
