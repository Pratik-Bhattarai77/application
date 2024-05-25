import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application/pages/pdf_viewer_page.dart';

// LibraryPage widget to display user's read books
class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

// State class for LibraryPage
class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Get the current user

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      body: user != null
          ? StreamBuilder<QuerySnapshot>(
              // Stream to get the list of read books from Firestore for the current user
              stream: FirebaseFirestore.instance
                  .collection('User')
                  .doc(user.uid) // Use the user's ID
                  .collection('readBooks')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No books in your library',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return PageView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    // Get the book data
                    Map<String, dynamic> data = snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>;
                    return Center(
                      child: Container(
                        width: 340,
                        margin: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Container to display book image
                            Container(
                              width: 340,
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(data['image'] ?? ''),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(height: 60),
                            // Container to display book title and read button
                            Container(
                              height: 159,
                              width: 340,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFEDD3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['tittle'] ?? '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 35),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final pdfUrl = data['pdf'];
                                        if (pdfUrl == null) {
                                          return;
                                        }
                                        // Navigate to PDFViewerPage
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PDFViewerPage(
                                              pdfUrl: pdfUrl,
                                              bookTitle: data['tittle'] ?? '',
                                              bookData: data,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black),
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
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : Center(
              child: Text('Please log in to access your library'),
            ),
    );
  }
}
