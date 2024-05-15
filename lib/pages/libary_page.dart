import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application/pages/pdf_viewer_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      body: user != null
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('User')
                  .doc(user.uid)
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

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        color: Color.fromARGB(255, 52, 52, 52),
                        margin: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: CachedNetworkImage(
                                imageUrl: data['image'] ?? '',
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                                height: 160,
                                width: 120,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Apply borderRadius here
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                // Use BoxDecoration here
                                color: Color(
                                    0xFFFFEDD3), // Specify color within BoxDecoration
                                borderRadius: BorderRadius.circular(
                                    8.0), // Apply borderRadius here
                              ), // End BoxDecoration
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['tittle'] ?? '',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .black), // Adjusted text color for contrast
                                  ),
                                  SizedBox(height: 20.0),
                                  Center(
                                    // Place the button inside its own Center widget
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final pdfUrl = data['pdf'];
                                        if (pdfUrl == null) {
                                          // Handle null PDF URL error
                                          return;
                                        }
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
                                      child: Text('Read Book'),
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color.fromARGB(
                                            255, 18, 18, 18),
                                        onPrimary: Colors.white,
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
                  }).toList(),
                );
              },
            )
          : Center(
              child: Text('Please log in to access your library'),
            ),
    );
  }
}
