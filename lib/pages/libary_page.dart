import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final List<String> bookImages = [
    'lib/images/Rectangle 2.png',
    'lib/images/Rectangle 8.png',
    'lib/images/Rectangle 28.png',
    // Add more book images as needed
  ];

  final List<String> bookDescriptions = [
    '"Legendary assassin seeks vengeance after thugs kill his beloved dog, leading to a relentless and action-packed pursuit of justice."',
    '"Orphaned wizard Harry Potter discovers his magical heritage, battles dark forces, and learns the power of friendship at Hogwarts School."',
    '"The Psychology of Money" explores the behavioral aspects of finance, revealing insights into decision-making and wealth management in 20 words.',
    // Add more descriptions as needed
  ];

  final List<String> bookTitles = [
    'Jon Wick',
    'Harry Potter',
    'The Psychology of Money',
    // Add more titles as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      body: PageView.builder(
        itemCount: bookImages.length,
        itemBuilder: (context, index) {
          return Center(
            child: Container(
              width: 340,
              margin: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 340,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(bookImages[index]),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                    SizedBox(
                      height: 159,
                      width: 340,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFEDD3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookTitles[
                                  index], // Use corresponding title for each book
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  bookDescriptions[
                                      index], // Use corresponding description for each book
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Action to perform when the button is pressed
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                ),
                                child: Text(
                                  'Read',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
