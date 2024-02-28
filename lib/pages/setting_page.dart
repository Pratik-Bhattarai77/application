import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

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
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'lib/images/Settings.png',
                  height: 120,
                  width: 120,
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold, // Make text bold
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Welcome to E-Book, your ultimate destination for exploring and enjoying the world of literature in the digital age. At E-Book, we\'re passionate about bringing the joy of reading to your fingertips, making it easier and more convenient than ever to discover, purchase, and indulge in your favorite books.\n\n'
                  'Our app is designed with one goal in mind: to provide book lovers with a seamless and immersive reading experience. Whether you\'re an avid reader looking for your next literary adventure or someone new to the world of books, our platform offers something for everyone.\n\n'
                  'Here\'s what you can expect from E-Book:\n\n'
                  '- Vast Collection of Books: Dive into our extensive library featuring thousands of titles across various genres, from timeless classics to the latest bestsellers. With new additions regularly added to our catalog, there\'s always something exciting to explore.\n\n'
                  '- User-Friendly Interface: Our intuitive and user-friendly interface ensures that navigating through our app is effortless and enjoyable. Easily search for your favorite books, browse curated collections, and discover hidden gems with just a few taps.\n\n'
                  '- Personalized Recommendations: Let our smart recommendation engine guide you to your next great read. Based on your reading preferences and past interactions, we curate personalized book recommendations tailored specifically to your taste.\n\n'
                  '- Convenient Reading Options: Whether you prefer to read on your smartphone, tablet, or e-reader, E-Book offers flexible reading options to suit your lifestyle. Enjoy seamless synchronization across devices, allowing you to pick up where you left off, anytime, anywhere.\n\n'
                  '- Interactive Reading Experience: Enhance your reading experience with interactive features such as highlighting, bookmarking, and annotating your favorite passages. Engage with fellow book enthusiasts through community discussions, reviews, and recommendations.\n\n'
                  '- Secure and Reliable: Your privacy and security are our top priorities. Rest assured that your personal information and reading activity are kept safe and secure at all times.\n\n'
                  'Join our community of book lovers today and embark on a journey of literary exploration with E-Book, brought to you by Pratik Bhattrai. Happy reading!\n\n',
                  style: TextStyle(
                    color: Colors.black, // Text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
