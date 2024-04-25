import 'dart:io';
import 'package:application/main.dart';
import 'package:application/pages/pdf_viewer_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('User')
              .doc('pOUxhmtf3E6I0e3jM0vG') // Use the actual document ID
              .collection('books')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No books found'),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        color: Color(0xFFFFEDD3),
                        margin: const EdgeInsets.all(16.0),
                        child: CachedNetworkImage(
                          imageUrl: data['image'] ?? '',
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                          height: 170,
                          width: 130,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 340, // Set the width
                        height: 180, // Set the height
                        child: Card(
                          color: Color(0xFFFFEDD3),
                          margin: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .start, // Align children to the start (left)
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
                                  textAlign: TextAlign
                                      .left, // Ensure text is left-aligned
                                ),
                              ),
                              SizedBox(
                                  height:
                                      35.0), // Add some space between the title and the button
                              ElevatedButton(
                                onPressed: () async {
                                  final pdfUrl = data['pdf'];
                                  if (pdfUrl == null) {
                                    setState(() {
                                      _errorMessage = 'PDF URL is null';
                                    });
                                    return;
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PDFViewerPage(
                                        pdfUrl: pdfUrl,
                                        bookTitle: data['tittle'] ?? '',
                                      ),
                                    ),
                                  );
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
                );
              }).toList(),
            );
          }),
    );
  }
}
