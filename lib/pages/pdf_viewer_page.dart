import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

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
  String? speakingText;
  bool isPlaying = false;
  bool isFullScreen = true;
  bool readEntireBook = false;
  String? bookText;

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

    loadBookText();
  }

  Future<void> loadBookText() async {
    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(widget.pdfUrl));
      final response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);

      final document = PdfDocument(inputBytes: bytes);
      final pages = document.pages;
      final bookTextBuffer = StringBuffer();

      for (int i = 0; i < pages.count; i++) {
        final page = pages[i];
        final textExtractor = PdfTextExtractor(page as PdfDocument);
        final text = textExtractor.extractText();
        bookTextBuffer.write(text);
      }

      setState(() {
        bookText = bookTextBuffer.toString();
      });
    } catch (e) {
      print('Error loading book text: $e');
    }
  }

  Future _speak(String text) async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
      await flutterTts.setSpeechRate(1.0);
      await flutterTts.setVolume(200.0);
      await flutterTts.setSpeechRate(Platform.isAndroid ? 0.6 : 0.395);
      await flutterTts.awaitSpeakCompletion(true);

      if (readEntireBook && bookText != null) {
        await flutterTts.speak(bookText!);
      } else {
        await flutterTts.speak(text);
      }
    } catch (e) {
      print('Error setting voice: $e');
      await flutterTts.setVoice({"name": "Default", "locale": "en-US"});
      await flutterTts.speak(text);
    }
  }

  Future _stop() async {
    await flutterTts.stop();
  }

  void _saveSelectedText() {
    if (selectedText != null && selectedText!.isNotEmpty) {
      String formattedText = selectedText!;
      notes.add({
        'Highlight Note': widget.bookTitle,
        'content': formattedText,
      });
      setState(() {});
    }
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
                setState(() {
                  readEntireBook = !readEntireBook;
                });
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
              child: SfPdfViewer.network(
                widget.pdfUrl,
                maxZoomLevel: 15.0,
                onTextSelectionChanged:
                    (PdfTextSelectionChangedDetails details) {
                  setState(() {
                    selectedText = details.selectedText;
                    speakingText = details.selectedText;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveSelectedText,
        child: Icon(Icons.save),
      ),
    );
  }
}
