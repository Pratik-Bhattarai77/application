import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  String? selectedText;
  List<Map<String, dynamic>> notes = [];
  late FlutterTts flutterTts;
  bool isPlaying = false;
  bool isFullScreen = true;
  bool readEntireBook = false;
  PdfDocument? document;
  int currentPageIndex = 0;
  double voiceSpeed = 1.0; // Default speed

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });
    flutterTts.setCompletionHandler(() async {
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

    loadDocument();
  }

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
          // Handle empty text (page with only images)
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

  Future _stop() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      readEntireBook = false;
      currentPageIndex = 0;
    });
  }

  Future<void> _saveSelectedText() async {
    if (selectedText != null && selectedText!.isNotEmpty) {
      String formattedText = selectedText!;
      final userData = FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid);
      final noteData = {
        'bookTitle': widget.bookTitle,
        'content': formattedText,
      };
      await userData.collection('notes').add(noteData);
      setState(() {});
    }
  }

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

  void _updateVoiceSpeed(double newSpeed) {
    setState(() {
      voiceSpeed = newSpeed;
      flutterTts.setSpeechRate(newSpeed);
    });
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
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              _handlePlayButtonTap();
            },
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              _stop();
            },
          ),
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
            isFullScreen = !isFullScreen;
          });
        },
        child: Stack(
          children: [
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveSelectedText();
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
