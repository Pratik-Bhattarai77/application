import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 52, 52, 52),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'lib/images/Group.png', // Adjust the image path accordingly
                height: 120, // Adjust the height as needed
                width: 120, // Adjust the width as needed
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Help',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHelpItem(
                      'Help & Support',
                      'What do you need help with?',
                    ),
                    _buildDivider(),
                    _buildHelpItem(
                      'Help Center',
                      'Head over to our Help Center and read articles about how to use Wattpad, or check out our Known Issues page to see what bugs we\'re currently working on fixing.',
                    ),
                    _buildDivider(),
                    _buildHelpItem(
                      'Chat with our Virtual Helper',
                      'Want quick answers? Our Virtual Helper is the fastest way to get information on anything related to Wattpad.',
                    ),
                    _buildDivider(),
                    _buildHelpItem(
                      'Submit a Support Ticket',
                      'Having an issue we haven\'t addressed in the Help Center? Contact our Support team.',
                    ),
                    _buildDivider(),
                    _buildHelpItem(
                      'Shake for Help',
                      'Get to the Help Center from anywhere in the app.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return SizedBox(height: 20);
  }
}
