import 'dart:io';
import 'package:application/main.dart';
import 'package:application/pages/libary_page.dart';
import 'package:application/pages/pdf_viewer_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';

class BookInfoPage extends StatefulWidget {
  final String? bookId;
  const BookInfoPage({Key? key, this.bookId}) : super(key: key);

  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  String? _errorMessage;
  DocumentSnapshot? _bookDoc; // Store the specific book document

  @override
  void initState() {
    super.initState();
    print("Fetching book with ID: ${widget.bookId}");
    fetchBookDetails();
  }

  Future<void> fetchBookDetails() async {
    try {
      print("jkdfjdkfjkdsnfh: ${widget.bookId}");
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc('pOUxhmtf3E6I0e3jM0vG')
          .collection('books')
          .doc(widget.bookId)
          .get();
      // .doc('9ivb6AN79kcNsHQsq0cw')
      print("Query path: User/pOUxhmtf3E6I0e3jM0vG/books/${widget.bookId}");

      if (documentSnapshot.exists) {
        setState(() {
          _bookDoc = documentSnapshot;
        });
      } else {
        print("Document does not exist");
        setState(() {
          _errorMessage = "Document does not exist";
        });
      }
    } catch (error) {
      print("Error fetching document: $error");
      setState(() {
        _errorMessage = "Error fetching document";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bookDoc == null) {
      return Center(child: CircularProgressIndicator());
    }

    Map<String, dynamic> data = _bookDoc!.data() as Map<String, dynamic>;

    return Scaffold(
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
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Color(0xFFFFEDD3),
                  margin: const EdgeInsets.all(16.0),
                  child: CachedNetworkImage(
                    imageUrl: data['image'] ?? '',
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                    height: 250,
                    width: 190,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 255, 255, 255)
                                .withOpacity(0.5),
                            spreadRadius: 6,
                            blurRadius: 5,
                            offset: Offset(0, 4),
                          ),
                        ],
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 340,
                  height: 180,
                  child: Card(
                    color: Color(0xFFFFEDD3),
                    margin: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            data['tittle'] ?? '',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                color: Color.fromARGB(255, 0, 0, 0)),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 35.0),
                        ElevatedButton(
                          onPressed: () async {
                            final pdfUrl = data['pdf'];
                            if (pdfUrl == null) {
                              setState(() {
                                _errorMessage = 'PDF URL is null';
                              });
                              return;
                            }

                            // Navigate to PDFViewerPage
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PDFViewerPage(
                                  pdfUrl: pdfUrl,
                                  bookTitle: data['tittle'] ?? '',
                                  bookData: data,
                                ),
                              ),
                            );

                            // Get the currently authenticated user's ID
                            final user = FirebaseAuth.instance.currentUser;

                            if (user != null) {
                              // Store the book data in the user-specific subcollection
                              final userBooks = FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(user
                                      .uid) // Use the user's ID instead of a hardcoded value
                                  .collection('readBooks');

                              await userBooks.doc(data['id']).set(data);
                            }
                          },
                          child: Text('Read book'),
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 0, 0, 0),
                            onPrimary: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
