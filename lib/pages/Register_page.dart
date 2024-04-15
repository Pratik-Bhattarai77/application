import 'package:application/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application/components/my_registerbutton.dart';
import 'package:application/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});
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

  // sign user in method
  Future signUserIn() async {
    // Regex pattern for email validation
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    // Check if any field is empty
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      displayMessage("Please fill in all fields.");
      return; // Exit the method if validation fails
    }

    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      displayMessage("Passwords do not match.");
      return; // Exit the method if validation fails
    }

    // Validate email format
    if (!emailRegex.hasMatch(usernameController.text)) {
      displayMessage("Please enter a valid email address.");
      return; // Exit the method if email format is invalid
    }

    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text.trim(),
          password: passwordController.text.trim());
      //user details
      addUserdetails(
          fullnameController.text.trim(), usernameController.text.trim());
      if (mounted) {
        // Check if the widget is still mounted
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => LoginPage(onTap: widget.onTap)),
        );
        ;
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
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
        backgroundColor: Theme.of(context)
            .dialogBackgroundColor, // Consistent with app theme
        title: Center(
          child: Text(
            'Alert!!',
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.color, // Consistent text color
            ),
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center, // Center the content text
          style: TextStyle(
            color: Theme.of(context)
                .textTheme
                .bodyText1
                ?.color, // Consistent text color
            fontSize: 18, // Increase font size to 18
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
          // Wrap with SingleChildScrollView
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.account_circle,
                  size: 100,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Lets Create an Account',
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
                  hintText: 'Confirm-Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 25),
                MyButtonR(
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
