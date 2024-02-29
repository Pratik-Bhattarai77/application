import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true, // Center the title text
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go to the previous page
          },
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('lib/images/cho.png'),
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}