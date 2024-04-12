import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Password extends StatefulWidget {
  const Password({Key? key}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context)
                .dialogBackgroundColor, // Use theme's dialog background color
            title: Center(
              child: Text(
                'Success',
                style: TextStyle(
                    color: Color.fromARGB(
                        255, 23, 23, 23)), // Assuming white text for clarity
              ),
            ),
            content: Text(
              "Password reset link sent! Check your email",
              style: TextStyle(
                  color: const Color.fromARGB(
                      255, 30, 30, 30)), // Assuming white text for clarity
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context)
                  .dialogBackgroundColor, // Use theme's dialog background color
              content: Text(
                "Incorrect Email",
                style: TextStyle(
                    color: const Color.fromARGB(
                        255, 38, 38, 38)), // Assuming white text for clarity
              ),
            );
          },
        );
      } else {
        print(e);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context)
                  .dialogBackgroundColor, // Use theme's dialog background color
              title: Center(
                child: Text(
                  'Validation Error',
                  style: TextStyle(
                      color: Colors.white), // Assuming white text for clarity
                ),
              ),
              content: Text(
                e.message.toString(),
                style: TextStyle(
                    color: const Color.fromARGB(
                        255, 39, 39, 39)), // Assuming white text for clarity
              ),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 218, 218),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 219, 218, 218),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: const Text(
              'Enter your Email and we will send you a link to reset your password',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: passwordReset,
            child: const Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange, // Button color
              onPrimary: Colors.white, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Border radius
              ),
            ),
          ),
        ],
      ),
    );
  }
}
