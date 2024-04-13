import 'package:application/pages/Auth_page.dart';
import 'package:application/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey:
          'test_public_key_b4a66361b76b4349bcfca4e30e8789f6', // Replace with your actual public key
      enabledDebugging: false, // Set to false in production
      builder: (context, navKey) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navKey,
          home: const AuthPage(),
          // home: const Payment(),
        );
      },
    );
  }
}
