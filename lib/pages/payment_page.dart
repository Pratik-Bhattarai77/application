import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    final double aspectRatio = 16 / 9;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageHeight = screenWidth / aspectRatio;

    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 60, 59, 59), // Black Scaffold background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Logo placed outside the card, full width
            Image.asset(
              'lib/images/books.png', // Path to your logo image
              width: screenWidth, // Full width
              height: imageHeight, // Adjusted height based on aspect ratio
              fit: BoxFit.cover,
            ),
            SizedBox(height: 80.0),
            _buildSubscriptionCard(
              title: 'Monthly Subscription',
              description: 'Access to all books for a month',
              price: '1000 NPR',
              animationPath: 'lib/images/good.json',
              onTap: () {
                // Placeholder for initiating payment
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required String title,
    required String description,
    required String price,
    required String animationPath,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Color.fromARGB(255, 85, 84, 84), // Darker card color
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200, // Adjust the height as needed
                child: Lottie.asset(
                  animationPath, // Use Lottie.asset to load the animation
                  width: double.infinity, // Adjust the width as needed
                  height: 200, // Adjust the height as needed
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 48, 48,
                      48), // Black background for the textual content and button
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text for contrast
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white, // White text for contrast
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Green price text for contrast
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 251, 162,
                                  29)), // Set the button color to orange
                        ),
                        child: Text(
                          'Subscribe',
                          style: TextStyle(
                              color: Colors
                                  .white), // Ensure the text is white for contrast
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
