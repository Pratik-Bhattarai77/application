import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;
  final String bookTitle;

  PDFViewerPage({required this.pdfUrl, required this.bookTitle});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? selectedText;
  List<Map<String, dynamic>> notes = [];
  late FlutterTts flutterTts;
  String? speakingText;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  Future _speak(String text) async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
      await flutterTts.setSpeechRate(1.0);
      await flutterTts.setVolume(50.0);
      await flutterTts.setSpeechRate(Platform.isAndroid ? 0.6 : 0.395);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(text);
    } catch (e) {
      print('Error setting voice: $e');
      await flutterTts.setVoice({"name": "Default", "locale": "en-US"});
      await flutterTts.speak(text);
    }
  }

  Future _stop() async {
    await flutterTts.stop();
  }

  Future _pause() async {
    await flutterTts.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 216, 211, 211),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              if (speakingText != null) {
                _speak(speakingText!);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: _stop,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SfPdfViewer.network(
              widget.pdfUrl,
              maxZoomLevel: 15.0,
              onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                setState(() {
                  selectedText = details.selectedText;
                  speakingText = details
                      .selectedText; // Assign selected text to speakingText
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                // Display the book title only once, at the top of the list
                if (index == 0) {
                  return ListTile(
                    title: Text(widget.bookTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    subtitle: Text(notes[index]['content'],
                        textAlign: TextAlign.justify),
                  );
                } else {
                  return ListTile(
                    title: Text(notes[index]['content'],
                        textAlign: TextAlign.justify),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedText != null && selectedText!.isNotEmpty) {
            String formattedText = selectedText!;
            notes.add({
              'Hilight Note': widget.bookTitle,
              'content': formattedText,
            });
            setState(() {});
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
