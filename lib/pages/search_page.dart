// search_page.dart

import 'dart:io';
import 'package:application/pages/pdf_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _errorMessage;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 52, 52, 52),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(0, 0, 0, 0),
                  borderRadius: BorderRadius.circular(55),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 147, 146, 146),
                    hintText: "Search books...",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  onChanged: (value) {
                    // Trigger the search when the text changes
                    setState(() {});
                  },
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        titleSpacing: 0,
        automaticallyImplyLeading: false,
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

            // Filter the books based on the search query
            List<DocumentSnapshot> filteredDocs = [];
            if (_searchController.text.isNotEmpty) {
              filteredDocs = snapshot.data!.docs.where((doc) {
                // Check if the book title contains the search query
                return doc['tittle']
                    .toString()
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase());
              }).toList();
            } else {
              filteredDocs = snapshot.data!.docs;
            }

            return ListView(
              children: filteredDocs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Color.fromARGB(255, 30, 30, 30),
                    margin: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: data['image'] ?? '',
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                              height: 140,
                              width: 120,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: Colors.white, // Border color
                                    width: 2, // Border width
                                  ),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  data['tittle'] ?? '',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final pdfUrl = data[
                                'pdf']; // Directly use the pdf URL from Firestore
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
                                  bookTitle: 'tittle',
                                ),
                              ),
                            );
                          },
                          child: Text('Read book'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            onPrimary: Colors.white,
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
                );
              }).toList(),
            );
          }),
    );
  }

  Future<String?> _fetchPdfUrl(String pdfName) async {
    try {
      final ref = FirebaseStorage.instance.ref();
      var childref = ref.child('book1/I Will Kill The Author c1-141.pdf');
      return await childref.getDownloadURL();
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
      return null;
    }
  }

  Future<String?> _downloadPDF(String pdfUrl) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/book.pdf');
      await FirebaseStorage.instance.refFromURL(pdfUrl).writeToFile(file);
      print('PDF downloaded to ${file.path}');
      return file.path;
    } catch (e) {
      print('Error downloading PDF: $e');
      return null;
    }
  }
}
