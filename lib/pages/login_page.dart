import 'package:application/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application/components/my_button.dart';
import 'package:application/components/my_textfield.dart';
import 'package:application/components/square_tile.dart';
import 'package:application/pages/password.reset.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  // Remove unnecessary super.key parameter from the constructor
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    // Check if email or password is empty
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Validation Error'),
            content: Text('Please insert your E-mail and password.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Exit the method if validation fails
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showValidationErrorDialog(e.code);
    }
  }

  void showValidationErrorDialog(String code) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Validation Error'),
          content: Text('Incorrect email or password.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void navigateToPasswordReset() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Password()),
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
                  'Welcome back!',
                  style: TextStyle(
                    color: Color.fromARGB(255, 94, 94, 94),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: navigateToPasswordReset,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 33, 155, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(
                  onTap: signUserIn,
                  text: 'Sign in',
                ),
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(255, 194, 193, 193),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Color.fromARGB(255, 98, 97, 97),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(255, 188, 187, 187),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'lib/images/google.png'),
                    const SizedBox(width: 25),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Do not have an Account?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 92, 91, 91),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
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
