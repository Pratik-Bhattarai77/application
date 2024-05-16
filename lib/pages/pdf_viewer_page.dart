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
  bool isPlaying = false;
  bool isFullScreen = true;
  bool readEntireBook = false;
  String? bookText;
  DateTime lastTapTime = DateTime.fromMillisecondsSinceEpoch(0);

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
      final textExtractor = PdfTextExtractor(document);
      final bookText = textExtractor.extractText();

      setState(() {
        this.bookText = bookText;
      });
    } catch (e) {
      print('Error loading book text: $e');
    }
  }

  Future _speak() async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(1.0);
      await flutterTts.setVolume(1.0);
      await flutterTts.setSpeechRate(Platform.isAndroid ? 0.6 : 0.395);
      await flutterTts.awaitSpeakCompletion(true);

      if (readEntireBook && bookText != null) {
        await flutterTts.speak(bookText!);
      }

      if (selectedText != null && selectedText!.isNotEmpty) {
        await flutterTts.speak(selectedText!);
      }
    } catch (e) {
      print('Error setting voice: $e');
      await flutterTts.setVoice({"name": "Default", "locale": "en-US"});
      if (readEntireBook && bookText != null) {
        await flutterTts.speak(bookText!);
      }

      if (selectedText != null && selectedText!.isNotEmpty) {
        await flutterTts.speak(selectedText!);
      }
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

  void _handlePlayButtonTap() {
    setState(() {
      readEntireBook = !readEntireBook;
    });

    _speak();
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
            onPressed: _handlePlayButtonTap,
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
