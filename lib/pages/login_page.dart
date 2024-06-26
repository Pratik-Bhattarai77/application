import 'package:application/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application/components/my_button.dart';
import 'package:application/components/my_textfield.dart';
import 'package:application/components/square_tile.dart';
import 'package:application/pages/password.reset.dart';

// LoginPage widget which represents the login screen
class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  // Method to sign in the user using email and password
  Future<void> signUserIn() async {
    setState(() {
      _isLoading = true; // Start the loading indicator
    });

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      if (mounted) {
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
                    setState(() {
                      _isLoading = false; // Stop the loading indicator
                    });
                  },
                ),
              ],
            );
          },
        );
      }
      return; // Exit the method if validation fails
    }

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((_) {
        // Sign-in successful, stop the loading indicator
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        if (mounted) {
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
                      setState(() {
                        _isLoading = false; // Stop the loading indicator
                      });
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Validation Error'),
              content: Text(e.message ?? 'An unknown error occurred.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _isLoading = false; // Stop the loading indicator
                    });
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Method to sign in the user using Google
  Future<void> signInWithGoogle() async {
    setState(() {
      _isLoading = true; // Start the loading indicator
    });

    try {
      await AuthService().signInWithGoogle().then((_) {
        // Google sign-in successful, stop the loading indicator
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(
                    'An error occurred during Google sign-in. Please try again later.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _isLoading = false; // Stop the loading indicator
                      });
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'An error occurred during Google sign-in. Please try again later.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _isLoading = false; // Stop the loading indicator
                    });
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Navigate to Password Reset Page
  void navigateToPasswordReset() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Password()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                  onTap: _isLoading ? null : signUserIn,
                  text: _isLoading ? '' : 'Sign in',
                  child: _isLoading ? CircularProgressIndicator() : null,
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
                      onTap: _isLoading ? null : signInWithGoogle,
                      imagePath: 'lib/images/google.png',
                      child: _isLoading ? CircularProgressIndicator() : null,
                    ),
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
