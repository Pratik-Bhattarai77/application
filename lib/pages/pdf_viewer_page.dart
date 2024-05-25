import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// PDFViewerPage widget which accepts pdfUrl, bookTitle, and bookData as parameters
class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;
  final String bookTitle;

  PDFViewerPage({
    required this.pdfUrl,
    required this.bookTitle,
    required Map<String, dynamic> bookData,
  });

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? selectedText; // Variable to hold selected text from the PDF
  List<Map<String, dynamic>> notes =
      []; // List to store notes fetched from Firestore
  late FlutterTts flutterTts; // Text-to-Speech instance
  bool isPlaying = false; // TTS playing status
  bool isFullScreen = true; // Full screen mode toggle
  bool readEntireBook =
      false; // Flag to determine if the entire book should be read
  PdfDocument? document; // Variable to hold the PDF document
  int currentPageIndex = 0; // Current page index for reading the book
  double voiceSpeed = 1.0; // Voice speed for TTS

  @override
  void initState() {
    super.initState();
    // Initialize FlutterTts and set its handlers
    flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });
    flutterTts.setCompletionHandler(() async {
      // Handle completion for reading entire book
      if (readEntireBook) {
        currentPageIndex++;
        if (currentPageIndex < document!.pages.count) {
          await _speak();
        } else {
          setState(() {
            isPlaying = false;
            readEntireBook = false;
          });
        }
      } else {
        setState(() {
          isPlaying = false;
        });
      }
    });
    flutterTts.setErrorHandler((msg) {
      setState(() {
        isPlaying = false;
      });
    });

    loadDocument(); // Load the PDF document
    _fetchNotes(); // Fetch notes from Firestore
  }

  // Method to load PDF document from URL
  Future<void> loadDocument() async {
    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(widget.pdfUrl));
      final response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);
      httpClient.close();

      document = PdfDocument(inputBytes: bytes);

      setState(() {});
    } catch (e) {
      print('Error loading document: $e');
    }
  }

  // Method to start TTS for selected text or entire book
  Future _speak() async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(voiceSpeed); // Use voiceSpeed here
      await flutterTts.setVolume(1.0);
      await flutterTts.setSpeechRate(Platform.isAndroid ? 0.6 : 0.395);
      await flutterTts.awaitSpeakCompletion(true);

      if (readEntireBook && document != null) {
        final textExtractor = PdfTextExtractor(document!);
        final pageText = textExtractor.extractText(
            startPageIndex: currentPageIndex, endPageIndex: currentPageIndex);

        if (pageText.isNotEmpty) {
          await flutterTts.speak(pageText);
        } else {
          currentPageIndex++;
          if (currentPageIndex < document!.pages.count) {
            await _speak();
          } else {
            setState(() {
              isPlaying = false;
              readEntireBook = false;
            });
          }
        }
      } else if (selectedText != null && selectedText!.isNotEmpty) {
        await flutterTts.speak(selectedText!);
      }
    } catch (e) {
      print('Error setting voice: $e');
      await flutterTts.setVoice({"name": "Default", "locale": "en-US"});
      if (readEntireBook && document != null) {
        final textExtractor = PdfTextExtractor(document!);
        final pageText = textExtractor.extractText(
            startPageIndex: currentPageIndex, endPageIndex: currentPageIndex);

        if (pageText.isNotEmpty) {
          await flutterTts.speak(pageText);
        } else {
          currentPageIndex++;
          if (currentPageIndex < document!.pages.count) {
            await _speak();
          } else {
            setState(() {
              isPlaying = false;
              readEntireBook = false;
            });
          }
        }
      } else if (selectedText != null && selectedText!.isNotEmpty) {
        await flutterTts.speak(selectedText!);
      }
    }
  }

  // Method to stop TTS
  Future _stop() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      readEntireBook = false;
      currentPageIndex = 0;
    });
  }

  // Method to save selected text as a note in Firestore
  Future<void> _saveSelectedText() async {
    if (selectedText != null && selectedText!.isNotEmpty) {
      String formattedText = selectedText!;
      print('Saving selected text: $formattedText'); // Debugging output

      try {
        final userData = FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser?.uid);
        final noteData = {
          'bookTitle': widget.bookTitle,
          'content': formattedText,
          'fromSelectedText': true, // Add this line
        };

        await userData.collection('notes').add(noteData);
        print('Note saved successfully'); // Debugging output
        setState(() {});
      } catch (e) {
        print('Error saving note: $e'); // Error handling
      }
    }
  }

  // Method to handle play button tap
  void _handlePlayButtonTap() {
    if (selectedText != null && selectedText!.isNotEmpty) {
      _speak(); // Read the selected text
    } else {
      setState(() {
        readEntireBook = !readEntireBook;
        currentPageIndex = 0;
      });
      _speak(); // Read the entire book
    }
  }

  // Method to update TTS voice speed
  void _updateVoiceSpeed(double newSpeed) {
    setState(() {
      voiceSpeed = newSpeed;
      flutterTts.setSpeechRate(newSpeed);
    });
  }

  // Method to fetch notes from Firestore
  Future<void> _fetchNotes({bool fromSelectedText = false}) async {
    try {
      final userData = FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid);
      final notesSnapshot = await userData
          .collection('notes')
          .where('fromSelectedText', isEqualTo: fromSelectedText)
          .get();

      notes = notesSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {});
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

  // Method to display saved notes
  Future<void> _showSavedNotes() async {
    await _fetchNotes(
        fromSelectedText: true); // Fetch only notes created from selected text

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Highlighted Phrases'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: notes.map((note) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(note['content']),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 216, 211, 211),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          // Play button to start TTS
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              _handlePlayButtonTap();
            },
          ),
          // Stop button to stop TTS
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              _stop();
            },
          ),
          // Menu to select TTS speed
          PopupMenuButton<double>(
            icon: Icon(Icons.speed),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 0.5,
                  child: Text('Slow'),
                ),
                PopupMenuItem(
                  value: 1.0,
                  child: Text('Normal'),
                ),
                PopupMenuItem(
                  value: 1.5,
                  child: Text('Fast'),
                ),
              ];
            },
            onSelected: _updateVoiceSpeed,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            isFullScreen = !isFullScreen; // Toggle full screen mode
          });
        },
        child: Stack(
          children: [
            // PDF Viewer with text selection capability
            Visibility(
              visible: isFullScreen,
              child: document != null
                  ? SfPdfViewer.network(
                      widget.pdfUrl,
                      maxZoomLevel: 15.0,
                      onTextSelectionChanged:
                          (PdfTextSelectionChangedDetails details) {
                        setState(() {
                          selectedText = details.selectedText;
                        });
                        // Show dialog to save selected text as a note
                        if (selectedText != null && selectedText!.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Add Note'),
                                content: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      selectedText = value;
                                    });
                                  },
                                  controller:
                                      TextEditingController(text: selectedText),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text('Save'),
                                    onPressed: () {
                                      _saveSelectedText();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            // Button to show saved notes
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _showSavedNotes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                      255, 255, 153, 0), // Orange background color
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16),
                ),
                child: Icon(
                  Icons.note,
                  color: Colors.white, // White icon color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
