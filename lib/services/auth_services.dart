import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google Sign in
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Begin process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Check if the user actually signed in
      if (googleUser == null) {
        // User did not sign in, handle accordingly
        return null;
      }

      // Obtain details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Finally, get in
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // Handle any errors that occur during the sign-in process
      print("Error signing in with Google: $e");
      return null;
    }
  }
}
