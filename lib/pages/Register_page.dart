import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:application/components/my_button.dart';
import 'package:application/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullnameController = TextEditingController();

  @override
  void dispose() {
    fullnameController.dispose();
    super.dispose();
  }

  Future signUserIn() async {
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      displayMessage("Please fill in all fields.");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      displayMessage("Passwords do not match.");
      return;
    }

    if (!emailRegex.hasMatch(usernameController.text)) {
      displayMessage("Please enter a valid email address.");
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text.trim(),
          password: passwordController.text.trim());
      addUserdetails(
          fullnameController.text.trim(), usernameController.text.trim());
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        displayMessage(e.message ?? 'An error occurred. Please try again.');
      }
    }
  }

  Future addUserdetails(String fullname, String email) async {
    await FirebaseFirestore.instance
        .collection("User")
        .add({"Full name": fullname, "email": email});
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Center(
          child: Text(
            'Alert!!',
            style: TextStyle(
              color:
                  Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
            ),
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 18,
          ),
        ),
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 219, 218, 218),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Let\'s Create an Account',
                  style: TextStyle(
                    color: Color.fromARGB(255, 94, 93, 94),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: fullnameController,
                  hintText: 'Full Name',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: usernameController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 25),
                MyButton(
                  onTap: signUserIn,
                  text: 'Sign Up',
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already Have an Account?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 92, 91, 91),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Color.fromARGB(255, 30, 146, 241),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
