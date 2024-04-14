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
    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 60, 59, 59), // Black Scaffold background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildSubscriptionCard(
              title: 'Monthly Subscription',
              description: 'Access to all books for a month',
              price: '1000 NPR',
              animationPath:
                  'lib/images/good.json', // Use animation path instead of image path
              onTap: () {
                // Placeholder for initiating payment
              },
            ),
            SizedBox(height: 16.0),
            _buildSubscriptionCard(
              title: 'Annual Subscription',
              description: 'Access to all books for a year',
              price: '12000 NPR',
              animationPath:
                  'lib/images/good.json', // Use animation path instead of image path
              onTap: () {
                // Placeholder for initiating payment
              },
            ),
            // Add more subscription options as needed
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
              // Container for the textual content and the "Subscribe" button with black background
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
                    // "Subscribe" button inside the black-background container
                    // Inside the _buildSubscriptionCard method, where the "Subscribe" button is defined
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
